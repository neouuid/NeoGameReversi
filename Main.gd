extends Control

const BOARD_SIZE: int = 8
var board: Array[Array] = [] # 2D array, 0: empty, 1: black, 2: white
var current_turn: int = 1 # 1: black, 2: white
var cells: Array[Cell] = [] # 1D array of Cell nodes

var game_mode: int = 0 # 0: PvP, 1: PvE (Player is Black, AI is White)
var ai_timer: float = 0.0
var ai_thinking: bool = false

@onready var grid: GridContainer = $BoardContainer/Grid
@onready var turn_label: Label = $UI/Margin/HBox/TurnLabel
@onready var black_score: Label = $UI/Margin/HBox/BlackScore
@onready var white_score: Label = $UI/Margin/HBox/WhiteScore
@onready var game_over_panel: Panel = $UI/GameOverPanel
@onready var winner_label: Label = $UI/GameOverPanel/VBox/WinnerLabel

func _ready() -> void:
	$UI/GameOverPanel/VBox/RestartPVPButton.pressed.connect(start_game.bind(0))
	$UI/GameOverPanel/VBox/RestartPvEButton.pressed.connect(start_game.bind(1))
	
	# Initialize UI grid
	for y in range(BOARD_SIZE):
		var row: Array[int] = []
		board.append(row)
		for x in range(BOARD_SIZE):
			row.append(0)
			
			var cell: Cell = Cell.new()
			cell.grid_pos = Vector2(x, y)
			cell.clicked.connect(_on_cell_clicked)
			grid.add_child(cell)
			cells.append(cell)
			
	# Show initial start menu
	game_over_panel.show()
	winner_label.text = "Neo Reversi"

func start_game(mode: int = 0) -> void:
	game_mode = mode
	game_over_panel.hide()
	current_turn = 1
	ai_thinking = false
	
	# Clear board
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):
			board[y][x] = 0
			
	# Initial 4 pieces
	board[3][3] = 2
	board[4][4] = 2
	board[3][4] = 1
	board[4][3] = 1
	
	update_board()

func get_cell_index(x: int, y: int) -> int:
	return y * BOARD_SIZE + x

func update_board() -> void:
	var valid_moves: Array[Vector2] = get_all_valid_moves(current_turn)
	
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):
			var cell: Cell = cells[get_cell_index(x, y)]
			cell.set_piece(board[y][x])
			cell.set_valid_move(Vector2(x, y) in valid_moves)
			
	update_ui()
			
	if valid_moves.size() == 0:
		# Check if the other player has valid moves
		var other_turn: int = 3 - current_turn
		var other_moves: Array[Vector2] = get_all_valid_moves(other_turn)
		if other_moves.size() == 0:
			end_game()
		else:
			# Pass turn
			current_turn = other_turn
			update_board()

func update_ui() -> void:
	var black: int = 0
	var white: int = 0
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):
			if board[y][x] == 1: black += 1
			elif board[y][x] == 2: white += 1
			
	black_score.text = "Black: %d" % black
	white_score.text = "White: %d" % white
	
	var turn_text: String = "Black" if current_turn == 1 else "White"
	if game_mode == 1 and current_turn == 2:
		turn_text += " (AI)"
	turn_label.text = "Turn: " + turn_text

func _process(delta: float) -> void:
	if game_mode == 1 and current_turn == 2 and not ai_thinking:
		var moves: Array[Vector2] = get_all_valid_moves(current_turn)
		if moves.size() > 0:
			ai_thinking = true
			ai_timer = 0.5 # delay for realistic feel
		
	if ai_thinking:
		ai_timer -= delta
		if ai_timer <= 0:
			ai_thinking = false
			play_ai_turn()

func play_ai_turn() -> void:
	var valid_moves: Array[Vector2] = get_all_valid_moves(2)
	if valid_moves.size() == 0:
		return
		
	# Simple Greedy AI: pick the move that flips the most pieces
	var best_move: Vector2 = valid_moves[0]
	var max_flips: int = 0
	
	for move in valid_moves:
		var flips: Array[Vector2] = get_flips(int(move.x), int(move.y), 2)
		if flips.size() > max_flips:
			max_flips = flips.size()
			best_move = move
			
	# Apply best move
	var flips: Array[Vector2] = get_flips(int(best_move.x), int(best_move.y), 2)
	board[int(best_move.y)][int(best_move.x)] = 2
	for f in flips:
		board[int(f.y)][int(f.x)] = 2
		
	current_turn = 1
	update_board()

func _on_cell_clicked(pos: Vector2) -> void:
	if ai_thinking or (game_mode == 1 and current_turn == 2):
		return
		
	var x: int = int(pos.x)
	var y: int = int(pos.y)
	
	if board[y][x] != 0: return
	
	var flips: Array[Vector2] = get_flips(x, y, current_turn)
	if flips.size() > 0:
		board[y][x] = current_turn
		for f in flips:
			board[int(f.y)][int(f.x)] = current_turn
			
		current_turn = 3 - current_turn
		update_board()

func get_all_valid_moves(player: int) -> Array[Vector2]:
	var valid_moves: Array[Vector2] = []
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):
			if board[y][x] == 0:
				if get_flips(x, y, player).size() > 0:
					valid_moves.append(Vector2(x, y))
	return valid_moves

func get_flips(x: int, y: int, player: int) -> Array[Vector2]:
	var flips: Array[Vector2] = []
	var opponent: int = 3 - player
	var dirs: Array[Vector2] = [
		Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1),
		Vector2(-1, 0),                  Vector2(1, 0),
		Vector2(-1, 1),  Vector2(0, 1),  Vector2(1, 1)
	]
	
	for d in dirs:
		var r: int = 1
		var cur_flips: Array[Vector2] = []
		while true:
			var nx: int = x + int(d.x) * r
			var ny: int = y + int(d.y) * r
			if nx < 0 or nx >= BOARD_SIZE or ny < 0 or ny >= BOARD_SIZE:
				break
			
			var p: int = board[ny][nx]
			if p == opponent:
				cur_flips.append(Vector2(nx, ny))
			elif p == player:
				flips.append_array(cur_flips)
				break
			else: # empty
				break
			r += 1
			
	return flips

func end_game() -> void:
	var black: int = 0
	var white: int = 0
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):
			if board[y][x] == 1: black += 1
			elif board[y][x] == 2: white += 1
			
	var result: String = ""
	if black > white: result = "Black Wins!"
	elif white > black: result = "White Wins!"
	else: result = "Draw!"
	
	winner_label.text = result
	game_over_panel.show()

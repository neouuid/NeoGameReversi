extends Control
class_name Cell

signal clicked(grid_pos: Vector2)

var grid_pos: Vector2 = Vector2.ZERO
var piece: int = 0 # 0 = empty, 1 = black, 2 = white
var valid_move: bool = false

func _ready() -> void:
	custom_minimum_size = Vector2(32, 32)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	mouse_filter = Control.MOUSE_FILTER_PASS
	resized.connect(queue_redraw)

func set_piece(p_piece: int) -> void:
	piece = p_piece
	queue_redraw()

func set_valid_move(valid: bool) -> void:
	valid_move = valid
	queue_redraw()

func _draw() -> void:
	# Draw background
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.2, 0.25, 0.3))
	
	# Draw grid line outline
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.1, 0.12, 0.15), false, 2.0)
	
	# Draw piece
	var center: Vector2 = size / 2.0
	var radius: float = min(size.x, size.y) * 0.4
	
	if piece == 1:
		draw_circle(center, radius, Color.BLACK)
	elif piece == 2:
		draw_circle(center, radius, Color.WHITE)
	elif valid_move:
		draw_circle(center, radius * 0.2, Color(0, 0, 0, 0.3))

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		clicked.emit(grid_pos)

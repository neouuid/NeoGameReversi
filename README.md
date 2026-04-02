# Neo Reversi

A modern, sleek Reversi (Othello) game built with Godot Engine 4.

## 🌟 Features
- **PvP Mode**: Play locally against a friend on the same screen.
- **PvE Mode**: Play against a built-in Greedy AI (Player plays as Black, AI plays as White).
- **Responsive UI**: The game board and UI elements automatically scale and maintain their aspect ratio on any window size.
- **Modern Aesthetic**: Clean, dark-blue/grey modern theme.
- **Static Typing**: Fully statically typed GDScript code for better performance, maintainability, and code reliability.
- **Ready to Export**: Includes configuration (`export_presets.cfg`) to quickly export as a standalone Windows executable.

## 🎮 How to Play
1. **Black** always makes the first move.
2. Players take turns placing their pieces on the board.
3. A valid move must capture at least one of the opponent's pieces by flanking them in a straight line (horizontal, vertical, or diagonal).
4. If a player cannot make a valid move, their turn is skipped.
5. The game ends when neither player can make a valid move, or the board is completely filled.
6. The player with the most pieces on the board wins!

## 🚀 Running the Project
1. Download and install [Godot Engine 4.x](https://godotengine.org/download/).
2. Clone this repository: 
   ```bash
   git clone https://github.com/yourusername/neo-reversi.git
   ```
3. Open Godot, click **Import**, and select the `project.godot` file in this folder.
4. Click the **Run** button (or press `F5`) to start the game.

## 📦 Exporting (Windows)
The project comes with a predefined configuration for Windows Desktop.
1. Open the project in Godot.
2. Go to **Project -> Export**.
3. Select the **Windows Desktop** preset. *(If prompted, download the missing Export Templates)*.
4. Click **Export Project**, uncheck "Export With Debug", and choose your destination folder.

## � Changelog
- **v1.0.1**: Fixed a UI scaling bug where the board container's grid node path caused a crash during initialization.
- **v1.0.0**: Initial release with PvP/PvE modes, static typing, and responsive layout.

## �📄 License
This project is open-source and available under the [BSD 3-Clause License](LICENSE).


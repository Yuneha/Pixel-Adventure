# Pixel Adventure

Pixel Adventure is a mobile platformer game built with [Flutter](https://flutter.dev/) and [Flame](https://flame-engine.org/), designed as a learning project for game development on mobile devices.

## Features

- **Multiple Levels:** Play through a series of challenging platformer levels.
- **Character Selection:** Choose from different character skins, each with unique idle animations.
- **Touch Controls:** On-screen joystick, jump, and pause buttons for mobile gameplay.
- **Sound Effects:** Toggle sound and adjust volume in the settings menu.
- **Pause & Resume:** Pause the game at any time and resume where you left off.
- **Timer & Best Time:** Track your elapsed time and try to beat your best score.
- **Collectibles & Power-ups:** Pick up fruits for double jump and wall jump abilities.
- **Enemies & Hazards:** Avoid spikes, saws, and chickens as you progress.
- **Checkpoints:** Reach checkpoints to save your progress within a level.

## Tools used

- [Tiled](https://www.mapeditor.org/) - *for map editing*

## Screenshots

*WIP*

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart) (usually included with Flutter)
- A device or emulator to run the game

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yuneha/pixel_adventure.git
   cd pixel_adventure
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Run the game:**
   ```sh
   flutter run
   ```

### Project Structure

- `lib/`
  - `components/` – Game objects (player, enemies, items, etc.)
  - `screens/` – UI screens (main menu, settings, pause, etc.)
  - `widgets/` – Reusable UI widgets (buttons, overlays, etc.)
  - `pixel_adventure.dart` – Main game logic and state management
  - `main.dart` – Entry point

### Assets

All game assets (images, audio, etc.) are located in the `assets/` directory and are referenced in [`pubspec.yaml`](pubspec.yaml).

## Controls

- **Joystick:** Move left/right
- **Jump Button:** Jump or double jump (with power-up)
- **Pause Button:** Pause the game

## Learning Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flame Engine Documentation](https://docs.flame-engine.org/)
- [Pixel Adventure game tutorial](https://www.youtube.com/watch?v=Kwn1eHZP3C4&list=PLRRATgFqhVCh8qD7xmaSbwG1vfaCddvCM)

## License

This project was for learning purposes. Feel free to use and modify it!

---

*Made with ❤️ using Flutter and Flame*
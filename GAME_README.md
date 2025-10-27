# Color Match Puzzle Game 🎮

A beautiful, feature-rich Flutter puzzle game built following Domain-Driven Design (DDD) principles and clean architecture.

## ✨ Features

- **Beautiful Modern UI**: Material Design 3 with custom theming
- **Responsive Design**: Optimized for both phones and tablets
- **Match-3 Puzzle Gameplay**: Swap adjacent tiles to create matches
- **Score System**: Track your score, level, moves, and matches
- **Game State Persistence**: Save and load your game progress
- **Smooth Animations**: Lottie animations for loading and error states
- **Clean Architecture**: DDD with separated layers (Domain, Data, Presentation)

## 🏗️ Architecture

The game follows **Domain-Driven Design (DDD)** with three main layers:

### Domain Layer
- **Entities**: Pure Dart classes representing game domain objects
  - `GameTile`: Represents a single tile on the board
  - `GameScore`: Tracks player progress and statistics

- **Repositories**: Abstract interfaces defining data operations
  - `GameRepository`: Defines game operations (generate board, save score, etc.)

### Data Layer
- **Models**: Freezed models for data serialization
  - `GameTileModel`: Maps to `GameTile` entity
  - `GameScoreModel`: Maps to `GameScore` entity

- **Repository Implementations**: Concrete implementations of domain repositories
  - `GameRepositoryImpl`: Handles board generation, score persistence

- **Dependency Injection**: GetIt setup for feature dependencies

### Presentation Layer
- **BLOC**: State management using flutter_bloc
  - `GameBloc`: Manages game state and logic
  - `GameEvent`: User actions (tile tap, reset, save, load)
  - `GameState`: Current game state (board, score, loading, etc.)

- **Pages**: Game screens
  - `GamePage`: Main game screen

- **Widgets**: Reusable UI components
  - `GameBoardWidget`: Displays the game board
  - `GameTileWidget`: Individual tile widget
  - `ScoreBoardWidget`: Score display

## 🎨 Design

- **Color Palette**: 8 vibrant colors for game tiles
- **Typography**: Google Fonts (Poppins for headings, Inter for body)
- **Theme**: Light and dark mode support
- **Shadows & Depth**: Multi-layered shadows for premium feel
- **Animations**: Smooth tile selection and swap animations

## 🚀 Getting Started

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Code (Freezed Models)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run the Game
```bash
flutter run
```

## 🎯 How to Play

1. **Select a Tile**: Tap any tile to select it (it will show a star icon)
2. **Swap Tiles**: Tap an adjacent tile to swap positions
3. **Create Matches**: Match 3 or more tiles of the same color to score points
4. **Score Points**: Each match gives you 10 points
5. **Track Progress**: Monitor your score, moves, and total matches
6. **Save Your Game**: Use the save button to save your progress
7. **Start Fresh**: Use the "New Game" button to reset

## 📱 Platform Support

- ✅ Android (Phones & Tablets)
- ✅ iOS (Phones & Tablets)
- ✅ Web
- ✅ Desktop (Windows, macOS, Linux)

## 🛠️ Technologies

- **State Management**: flutter_bloc
- **Dependency Injection**: get_it
- **Models**: freezed + json_serializable
- **Networking**: dio (NetworkClient)
- **Storage**: shared_preferences
- **Navigation**: go_router
- **UI**: flutter_screenutil (responsive), google_fonts
- **Animations**: lottie

## 📁 Project Structure

```
lib/
├── core/                      # Core app infrastructure
│   ├── di/                    # Dependency injection (GetIt)
│   ├── network/               # NetworkClient for API calls
│   ├── routing/               # App routing (go_router)
│   ├── theme/                 # App theming
│   ├── utils/                 # Utilities (PageState enum)
│   └── widgets/               # Reusable widgets (Lottie)
├── features/
│   └── game/                  # Game feature
│       ├── data/              # Data layer
│       │   ├── di/           # Feature DI
│       │   ├── models/       # Freezed models
│       │   └── repositories/ # Repository impls
│       ├── domain/            # Domain layer
│       │   ├── entities/     # Domain entities
│       │   └── repositories/ # Repository interfaces
│       └── presentation/      # Presentation layer
│           ├── bloc/         # BLOC (events, states, bloc)
│           ├── pages/        # Game pages
│           └── widgets/      # Game widgets
├── constants/                 # Game constants
└── main.dart                  # App entry point
```

## 🎨 Game Design

The game features:
- **8x8 Grid**: Classic puzzle game board
- **5 Colors**: Vibrant tile colors for matching
- **Visual Feedback**: Selected tiles show star icon with glow effect
- **Score Tracking**: Real-time score updates
- **Smooth Animations**: Tile swaps and selections

## 🔧 Customization

### Change Board Size
Edit `GameStarted` event in `game_bloc.dart`:
```dart
GameStarted(rows: 10, cols: 10, colorCount: 6)
```

### Add More Colors
Edit `GameColors` in `constants/game_colors.dart`:
```dart
static const List<Color> colors = [
  // Add your colors here
];
```

### Modify Scoring
Edit the scoring logic in `game_bloc.dart`:
```dart
score: state.score.score + matches.length * 10, // Change multiplier
```

## 📝 Code Quality

- ✅ SOLID principles
- ✅ Clean Architecture
- ✅ DDD pattern
- ✅ Immutable state
- ✅ Error handling
- ✅ Type safety (null safety)
- ✅ Responsive design
- ✅ Accessibility ready

## 🚧 Next Steps (Optional Enhancements)

- [ ] Add sound effects
- [ ] Add more game modes
- [ ] Leaderboard system
- [ ] Power-ups and special tiles
- [ ] Tutorial mode
- [ ] Achievements system
- [ ] Online multiplayer

## 📄 License

This project is created as a demonstration of Flutter game development with clean architecture.

---

**Enjoy the game!** 🎉


# Color Match Puzzle Game - Setup Guide

## Overview
A beautiful Flutter puzzle game built with Domain-Driven Design (DDD) architecture, following clean architecture principles.

## Architecture
- **Domain Layer**: Entities and repository interfaces
- **Data Layer**: Models (Freezed), repository implementations, dependency injection
- **Presentation Layer**: BLOC state management, pages, and widgets

## Setup Instructions

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Code (Freezed models)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Run the App
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── di/                    # Dependency injection setup
│   ├── network/               # NetworkClient for API calls
│   ├── routing/               # App routing configuration
│   ├── theme/                 # App theming
│   ├── utils/                 # Utilities (PageState)
│   └── widgets/               # Reusable widgets (Lottie animations)
├── features/
│   └── game/
│       ├── data/              # Data layer
│       │   ├── di/           # Feature DI setup
│       │   ├── models/       # Freezed models
│       │   └── repositories/ # Repository implementations
│       ├── domain/            # Domain layer
│       │   ├── entities/     # Domain entities
│       │   └── repositories/ # Repository interfaces
│       └── presentation/      # Presentation layer
│           ├── bloc/         # BLOC state management
│           ├── pages/        # Game pages
│           └── widgets/      # Game widgets
└── constants/                 # Game constants (colors)
```

## Game Features

- **Beautiful UI**: Modern Material Design 3 with custom theming
- **Responsive**: Works on phones and tablets using flutter_screenutil
- **State Management**: BLOC pattern for clean state management
- **Game Logic**: Match-3 puzzle game with scoring system
- **Save/Load**: Game state persistence using SharedPreferences
- **Animations**: Lottie animations for loading/error states

## Technologies Used

- **BLOC**: State management
- **GetIt**: Dependency injection
- **Freezed**: Immutable models with code generation
- **Dio**: HTTP client for API calls
- **flutter_screenutil**: Responsive design
- **google_fonts**: Beautiful typography
- **Lottie**: Animations
- **go_router**: Navigation
- **SharedPreferences**: Local storage

## Game Rules

1. Tap a tile to select it
2. Tap an adjacent tile to swap them
3. Match 3 or more tiles of the same color to score points
4. Try to achieve the highest score possible!

## Next Steps

1. Run `flutter pub get` to install dependencies
2. Run `dart run build_runner build --delete-conflicting-outputs` to generate Freezed code
3. Run `flutter run` to start the game
4. Enjoy playing!


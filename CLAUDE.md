# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application (version 3.32.8) built with Dart SDK ^3.8.1. The project is currently a basic Flutter demo app with a counter feature.

## Development Commands

### Essential Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run the app on a specific device/platform
flutter run -d ios       # iOS simulator
flutter run -d android   # Android emulator
flutter run -d chrome    # Web browser

# Analyze code for problems
flutter analyze

# Run tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart

# Build for release
flutter build apk        # Android APK
flutter build ios        # iOS (requires Mac with Xcode)
flutter build web        # Web

# Clean build artifacts
flutter clean

# Upgrade Flutter dependencies
flutter pub upgrade
```

### Hot Reload and Hot Restart

When running the app with `flutter run`:
- Press `r` for hot reload (maintains state)
- Press `R` for hot restart (resets state)
- Press `q` to quit

## Project Structure

```
cactusdemo/
├── lib/                    # Dart source code
│   └── main.dart          # Entry point and main app widget
├── test/                   # Unit and widget tests
│   └── widget_test.dart   # Basic widget test
├── android/               # Android-specific configuration
├── ios/                   # iOS-specific configuration
├── web/                   # Web-specific configuration
├── pubspec.yaml           # Dependencies and project configuration
└── analysis_options.yaml  # Dart analyzer configuration
```

## Architecture

The application follows the standard Flutter architecture:

1. **Entry Point**: `lib/main.dart` contains the `main()` function that runs `MyApp`
2. **App Widget**: `MyApp` is a StatelessWidget that sets up the MaterialApp with theming
3. **Home Screen**: `MyHomePage` is a StatefulWidget demonstrating state management with a counter
4. **State Management**: Uses `setState()` for local state management in `_MyHomePageState`

## Code Conventions

- Uses Material Design components (`MaterialApp`, `Scaffold`, `AppBar`, etc.)
- Follows Flutter's widget composition pattern
- Uses `const` constructors where possible for performance
- Includes flutter_lints package for code quality enforcement
- Test files follow the pattern `*_test.dart` in the `test/` directory

## Platform-Specific Notes

- **Android**: Package name is `com.flutterseoul.cactusdemo` (MainActivity.kt)
- **iOS**: Uses Swift for native code (AppDelegate.swift)
- **Web**: Includes PWA manifest and icons

## Dependencies

- `cupertino_icons: ^1.0.8` - iOS-style icons
- `flutter_lints: ^5.0.0` (dev) - Linting rules
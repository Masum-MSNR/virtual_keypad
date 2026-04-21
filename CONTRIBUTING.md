# Contributing to Virtual Keypad

Thank you for your interest in contributing! This guide will help you get started.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/virtual_keypad.git
   cd virtual_keypad
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   cd example && flutter pub get && cd ..
   ```

## Development Workflow

### Running Tests

```bash
flutter test
```

### Running the Example App

```bash
cd example
flutter run
```

### Code Style

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Run `dart format .` before committing
- Ensure `flutter analyze` passes with no errors

## Making Changes

### Branch Naming

- `feature/description` - New features
- `fix/description` - Bug fixes
- `docs/description` - Documentation updates

### Commit Messages

Use clear, descriptive commit messages:

```
feat: add haptic feedback support
fix: keyboard layout reset on close
docs: update README installation section
```

### Pull Request Process

1. Create a feature branch from `main`
2. Make your changes with tests
3. Ensure all tests pass
4. Update documentation if needed
5. Submit a PR with a clear description

### PR Checklist

Before opening a PR, verify all relevant items below:

- `flutter test` passes for the package
- `flutter analyze` passes for the package
- Public API changes are reflected in `README.md` and `doc/` guides
- User-facing behavior changes are covered by widget or unit tests
- Accessibility-impacting UI changes were checked for semantics and labels
- Example app content was updated if the recommended integration path changed

## Adding Features

### New Keyboard Layout

See [Adding Languages Guide](doc/adding-languages.md)

### New Theme

See [Theming Guide](doc/theming.md)

### New Actions

1. Add to `KeyAction` enum in `lib/src/enums.dart`
2. Handle in `_handleAction()` in `lib/src/widgets/keyboard.dart`
3. Add icon/label in `_buildKeyContent()`
4. Add or update semantics labels and hints for the new action
5. Update documentation
6. Add regression tests for the new action behavior

## Reporting Issues

- Use the [issue tracker](https://github.com/Masum-MSNR/virtual_keypad/issues)
- Include Flutter version (`flutter --version`)
- Provide minimal reproduction code
- Include screenshots/videos if UI-related

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

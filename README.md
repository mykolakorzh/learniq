# LearnIQ

A Flutter-based German language learning app focused on vocabulary acquisition through visual learning and spaced repetition.

## 🎯 About

LearnIQ helps users learn German vocabulary across multiple topics including:
- **Fahrzeug** (Vehicles) - Transportation vocabulary
- **Kleidung** (Clothing) - Apparel and accessories
- **Natur** (Nature) - Natural world vocabulary
- **Stadt** (City) - Urban locations and buildings
- **Tiere** (Animals) - Animal vocabulary
- **Körper** (Body) - Body parts
- **Wohnung** (Home) - Household items and rooms

## 📱 Features

- Interactive flashcard learning
- Text-to-speech pronunciation
- Progress tracking and statistics
- Multiple learning modes (Learn, Test)
- Multi-language support (English, Ukrainian, Russian)
- Offline functionality

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (latest stable version)
- Xcode (for iOS development)
- Git LFS (optional, for large assets)

### Installation

```bash
# Clone the repository
git clone https://github.com/mykolakorzh/learniq.git
cd learniq

# Install dependencies and apply patches
./scripts/pub_get.sh

# Run the app
flutter run
```

## 📚 Documentation

- **[Commit Guidelines](docs/COMMIT_GUIDELINES.md)** - Best practices for Git workflow
- **[Full Documentation](docs/README.md)** - Complete project documentation
- **[Quick Commands](QUICK_COMMANDS.md)** - Frequently used commands
- **[Claude Workflow](CLAUDE_WORKFLOW.md)** - AI-assisted development workflow

## 🛠️ Development

### Daily Workflow

```bash
# Check for uncommitted changes
./scripts/check_commits.sh

# Make your changes, then commit
git add .
git commit -m "feat: your feature description"
git push origin main
```

### Building for TestFlight

See [docs/COMMIT_GUIDELINES.md](docs/COMMIT_GUIDELINES.md) for the complete TestFlight build workflow.

## 📦 Project Structure

```
learniq/
├── assets/          # Images, data files, and animations (~764MB)
├── docs/            # Project documentation
├── ios/             # iOS-specific configuration
├── lib/             # Flutter/Dart source code
├── patches/         # Dependency patches (flutter_tts)
├── scripts/         # Build and utility scripts
└── web/             # Web platform assets
```

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 🌍 Localization

Supported languages:
- English (en)
- Ukrainian (uk)
- Russian (ru)

Localization files: `lib/l10n/`

## 🔧 Troubleshooting

### flutter_tts Issues
If you encounter issues with text-to-speech:
```bash
./scripts/apply_patches.sh
```

### Build Issues
```bash
flutter clean
flutter pub get
./scripts/apply_patches.sh
pod install --repo-update  # iOS only
```

## 📄 License

[Add your license here]

## 👤 Author

Mykola Korzh

## 🔗 Links

- **Repository**: https://github.com/mykolakorzh/learniq
- **TestFlight**: [Coming soon]

## 📝 Version

Current version: Check `pubspec.yaml`

---

For detailed development guidelines, see the [documentation](docs/README.md).

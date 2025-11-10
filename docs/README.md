# Learniq Documentation

Welcome to the Learniq project documentation!

## 📚 Available Documentation

### Development Workflow
- **[Commit Guidelines](COMMIT_GUIDELINES.md)** - Best practices for Git commits and pushing changes
  - When to commit
  - How to write good commit messages
  - TestFlight build workflow
  - Asset management tips

## 🛠️ Quick Start for Development

### Daily Workflow
1. Check for uncommitted changes: `./scripts/check_commits.sh`
2. Pull latest changes: `git pull origin main`
3. Make your changes and test
4. Commit regularly: `git add .` → `git commit -m "type: description"` → `git push`

### Before TestFlight Builds
1. Ensure all changes are committed
2. Update version in `pubspec.yaml`
3. Commit version change
4. Tag the release
5. Build and upload

See [Commit Guidelines](COMMIT_GUIDELINES.md) for detailed instructions.

## 📂 Project Structure

```
learniq/
├── assets/              # Images, data, and animations
│   ├── data/           # JSON data files (cards.json, topics.json)
│   ├── images/         # Topic images organized by category
│   │   ├── fahrzeug/   # Vehicle vocabulary
│   │   ├── kleidung/   # Clothing vocabulary
│   │   ├── natur/      # Nature vocabulary
│   │   ├── stadt/      # City vocabulary
│   │   ├── tiere/      # Animals vocabulary
│   │   ├── korper/     # Body vocabulary
│   │   └── wohnung/    # Home vocabulary
│   └── animations/     # Lottie animations
├── docs/               # Project documentation
├── ios/                # iOS-specific code and configuration
├── lib/                # Flutter/Dart source code
│   ├── l10n/          # Localization files
│   ├── models/        # Data models
│   ├── screens/       # UI screens
│   ├── services/      # Business logic and services
│   └── widgets/       # Reusable UI components
├── patches/           # Dependency patches
├── scripts/           # Build and utility scripts
└── web/               # Web-specific assets

```

## 🔧 Useful Scripts

### Check Git Status
```bash
./scripts/check_commits.sh
```
Checks for uncommitted changes and provides helpful reminders.

### Apply Dependency Patches
```bash
./scripts/apply_patches.sh
```
Applies necessary patches to third-party dependencies (run after `flutter pub get`).

### Flutter Pub Get with Patches
```bash
./scripts/pub_get.sh
```
Runs `flutter pub get` and automatically applies patches.

## 📱 Build Information

- **Bundle ID**: `com.mykolakorzh.learniq`
- **Current Version**: Check `pubspec.yaml`
- **Platform**: iOS (primary), Web (secondary)
- **Min iOS Version**: Check `ios/Podfile`

## 🎨 Assets Management

Total assets: ~764MB
- Images: 489 files (.jpg, .png)
- Data files: cards.json, topics.json
- Animations: Lottie JSON files

### Adding New Assets
When adding new images or topics:
1. Organize by topic in `assets/images/<topic>/`
2. Include both color and grayscale versions
3. Update `assets/data/cards.json` with new vocabulary
4. Commit topic-by-topic for smaller commits

## 🌍 Localization

Supported languages:
- English (en)
- Ukrainian (uk)
- Russian (ru)

Localization files location: `lib/l10n/`

## 🔗 Links

- **GitHub Repository**: https://github.com/mykolakorzh/learniq
- **TestFlight**: (Add TestFlight link when available)

## 📝 Contributing

This is currently a solo project, but if you're collaborating:
1. Read the [Commit Guidelines](COMMIT_GUIDELINES.md)
2. Follow the established code structure
3. Test thoroughly before committing
4. Write clear commit messages
5. Push regularly to keep GitHub in sync

## ❓ Questions?

Check the documentation files in this directory, or review the code comments in the source files.

---

**Last Updated**: November 2025

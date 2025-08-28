# LearnIQ - German Language Learning App

A Flutter app for learning German articles and vocabulary with a focus on Russian and Ukrainian speakers.

## Features

- **Topic-based learning**: Organized learning by themes (animals, food, colors)
- **Progress tracking**: Visual progress indicators and accuracy tracking
- **Localization**: Support for Russian and Ukrainian languages
- **Offline storage**: Hive database for progress persistence
- **Text-to-Speech**: German pronunciation support
- **Free/Locked content**: Freemium model with locked topics

## Project Structure

```
lib/
├── app.dart                 # Main app configuration
├── main.dart               # App entry point
├── router.dart             # GoRouter configuration
├── features/
│   ├── topics/            # Topics feature
│   │   ├── data/
│   │   │   └── topics_repository.dart
│   │   ├── models/
│   │   │   ├── topic.dart
│   │   │   └── card_item.dart
│   │   ├── view/
│   │   │   ├── topics_screen.dart
│   │   │   ├── topic_card.dart
│   │   │   └── topic_detail_screen.dart
│   │   └── controller/
│   │       ├── topics_controller.dart
│   │       └── progress_controller.dart
│   ├── learn/             # Learning feature (placeholder)
│   │   └── learn_screen.dart
│   └── test/              # Testing feature (placeholder)
│       └── test_screen.dart
├── services/
│   ├── storage/
│   │   └── hive_boxes.dart
│   └── audio/
│       └── tts_service.dart
├── l10n/                  # Localization files
│   ├── ru.arb
│   └── uk.arb
└── theme/
    └── theme.dart
```

## Setup Instructions

### Prerequisites

1. **Install Flutter**: Follow the official Flutter installation guide
   ```bash
   # Check if Flutter is installed
   flutter --version
   
   # If not installed, download from https://flutter.dev/docs/get-started/install
   ```

2. **Install dependencies**:
   ```bash
   cd learniq
   flutter pub get
   ```

3. **Add placeholder images** (optional):
   The app references image assets that don't exist yet. You can either:
   - Add actual PNG images to `assets/images/` directory
   - The app will work with placeholder icons

### Running the App

#### iOS
```bash
# Open iOS Simulator
open -a Simulator

# Run the app
flutter run
```

#### Android
```bash
# Start Android emulator or connect device
flutter run
```

### Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## Data Structure

### Topics
Each topic contains:
- `id`: Unique identifier
- `title_ru`/`title_uk`: Localized titles
- `is_free`: Whether the topic is free or locked
- `card_count`: Number of cards in the topic
- `icon_asset`: Path to topic icon
- `order`: Display order

### Cards
Each card contains:
- `id`: Unique identifier
- `topic_id`: Reference to parent topic
- `noun_de`: German noun
- `article`: German article (der/die/das)
- `phonetic`: IPA pronunciation
- `translation_ru`/`translation_uk`: Localized translations
- `image_asset`: Path to card image

### Progress
Progress is stored per topic:
- `attempts_total`: Total attempts
- `correct_total`: Correct answers
- `last_accuracy`: Last session accuracy (0.0-1.0)
- `last_attempted_at`: Timestamp of last attempt
- `mistakes_pool_ids`: List of card IDs with mistakes

## Localization

The app supports Russian and Ukrainian languages. Localization files are in `lib/l10n/`:
- `ru.arb`: Russian translations
- `uk.arb`: Ukrainian translations

## Theme

The app uses a light theme with:
- Primary color: Blue
- Article colors: der=blue, die=red, das=green
- Material 3 design system

## Dependencies

- **go_router**: Navigation
- **flutter_localizations**: Flutter localization
- **easy_localization**: Easy localization management
- **flutter_riverpod**: State management
- **hive**: Local database
- **flutter_tts**: Text-to-speech
- **lottie**: Animations
- **intl**: Internationalization

## Future Features

- [ ] Learning mode implementation
- [ ] Testing mode implementation
- [ ] Paywall integration
- [ ] Audio pronunciation
- [ ] Progress analytics
- [ ] Offline mode
- [ ] Social features

## Troubleshooting

### Common Issues

1. **Flutter not found**: Install Flutter and add to PATH
2. **Dependencies not found**: Run `flutter pub get`
3. **Asset loading errors**: Ensure assets are properly declared in pubspec.yaml
4. **Hive initialization errors**: Check if Hive is properly initialized in main.dart

### Debug Mode

```bash
# Run in debug mode with verbose logging
flutter run --debug --verbose
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License. 
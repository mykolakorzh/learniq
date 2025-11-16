# RevenueCat API Key Setup

## Option 1: Environment Variable (Recommended for CI/CD)

Build the app with the API key as an environment variable:

```bash
flutter build ios --release --dart-define=REVENUECAT_API_KEY_IOS=appl_your_key_here
```

## Option 2: Direct Configuration

Edit `lib/core/config/app_config.dart` and replace the default value:

```dart
static const String revenueCatApiKeyIOS = 'appl_your_actual_key_here';
```

**⚠️ IMPORTANT**: Never commit the actual API key to git. Use environment variables or ensure `app_config.dart` is in `.gitignore`.

## Option 3: Secure Storage (Future Enhancement)

For production apps, consider using:
- Flutter Secure Storage
- Platform-specific keychain/keystore
- Remote config service

## Getting Your API Key

1. Go to https://app.revenuecat.com
2. Navigate to Settings → API Keys
3. Copy your iOS API key (starts with `appl_`)
4. Use one of the methods above to configure it


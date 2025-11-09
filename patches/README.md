# Dependency Patches

This directory contains patches for third-party dependencies that need fixes for compatibility or bug issues.

## Why Patches?

Sometimes pub packages have bugs or compatibility issues that need to be fixed before an official update is released. Rather than forking the entire package, we use patch files to make minimal changes to the installed packages.

## Current Patches

### flutter_tts (v4.2.3)

**Issue**: Missing import for `VoidCallback` type in Flutter SDK 3.9+

**Fix**: Changed import from:
```dart
import 'package:flutter/foundation.dart' show kIsWeb;
```

to:
```dart
import 'package:flutter/foundation.dart';
```

**Status**: This is a known issue in flutter_tts 4.2.3. Future versions may fix this automatically.

## How to Apply Patches

### Automatic (Recommended)

Use the convenience script that runs `flutter pub get` and automatically applies patches:

```bash
./scripts/pub_get.sh
```

### Manual

If you run `flutter pub get` or `flutter clean` directly, you need to manually apply patches:

```bash
./scripts/apply_patches.sh
```

## When to Apply Patches

Patches need to be reapplied after:
- Running `flutter pub get`
- Running `flutter clean`
- Deleting the `.pub-cache` directory
- Updating dependencies

## Adding New Patches

1. Make your changes to the package in `~/.pub-cache/hosted/pub.dev/<package-name>-<version>/`
2. Create a patch file:
   ```bash
   cd ~/.pub-cache/hosted/pub.dev/<package-name>-<version>/
   git diff --no-index /dev/null lib/your_file.dart > ~/path/to/project/patches/<package-name>.patch
   ```
3. Update `scripts/apply_patches.sh` to include the new patch
4. Document the patch in this README

## CI/CD Integration

For continuous integration, add the patch application to your CI workflow:

```yaml
# Example for GitHub Actions
- name: Install dependencies with patches
  run: ./scripts/pub_get.sh
```

## Alternative Solutions

If patches become too cumbersome, consider these alternatives:

1. **Fork the repository**: Create a fork with fixes and use it as a git dependency in `pubspec.yaml`
2. **Wait for updates**: Check if a newer version of the package fixes the issue
3. **Use dependency_overrides**: Override with a fixed version if available

## Troubleshooting

**Patch fails to apply**: The package may have been updated or the patch is already applied. Check the actual file in `.pub-cache` to verify.

**Build still fails**: Make sure to run `flutter clean` and then `./scripts/pub_get.sh` to ensure patches are applied correctly.

**Xcode build fails**: After applying patches, you may need to clean Xcode's build folder (Product → Clean Build Folder in Xcode).

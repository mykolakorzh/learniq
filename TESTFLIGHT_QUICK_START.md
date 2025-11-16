# 🚀 Quick TestFlight Release Guide

## Fastest Way to Release

### 1. Run the Release Script

```bash
cd /Users/mykolakorzh/Documents/GitHub/learniq
./scripts/release_testflight.sh
```

This will:
- ✅ Check git status
- ✅ Clean previous builds
- ✅ Get dependencies
- ✅ Apply patches
- ✅ Build iOS release

### 2. Open in Xcode

```bash
open ios/Runner.xcworkspace
```

**Important**: Open `.xcworkspace`, NOT `.xcodeproj`

### 3. Create Archive

1. In Xcode top toolbar, select **"Any iOS Device"** (not a simulator)
2. Menu: **Product → Archive**
3. Wait 5-10 minutes for build to complete

### 4. Upload to TestFlight

1. When Organizer opens, click **"Distribute App"**
2. Select **"TestFlight & App Store"**
3. Click **"Next"** → **"Upload"** → **"Next"** → **"Upload"**
4. Wait 5-15 minutes for upload

### 5. Process in App Store Connect

1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. **My Apps → Learniq → TestFlight**
3. Wait 10-30 minutes for processing
4. When status shows **"Ready to Test"**, add testers

### 6. Add Testers

**Internal Testing** (instant):
- Go to **Internal Testing**
- Create group → Add emails → Select build → Start Testing

**External Testing** (requires review):
- Go to **External Testing**  
- Create group → Add emails → Submit for review

---

## Current Version

**Version**: 1.0.0+19

To update version:
```bash
# Edit pubspec.yaml: version: 1.0.0+20
git add pubspec.yaml
git commit -m "chore: Bump version to 1.0.0+20"
git tag v1.0.0+20
git push origin main --tags
```

---

## Troubleshooting

**Build fails?**
```bash
flutter clean
cd ios && pod deintegrate && pod install && cd ..
flutter build ios --release
```

**Signing errors?**
- Xcode → Preferences → Accounts → Download Manual Profiles
- Runner target → Signing & Capabilities → Check "Automatically manage signing"

**Upload fails?**
- Check version number matches App Store Connect
- Verify bundle ID: `com.mykolakorzh.learniq`
- Ensure all required metadata is complete

---

## Full Documentation

See `docs/TESTFLIGHT_RELEASE_GUIDE.md` for detailed instructions.


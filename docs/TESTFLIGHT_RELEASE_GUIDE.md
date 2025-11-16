# TestFlight Release Guide for Learniq

## Prerequisites

- ✅ Xcode installed (latest version recommended)
- ✅ Apple Developer account with active membership
- ✅ App registered in App Store Connect
- ✅ All code committed to git
- ✅ Version number updated in `pubspec.yaml` (currently: 1.0.0+19)

## Step-by-Step Instructions

### Step 1: Prepare Your Code

```bash
cd /Users/mykolakorzh/Documents/GitHub/learniq

# Ensure all changes are committed
git status

# If there are uncommitted changes, commit them:
git add .
git commit -m "chore: Prepare for TestFlight release v1.0.0+19"

# Tag the release (optional but recommended)
git tag v1.0.0+19
git push origin main --tags
```

### Step 2: Clean and Build

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Apply patches (if needed)
./scripts/apply_patches.sh

# Build iOS release
flutter build ios --release
```

### Step 3: Open in Xcode

```bash
# Open the workspace (NOT the .xcodeproj file!)
open ios/Runner.xcworkspace
```

**Important**: Always open `.xcworkspace`, not `.xcodeproj` when using CocoaPods.

### Step 4: Configure Signing & Capabilities

1. In Xcode, select the **Runner** project in the left sidebar
2. Select the **Runner** target
3. Go to **Signing & Capabilities** tab
4. Ensure:
   - ✅ **Automatically manage signing** is checked
   - ✅ **Team** is set to your Apple Developer team
   - ✅ **Bundle Identifier** matches App Store Connect (`com.mykolakorzh.learniq`)
   - ✅ **Provisioning Profile** is valid

### Step 5: Select Build Target

1. In the top toolbar, click the device selector
2. Select **"Any iOS Device"** (not a simulator)
   - This is required for creating an archive

### Step 6: Create Archive

1. In Xcode menu: **Product → Archive**
2. Wait for the build to complete (this may take 5-10 minutes)
3. The **Organizer** window will open automatically when done

### Step 7: Upload to TestFlight

#### Option A: Using Xcode Organizer (Recommended)

1. In the Organizer window, you'll see your new archive
2. Click **"Distribute App"**
3. Select **"TestFlight & App Store"**
4. Click **"Next"**
5. Select **"Upload"** (not "Export")
6. Click **"Next"**
7. Review the app information
8. Click **"Upload"**
9. Wait for upload to complete (5-15 minutes depending on size)

#### Option B: Using Command Line (Advanced)

```bash
# If you have ExportOptions.plist configured
xcodebuild -exportArchive \
  -archivePath ~/Library/Developer/Xcode/Archives/$(date +%Y-%m-%d)/Runner\ $(date +%Y-%m-%d\ %H.%M.%S).xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath ./build/ios/ipa
```

### Step 8: Process in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to **My Apps → Learniq**
3. Go to **TestFlight** tab
4. Wait for processing (usually 10-30 minutes)
   - You'll see "Processing" status initially
   - Status will change to "Ready to Test" when complete

### Step 9: Add Test Information (First Time Only)

1. In TestFlight, click **"Test Information"**
2. Fill in:
   - **What to Test**: Brief description of what testers should focus on
   - **Feedback Email**: Your email for receiving feedback
   - **Marketing URL** (optional): Your website
   - **Privacy Policy URL**: `https://mykolakorzh.github.io/learniq/privacy-policy`

### Step 10: Add Testers

#### Internal Testing (Up to 100 testers, instant access)

1. Go to **Internal Testing** section
2. Click **"+"** to create a new group (e.g., "Team")
3. Add testers by email (must be added to your App Store Connect team first)
4. Select your build
5. Click **"Start Testing"**

#### External Testing (Up to 10,000 testers, requires review)

1. Go to **External Testing** section
2. Click **"+"** to create a new group
3. Add testers by email or create a public link
4. Select your build
5. Submit for Beta App Review (first time only)
   - Review usually takes 24-48 hours
   - After approval, testers can access immediately

### Step 11: Notify Testers

Testers will receive an email invitation. They can also:
- Install TestFlight app from App Store
- Accept the invitation
- Install your app

## Troubleshooting

### Build Errors

**Error: "No signing certificate found"**
- Solution: Go to Xcode → Preferences → Accounts → Download Manual Profiles

**Error: "Provisioning profile doesn't match"**
- Solution: In Xcode, go to Signing & Capabilities → Click "Download Profile"

**Error: "Archive failed"**
- Solution: 
  ```bash
  flutter clean
  cd ios
  pod deintegrate
  pod install
  cd ..
  flutter build ios --release
  ```

### Upload Errors

**Error: "Invalid Bundle"**
- Check that version number in `pubspec.yaml` matches App Store Connect
- Ensure bundle identifier is correct

**Error: "Missing Compliance"**
- Go to App Store Connect → App Privacy
- Complete the privacy questionnaire

### TestFlight Issues

**Build stuck in "Processing"**
- Usually resolves within 30 minutes
- If stuck > 2 hours, contact Apple Support

**Testers can't install**
- Check that build status is "Ready to Test"
- Ensure testers accepted the invitation
- Verify iOS version compatibility

## Quick Reference Commands

```bash
# Full release workflow
cd /Users/mykolakorzh/Documents/GitHub/learniq
flutter clean
flutter pub get
./scripts/apply_patches.sh
flutter build ios --release
open ios/Runner.xcworkspace
# Then use Xcode to Archive and Upload
```

## Version Management

Current version: **1.0.0+19**

To update for next release:
1. Edit `pubspec.yaml`: `version: 1.0.0+20` (or `1.0.1+1` for minor update)
2. Commit: `git commit -m "chore: Bump version to 1.0.0+20"`
3. Tag: `git tag v1.0.0+20 && git push origin main --tags`

## Checklist Before Each Release

- [ ] All code committed and pushed
- [ ] Version number updated in `pubspec.yaml`
- [ ] Version tagged in git
- [ ] Flutter clean and build successful
- [ ] Xcode signing configured correctly
- [ ] Archive created successfully
- [ ] Upload completed without errors
- [ ] Build processed in App Store Connect
- [ ] Test information updated (if needed)
- [ ] Testers notified

## Next Steps After Upload

1. **Monitor Build Processing**: Check App Store Connect regularly
2. **Test Yourself**: Install from TestFlight and verify key features
3. **Gather Feedback**: Set up feedback channels for testers
4. **Fix Issues**: Address critical bugs before next release
5. **Iterate**: Release new builds as needed

---

**Need Help?**
- [Apple TestFlight Documentation](https://developer.apple.com/testflight/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- Check `docs/COMMIT_GUIDELINES.md` for version management


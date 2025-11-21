# Quick Setup Guide - Firebase & RevenueCat

## 🚀 Quick Start

### 1. Check Current Status

```bash
./scripts/check_setup.sh
```

This will tell you what's missing.

---

## 📱 Firebase Setup (5 minutes)

### Step 1: Get GoogleService-Info.plist

1. Go to https://console.firebase.google.com
2. Create/select project → Add iOS app
3. Bundle ID: `com.mykolakorzh.learniq`
4. Download `GoogleService-Info.plist`

### Step 2: Add to Project

```bash
# Place the file here:
cp ~/Downloads/GoogleService-Info.plist ios/Runner/
```

### Step 3: Add to Xcode

```bash
open ios/Runner.xcworkspace
```

Then in Xcode:
- Right-click `Runner` folder
- "Add Files to Runner..."
- Select `GoogleService-Info.plist`
- ✅ Check "Copy items if needed"
- ✅ Check "Add to targets: Runner"
- Click "Add"

### Step 4: Enable Services

In Firebase Console:
- Enable **Crashlytics** (Project Settings → Your app → Crashlytics)
- **Analytics** is auto-enabled

✅ Done! Firebase is ready.

---

## 💰 RevenueCat Setup (10 minutes)

### Step 1: Create Subscription in App Store Connect

1. Go to https://appstoreconnect.apple.com
2. Your app → Features → In-App Purchases
3. Create Subscription:
   - Product ID: `learniq_premium_monthly`
   - Duration: 1 Month
   - Price: Your choice (e.g., $4.99)

### Step 2: Configure RevenueCat

1. Go to https://app.revenuecat.com
2. Add iOS app (bundle ID: `com.mykolakorzh.learniq`)
3. Link your subscription product
4. Create entitlement: `premium`
5. Create offering: `default` with package `monthly`
6. Copy your **iOS API Key** (starts with `appl_`)

### Step 3: Add API Key

**Option A: Build with key (Recommended)**
```bash
flutter build ios --release \
  --dart-define=REVENUECAT_API_KEY_IOS=appl_your_key_here
```

**Option B: Temporary (for testing)**
Edit `lib/core/config/app_config.dart`:
```dart
static const String revenueCatApiKeyIOS = 'appl_your_key_here';
```

⚠️ **Don't commit the key to git!**

✅ Done! RevenueCat is ready.

---

## ✅ Verify Setup

```bash
./scripts/check_setup.sh
```

Should show:
- ✅ GoogleService-Info.plist found
- ✅ RevenueCat API key configured

---

## 📚 Full Documentation

For detailed instructions, see:
- `docs/FIREBASE_REVENUECAT_SETUP.md` - Complete setup guide
- `docs/REVENUECAT_API_KEY_SETUP.md` - API key configuration

---

## 🧪 Test

1. Run the app:
   ```bash
   flutter run
   ```

2. Check console for:
   - ✅ "Firebase Analytics initialized."
   - ✅ No Firebase/RevenueCat errors

3. Test subscription:
   - Navigate to paywall
   - Use sandbox tester account
   - Complete test purchase

---

## 🆘 Troubleshooting

**Firebase not working?**
- Check `GoogleService-Info.plist` is in `ios/Runner/`
- Verify it's added to Xcode target
- Check bundle ID matches

**RevenueCat not working?**
- Verify API key starts with `appl_`
- Check offering is set as "Default"
- Ensure product is linked

**Need help?**
- See `docs/FIREBASE_REVENUECAT_SETUP.md` for detailed troubleshooting


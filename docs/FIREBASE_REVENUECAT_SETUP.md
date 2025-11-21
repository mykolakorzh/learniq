# Firebase & RevenueCat Setup Guide

This guide will help you set up Firebase and RevenueCat for the Learniq app.

## Prerequisites

- Firebase account: https://console.firebase.google.com
- RevenueCat account: https://app.revenuecat.com
- App Store Connect account (for subscriptions)
- Xcode installed

---

## Part 1: Firebase Setup

### Step 1: Create Firebase Project

1. Go to https://console.firebase.google.com
2. Click "Add project" or select existing project
3. Enter project name: **Learniq**
4. Enable Google Analytics (recommended)
5. Click "Create project"

### Step 2: Add iOS App to Firebase

1. In Firebase Console, click "Add app" → iOS
2. Enter iOS bundle ID: `com.mykolakorzh.learniq`
   - Find this in Xcode: Runner target → General → Bundle Identifier
3. Enter App nickname: **Learniq iOS**
4. Enter App Store ID (optional, can add later)
5. Click "Register app"

### Step 3: Download GoogleService-Info.plist

1. Download the `GoogleService-Info.plist` file
2. **IMPORTANT**: Do NOT commit this file to git (it contains sensitive keys)
3. Place it in: `ios/Runner/GoogleService-Info.plist`

### Step 4: Add to Xcode Project

1. Open Xcode: `open ios/Runner.xcworkspace`
2. Right-click on `Runner` folder in Project Navigator
3. Select "Add Files to Runner..."
4. Select `GoogleService-Info.plist`
5. ✅ Check "Copy items if needed"
6. ✅ Check "Add to targets: Runner"
7. Click "Add"

### Step 5: Enable Firebase Services

#### Enable Crashlytics

1. In Firebase Console → Project Settings → Your apps
2. Click on your iOS app
3. Go to "Crashlytics" tab
4. Click "Enable Crashlytics"
5. Follow the setup instructions (usually just clicking "Next")

#### Enable Analytics

1. Analytics is automatically enabled when you create a project with Analytics
2. Verify in Firebase Console → Analytics → Dashboard

#### (Optional) Enable Firestore

1. Go to Firebase Console → Firestore Database
2. Click "Create database"
3. Start in **test mode** (for now)
4. Choose a location (closest to your users)
5. Click "Enable"

### Step 6: Verify Setup

Run the app and check:

```bash
flutter run
```

Check console for:
- ✅ "Firebase Analytics initialized."
- ✅ No Firebase initialization errors

---

## Part 2: RevenueCat Setup

### Step 1: Create RevenueCat Account

1. Go to https://app.revenuecat.com
2. Sign up or log in
3. Create a new project: **Learniq**

### Step 2: Add iOS App to RevenueCat

1. In RevenueCat dashboard, click "Add app"
2. Select platform: **iOS**
3. Enter bundle ID: `com.mykolakorzh.learniq`
4. Enter app name: **Learniq**
5. Click "Add"

### Step 3: Create Subscription Products in App Store Connect

1. Go to https://appstoreconnect.apple.com
2. Select your app → Features → In-App Purchases
3. Click "+" to create new subscription
4. Create **Subscription Group** (if first time):
   - Name: "Learniq Premium"
   - Click "Create"
5. Create **Subscription**:
   - Product ID: `learniq_premium_monthly`
   - Reference Name: "Learniq Premium Monthly"
   - Subscription Duration: 1 Month
   - Price: Set your price (e.g., $4.99/month)
   - Click "Create"
6. Fill in subscription details:
   - Subscription Display Name: "Premium Monthly"
   - Description: "Unlock all topics and features"
   - Review Information (required for App Review)
7. Click "Save"

### Step 4: Link Products in RevenueCat

1. In RevenueCat dashboard → Your app → Products
2. Click "Add Product"
3. Select "App Store Connect"
4. Choose your subscription: `learniq_premium_monthly`
5. Click "Add"

### Step 5: Create Entitlement

1. In RevenueCat → Entitlements
2. Click "Add Entitlement"
3. Identifier: `premium`
4. Display Name: "Premium Access"
5. Click "Save"

### Step 6: Create Offering

1. In RevenueCat → Offerings
2. Click "Add Offering"
3. Identifier: `default`
4. Display Name: "Default Offering"
5. Add Package:
   - Identifier: `monthly`
   - Display Name: "Monthly"
   - Select your product: `learniq_premium_monthly`
   - Attach entitlement: `premium`
6. Click "Save"
7. Set as **Default Offering** (toggle switch)

### Step 7: Get API Key

1. In RevenueCat → Settings → API Keys
2. Copy your **iOS API Key** (starts with `appl_`)
3. Keep this secure - don't commit to git!

### Step 8: Configure API Key in App

**Option A: Environment Variable (Recommended)**

Build with the API key:

```bash
flutter build ios --release \
  --dart-define=REVENUECAT_API_KEY_IOS=appl_your_key_here
```

**Option B: Direct Configuration (Development Only)**

Edit `lib/core/config/app_config.dart`:

```dart
static const String revenueCatApiKeyIOS = 'appl_your_actual_key_here';
```

⚠️ **Never commit the actual key to git!**

### Step 9: Test Subscription

1. Build and run the app
2. Navigate to paywall screen
3. Use a **sandbox tester account** from App Store Connect
4. Test purchase flow

---

## Part 3: Verification Checklist

### Firebase ✅

- [ ] `GoogleService-Info.plist` added to `ios/Runner/`
- [ ] File added to Xcode project
- [ ] Crashlytics enabled in Firebase Console
- [ ] Analytics enabled
- [ ] App runs without Firebase errors
- [ ] Test crash reporting (optional)

### RevenueCat ✅

- [ ] RevenueCat account created
- [ ] iOS app added to RevenueCat
- [ ] Subscription product created in App Store Connect
- [ ] Product linked in RevenueCat
- [ ] Entitlement `premium` created
- [ ] Offering `default` created with package
- [ ] API key obtained
- [ ] API key configured in app
- [ ] Test purchase works with sandbox account

---

## Troubleshooting

### Firebase Issues

**Error: "Firebase initialization failed"**
- Check `GoogleService-Info.plist` is in correct location
- Verify file is added to Xcode target
- Check bundle ID matches Firebase project

**Crashlytics not working**
- Ensure Crashlytics is enabled in Firebase Console
- Check Firebase SDK version compatibility
- Verify app is built in release mode for production

### RevenueCat Issues

**Error: "RevenueCat configuration failed"**
- Verify API key is correct (starts with `appl_`)
- Check API key is set via environment variable or config
- Ensure RevenueCat app is configured correctly

**No packages available**
- Verify offering is set as "Default"
- Check package is attached to entitlement
- Ensure product is linked in RevenueCat

**Sandbox purchase not working**
- Verify sandbox tester account is created in App Store Connect
- Check subscription status in App Store Connect
- Ensure product is approved (or in "Ready to Submit" status)

---

## Security Best Practices

1. **Never commit sensitive files:**
   - `GoogleService-Info.plist` → Add to `.gitignore`
   - API keys → Use environment variables

2. **Use environment variables for production builds:**
   ```bash
   flutter build ios --release \
     --dart-define=REVENUECAT_API_KEY_IOS=appl_xxx
   ```

3. **Review Firebase security rules** (if using Firestore)

4. **Monitor API key usage** in RevenueCat dashboard

---

## Next Steps

After setup is complete:

1. Test all features:
   - Firebase Crashlytics (test crash)
   - Firebase Analytics (check events)
   - RevenueCat subscription flow

2. Update version number for release:
   ```yaml
   version: 1.0.0+20  # Increment build number
   ```

3. Build for TestFlight:
   ```bash
   flutter build ios --release
   # Then archive in Xcode
   ```

---

## Support

- Firebase Docs: https://firebase.google.com/docs
- RevenueCat Docs: https://docs.revenuecat.com
- RevenueCat Support: support@revenuecat.com


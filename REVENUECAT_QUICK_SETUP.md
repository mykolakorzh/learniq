# RevenueCat Quick Setup Guide

## Current Status: ⚠️ API Key Required

Your app is **fully integrated** with RevenueCat code. You just need to complete the RevenueCat dashboard setup and add the API key.

## Quick Steps (15-20 minutes)

### Step 1: Create RevenueCat Account
1. Go to https://app.revenuecat.com
2. Sign up or log in
3. Click "Create new project"
4. Project name: **Learniq**

### Step 2: Add iOS App
1. In RevenueCat dashboard → Click "Add app"
2. Platform: **iOS**
3. App name: **Learniq**
4. Bundle ID: `com.mykolakorzh.learniq`
5. Click "Save"

### Step 3: Create Subscription in App Store Connect
1. Go to https://appstoreconnect.apple.com
2. My Apps → Select your app (or create it first)
3. Features → In-App Purchases
4. Click "+" → Auto-Renewable Subscription
5. Create **Subscription Group** (if first time):
   - Name: "Learniq Premium"
6. Create Subscription:
   - **Product ID**: `learniq_premium_monthly`
   - **Reference Name**: "Learniq Premium Monthly"
   - **Duration**: 1 Month
   - **Price**: Choose tier (e.g., $4.99/month)
7. Fill in:
   - **Display Name**: "Premium Monthly"
   - **Description**: "Unlock all topics and features with unlimited access"
   - **Free Trial**: 7 days (optional but recommended)
8. Add localized descriptions for Russian/Ukrainian if desired
9. Click "Save"

### Step 4: Link Product in RevenueCat
1. Back to RevenueCat dashboard
2. Your app → Products tab
3. Click "New" or "+" button
4. Select "App Store" as platform
5. Enter Product ID: `learniq_premium_monthly`
6. Click "Save"

### Step 5: Create Entitlement
1. RevenueCat dashboard → Entitlements tab
2. Click "New" or "+"
3. Identifier: `premium` (must match code)
4. Display name: "Premium Access"
5. Click "Save"

### Step 6: Create Offering
1. RevenueCat dashboard → Offerings tab
2. Click "New" or "+"
3. Identifier: `default`
4. Display name: "Default Offering"
5. Add package:
   - **Package ID**: `monthly`
   - **Product**: Select `learniq_premium_monthly`
   - **Attach to entitlement**: Select `premium`
6. Click "Save"
7. Toggle "Set as default" ON

### Step 7: Get Your API Key
1. RevenueCat dashboard → Settings → API Keys
2. Find **Apple App Store** section
3. Copy the key (starts with `appl_`)
4. Keep this secure!

### Step 8: Add API Key to Your App

**Option A: For Development/Testing**

Create a file `lib/core/config/revenuecat_key.dart` (this file is git-ignored):

```dart
/// RevenueCat API Key - DO NOT COMMIT THIS FILE
const String revenueCatApiKeyIOS = 'appl_YOUR_ACTUAL_KEY_HERE';
```

Then update `lib/core/config/app_config.dart`:

```dart
import 'revenuecat_key.dart' as rc;

class AppConfig {
  static const String revenueCatApiKeyIOS = rc.revenueCatApiKeyIOS;
  // ... rest of file
}
```

**Option B: For Production Builds (Recommended)**

Build with environment variable:

```bash
flutter build ios --release \
  --dart-define=REVENUECAT_API_KEY_IOS=appl_YOUR_KEY_HERE
```

Or for running:

```bash
flutter run --dart-define=REVENUECAT_API_KEY_IOS=appl_YOUR_KEY_HERE
```

### Step 9: Test Your Setup

1. **Build and run**:
   ```bash
   flutter run --dart-define=REVENUECAT_API_KEY_IOS=appl_YOUR_KEY_HERE
   ```

2. **Navigate to Account screen** in the app

3. **Check for errors** in console - should see:
   - No "RevenueCat configuration failed" messages
   - Subscription service initialized

4. **Create Sandbox Tester** in App Store Connect:
   - Users and Access → Sandbox → Testers
   - Add a new tester (use a different Apple ID)

5. **Test purchase flow**:
   - Sign out of your real Apple ID on device
   - Navigate to paywall in app
   - Try to purchase subscription
   - Use sandbox tester credentials when prompted

## Verification Checklist

- [ ] RevenueCat account created
- [ ] iOS app added to RevenueCat
- [ ] Subscription created in App Store Connect (`learniq_premium_monthly`)
- [ ] Product linked in RevenueCat
- [ ] Entitlement `premium` created
- [ ] Offering `default` created with package
- [ ] API key obtained from RevenueCat
- [ ] API key added to app (via env var or config file)
- [ ] App runs without RevenueCat errors
- [ ] Sandbox tester account created
- [ ] Test purchase successful

## Troubleshooting

### "No offerings available"
- Ensure offering is set as "Default" (toggle in RevenueCat)
- Check that package is properly linked to product
- Verify product ID matches exactly

### "Invalid API key"
- Double-check you copied the full key (starts with `appl_`)
- Ensure no extra spaces or quotes
- Verify you're using the iOS key, not Android

### "Unable to purchase"
- Make sure you're using a sandbox tester account
- Verify subscription is "Ready to Submit" in App Store Connect
- Check product is approved (or at least created)
- Ensure app Bundle ID matches everywhere

### "Package not found"
- Check offering has package with entitlement attached
- Verify product ID is correct
- Make sure offering is published

## Next Steps After Setup

1. **Test thoroughly** with sandbox account
2. **Submit app for review** to App Store
3. **Monitor** RevenueCat dashboard for subscription metrics
4. **Set up webhooks** (optional) for backend integration

## Support Resources

- RevenueCat Docs: https://docs.revenuecat.com/docs/ios
- RevenueCat Support: support@revenuecat.com (usually responds in < 24 hours)
- Community: RevenueCat Community Forums

## Important Notes

- **Never commit** your API key to git
- **Use sandbox testers** for testing (don't use real purchases)
- **7-day trial**: Configure in App Store Connect subscription settings
- **Cross-platform**: If you add Android later, repeat similar steps for Google Play

---

**Estimated Setup Time**: 15-20 minutes (if you already have App Store Connect app created)

**Current Code Status**: ✅ Ready - just needs API key to activate


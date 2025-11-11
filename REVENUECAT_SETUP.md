# RevenueCat Setup Guide for LearnIQ

This guide walks you through setting up RevenueCat for production in-app subscriptions.

## Current Status
- ✅ RevenueCat SDK integrated (purchases_flutter ^8.2.2)
- ✅ SubscriptionService implemented
- ✅ Demo mode active (works without API key)
- ⏳ Production API key needed

## Prerequisites
- Apple Developer Account ($99/year)
- App Store Connect access
- Bundle ID: `com.mykolakorzh.learniq`

---

## Step 1: Create RevenueCat Account

1. Go to https://app.revenuecat.com
2. Sign up with your email (free tier is fine to start)
3. Confirm your email

---

## Step 2: Add Your App in RevenueCat

1. In RevenueCat dashboard, click **"+ New App"**
2. Enter app details:
   - **App Name:** LearnIQ
   - **Bundle ID:** `com.mykolakorzh.learniq`
   - **Platform:** iOS
3. Click **"Add app"**

---

## Step 3: Get Your API Keys

1. Go to **Settings** → **API Keys**
2. Copy the **iOS API key** (starts with `appl_`)
3. Keep this safe - you'll need it in Step 6

---

## Step 4: Create Subscription Products in App Store Connect

1. Go to https://appstoreconnect.apple.com
2. Select **LearnIQ** app
3. Go to **Features** → **In-App Purchases**
4. Click **"+"** to create new subscription

### Create Monthly Subscription:

- **Reference Name:** LearnIQ Premium Monthly
- **Product ID:** `learniq_premium_monthly`
- **Subscription Group:** Create new "Premium Access"
- **Subscription Duration:** 1 Month
- **Price:** $4.99 (or your chosen price)
- **Introductory Offer:**
  - Type: Free Trial
  - Duration: 7 days
  - One time offer
- **Localization:**
  - Display Name: Premium Access
  - Description: Unlock all topics and premium features

5. Click **"Create"**
6. Wait for Apple to approve (usually instant for first submission)

### Optional: Add Annual Subscription

Repeat above with:
- **Product ID:** `learniq_premium_annual`
- **Duration:** 1 Year
- **Price:** $39.99 (save 33%)

---

## Step 5: Link Products in RevenueCat

1. In RevenueCat dashboard, go to your app
2. Click **"Products"** in left sidebar
3. Click **"+ New Product"**
4. Enter:
   - **Product ID:** `learniq_premium_monthly` (must match App Store)
   - **Type:** Subscription
5. Click **"Add"**
6. Repeat for annual if created

---

## Step 6: Configure Entitlements in RevenueCat

1. Go to **"Entitlements"** in left sidebar
2. You should see **"premium"** entitlement (our code uses this)
3. If not, create it:
   - Click **"+ New Entitlement"**
   - **Identifier:** `premium`
   - **Display Name:** Premium Access
4. Click on **"premium"** entitlement
5. Click **"Attach"** and select your products:
   - ✓ learniq_premium_monthly
   - ✓ learniq_premium_annual (if created)
6. Save

---

## Step 7: Create Offering (Package)

1. Go to **"Offerings"** in left sidebar
2. Click **"+ New Offering"**
3. Enter:
   - **Identifier:** `default` (our code looks for this)
   - **Description:** Default premium offering
4. Add packages:
   - **Monthly Package:**
     - Identifier: `monthly`
     - Product: learniq_premium_monthly
   - **Annual Package (optional):**
     - Identifier: `annual`
     - Product: learniq_premium_annual
5. Set as **"Current Offering"**
6. Save

---

## Step 8: Update Your App Code

1. Open `lib/services/subscription_service.dart`
2. Find line 23:
   ```dart
   static const String _apiKeyIOS = 'YOUR_REVENUECAT_API_KEY_HERE';
   ```
3. Replace with your actual API key:
   ```dart
   static const String _apiKeyIOS = 'appl_xxxxxxxxxxx';
   ```
4. Save the file

**⚠️ IMPORTANT:** Add this to `.gitignore` or use environment variables in production:
```bash
# Option 1: Use environment config file (recommended)
echo "REVENUECAT_API_KEY=appl_xxxx" > .env
git add .env.example  # Example without real key
echo ".env" >> .gitignore

# Option 2: Store in iOS project
# Add to ios/Flutter/Release.xcconfig
```

---

## Step 9: Test with Sandbox Account

1. Create sandbox tester in App Store Connect:
   - Go to **Users and Access** → **Sandbox Testers**
   - Click **"+"** to add tester
   - Use format: `test1@yourdomain.com` (doesn't need to be real)

2. Build and run app on simulator/device:
   ```bash
   flutter run
   ```

3. Test subscription flow:
   - Tap a locked topic
   - Paywall should appear
   - Tap "Start Free Trial"
   - Sign in with sandbox account when prompted
   - Complete purchase (you won't be charged)

4. Verify in RevenueCat dashboard:
   - Go to **"Customers"**
   - Your sandbox user should appear
   - Check if entitlement is active

---

## Step 10: Build for TestFlight

Once testing works in sandbox:

```bash
# Build release version
flutter build ios --release

# Open Xcode to upload
open ios/Runner.xcworkspace
```

In Xcode:
1. Select **"Any iOS Device"** as target
2. Go to **Product** → **Archive**
3. Click **"Distribute App"** → **"TestFlight"**
4. Upload to App Store Connect

---

## Verification Checklist

- [ ] RevenueCat account created
- [ ] App added in RevenueCat
- [ ] API key obtained and added to code
- [ ] Subscription products created in App Store Connect
- [ ] Products linked in RevenueCat
- [ ] "premium" entitlement configured
- [ ] "default" offering created with packages
- [ ] Sandbox testing successful
- [ ] Real device testing completed
- [ ] TestFlight build uploaded

---

## Troubleshooting

### "No offerings found"
- Check that offering is set as "Current"
- Verify products are properly linked
- Wait 5-10 minutes for RevenueCat to sync

### "Unable to purchase"
- Ensure you're signed out of real Apple ID
- Sign in with sandbox tester account
- Check product IDs match exactly

### "This product is currently unavailable"
- Product not approved in App Store Connect
- Check product status is "Ready to Submit" or "Approved"

### "Invalid API key"
- Verify you copied the iOS key (not Android or public key)
- Check for extra spaces when pasting
- Regenerate key if needed

---

## Demo Mode Testing (No RevenueCat Needed)

For quick testing without RevenueCat setup:

1. Tap a locked topic
2. Paywall appears
3. Tap "Start Free Trial"
4. Dialog appears explaining demo mode
5. Tap "Activate Demo Trial"
6. Access granted for testing!

Demo mode uses local storage only - perfect for development.

---

## Support

- RevenueCat Docs: https://docs.revenuecat.com
- RevenueCat Support: support@revenuecat.com
- LearnIQ Issues: https://github.com/mykolakorzh/learniq/issues

---

## Next Steps After Setup

1. **Analytics:** RevenueCat provides revenue analytics automatically
2. **Webhooks:** Set up webhooks for backend integration
3. **Customer Support:** Use RevenueCat dashboard to check user subscriptions
4. **Pricing Experiments:** Use RevenueCat to test different price points

Good luck with your subscription launch! 🚀

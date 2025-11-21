# Testing Checklist Before Launch

**Target Launch**: Week of November 25, 2025
**Current Status**: Configuration Complete ✅

---

## 🧪 Pre-Launch Testing (Do This Week!)

### 1. Create Sandbox Tester Account

**In App Store Connect**:
1. Go to https://appstoreconnect.apple.com
2. **Users and Access** → **Sandbox** → **Testers**
3. Click **"+"** to add new tester
4. Use a **different email** than your main Apple ID
   - Example: `test.learniq@gmail.com` or `youremail+sandbox@gmail.com`
5. Save the credentials (email + password)

---

### 2. Test on Real Device

#### Prepare Device
1. **Sign out** of your real Apple ID:
   - Settings → App Store → Sign Out
2. Keep device signed out during testing

#### Run App
```bash
cd /Users/mykolakorzh/Documents/GitHub/learniq
flutter run --release
```

Or build and install via Xcode for TestFlight testing.

---

### 3. Test Subscription Flow

#### Test Steps:
1. ✅ **Launch app** - verify it starts without errors
2. ✅ **Check Firebase** - look for "Firebase Analytics initialized" in console
3. ✅ **Navigate to free topic** - ensure it works
4. ✅ **Try to access premium topic** - should show paywall
5. ✅ **Tap "Subscribe" or "Premium"** - paywall should appear
6. ✅ **Verify offerings load** - should show "Premium Monthly" option
7. ✅ **Tap purchase button** - iOS payment sheet should appear
8. ✅ **Sign in with sandbox account** when prompted
9. ✅ **Complete purchase** - should succeed (sandbox = free)
10. ✅ **Verify premium unlocked** - can now access premium topics
11. ✅ **Restart app** - premium should still be active
12. ✅ **Test "Restore Purchases"** - should restore subscription

---

### 4. Test Edge Cases

#### Network Issues
- [ ] Turn on Airplane Mode
- [ ] Launch app - should work offline (cached content)
- [ ] Turn off Airplane Mode
- [ ] Verify sync resumes

#### Subscription Edge Cases
- [ ] Test "Cancel" during purchase flow
- [ ] Test "Restore Purchases" with no purchases (should show message)
- [ ] Test accessing premium content without subscription (should block)
- [ ] Test multiple purchase attempts (should handle gracefully)

#### UI/UX Testing
- [ ] Test all navigation flows
- [ ] Test language switching (Russian/Ukrainian)
- [ ] Test dark mode (if implemented)
- [ ] Test on different screen sizes
- [ ] Test rotation (portrait/landscape)

---

### 5. Monitor During Testing

#### Check Firebase Console
1. Go to https://console.firebase.google.com
2. Select project "lerneq"
3. Check **Analytics** → Events (should see app events)
4. Check **Crashlytics** (should see no crashes)

#### Check RevenueCat Dashboard
1. Go to https://app.revenuecat.com
2. Select "Learniq" app
3. Go to **Overview** → **Charts**
4. After test purchase, verify it appears in dashboard
5. Check subscriber count increases

---

### 6. Console Logs to Watch For

#### Good Signs ✅
```
Firebase Analytics initialized.
RevenueCat configured successfully
Offerings loaded: 1 offering(s)
Customer info retrieved
```

#### Bad Signs ❌ (Fix These!)
```
Firebase initialization failed
RevenueCat configuration failed
No offerings available
Purchase failed
```

---

## 📱 TestFlight Testing

Your app is already on TestFlight. Before public release:

### Internal Testing
1. ✅ Install from TestFlight
2. ✅ Test all features listed above
3. ✅ Verify subscription works
4. ✅ Test for at least 2-3 days

### External Testing (Optional)
1. Add external testers in App Store Connect
2. Send TestFlight link to beta testers
3. Collect feedback
4. Fix any reported issues

---

## 🐛 Common Issues & Solutions

### "No offerings available"
- **Check**: RevenueCat offering is set as "Current"
- **Check**: Product ID matches App Store Connect
- **Check**: API key is correct (starts with `appl_`)

### "Purchase failed"
- **Check**: Using sandbox tester account
- **Check**: Signed out of real Apple ID
- **Check**: Subscription is "Ready to Submit" in App Store Connect
- **Check**: Bundle ID matches everywhere

### "Firebase not working"
- **Check**: `GoogleService-Info.plist` in correct location
- **Check**: File is added to Xcode target
- **Check**: Bundle ID matches Firebase project

### "Subscription not restoring"
- **Check**: Using same sandbox account
- **Check**: `restorePurchases()` is called correctly
- **Check**: RevenueCat customer ID is consistent

---

## ✅ Ready for Launch Checklist

Before submitting to App Review:

### Technical
- [ ] All subscription flows work in sandbox
- [ ] Firebase Analytics tracking correctly
- [ ] No crashes during testing
- [ ] App works offline (cached content)
- [ ] Restore purchases works
- [ ] All premium features unlock after purchase

### Content
- [ ] All topics have content
- [ ] All images load correctly
- [ ] All text is translated (RU/UK)
- [ ] No placeholder text or "Lorem ipsum"

### Legal & Compliance
- [ ] Privacy Policy URL working
- [ ] Terms of Service URL working
- [ ] Subscription terms clearly displayed
- [ ] "Restore Purchases" button visible
- [ ] Subscription management link provided

### App Store Connect
- [ ] App screenshots uploaded
- [ ] App description written
- [ ] Keywords set
- [ ] Subscription reviewed and approved
- [ ] Age rating set
- [ ] Contact information updated

---

## 🚀 Launch Process

### 1. Final Build
```bash
# Ensure clean state
flutter clean
flutter pub get

# Build release
flutter build ios --release

# Open Xcode and archive
open ios/Runner.xcworkspace
```

### 2. Archive & Submit
1. In Xcode: **Product** → **Archive**
2. Wait for archive to complete
3. Click **Distribute App**
4. Choose **App Store Connect**
5. Upload to App Store Connect
6. Wait for processing (10-30 minutes)

### 3. Submit for Review
1. Go to App Store Connect
2. Select your app
3. Go to version ready for submission
4. Click **Submit for Review**
5. Answer questions about app
6. Submit!

### 4. Review Timeline
- **Typical**: 24-48 hours
- **First submission**: Can take up to 5-7 days
- **With issues**: May be rejected, fix and resubmit

---

## 📊 Post-Launch Monitoring

### First 24 Hours
- [ ] Monitor Crashlytics for crashes
- [ ] Check RevenueCat for subscriptions
- [ ] Monitor App Store reviews
- [ ] Check Firebase Analytics for usage

### First Week
- [ ] Track conversion rate (downloads → subscriptions)
- [ ] Monitor user retention
- [ ] Respond to reviews
- [ ] Fix any critical bugs quickly

---

## 📞 Support Contacts

### If Issues Arise:
- **Firebase**: Firebase Console → Support
- **RevenueCat**: support@revenuecat.com (fast response!)
- **App Store**: App Store Connect → Contact Us

### Helpful Resources:
- RevenueCat Docs: https://docs.revenuecat.com/docs/ios
- Firebase Docs: https://firebase.google.com/docs
- App Review Guidelines: https://developer.apple.com/app-store/review/guidelines/

---

**Good luck with your launch! 🚀**

**Remember**: Test thoroughly with sandbox account this week, then submit for review by Friday (Nov 22) to launch by next week!


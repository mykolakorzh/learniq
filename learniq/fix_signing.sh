#!/bin/bash

echo "🔧 Fixing iOS code signing issues..."

# Remove stale code signature files
echo "Removing stale code signature files..."
find build/ios -name "_CodeSignature" -type d -exec rm -rf {} + 2>/dev/null || true

# Clean all build artifacts
echo "Cleaning build artifacts..."
flutter clean
rm -rf ios/build/
rm -rf build/

# Reset pods
echo "Resetting CocoaPods..."
cd ios
rm -rf Pods/
rm -rf Podfile.lock
pod install
cd ..

echo "✅ Build environment cleaned!"
echo "📱 Now open Xcode:"
echo "   1. open ios/Runner.xcworkspace"
echo "   2. Select Runner target → Signing & Capabilities" 
echo "   3. Uncheck 'Automatically manage signing'"
echo "   4. Set Code Signing Identity to 'Don't Code Sign'"
echo "   5. Select iPhone 16 Pro simulator and build"
echo ""
echo "🎉 Your app should now show all 32 cards instead of 5!"
#!/bin/bash

# Script to check Firebase and RevenueCat setup status

echo "🔍 Checking Learniq Setup Status..."
echo "=================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Firebase
echo "📱 Firebase Setup:"
if [ -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo -e "${GREEN}✅ GoogleService-Info.plist found${NC}"
    
    # Check if it's a valid plist
    if plutil -lint ios/Runner/GoogleService-Info.plist > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Valid plist file${NC}"
        
        # Extract bundle ID
        BUNDLE_ID=$(plutil -extract CFBundleURLTypes.0.CFBundleURLSchemes.0 raw ios/Runner/GoogleService-Info.plist 2>/dev/null || echo "")
        if [ ! -z "$BUNDLE_ID" ]; then
            echo -e "${GREEN}✅ Bundle ID configured: $BUNDLE_ID${NC}"
        fi
    else
        echo -e "${RED}❌ Invalid plist file${NC}"
    fi
else
    echo -e "${RED}❌ GoogleService-Info.plist NOT found${NC}"
    echo -e "${YELLOW}   → Download from Firebase Console${NC}"
    echo -e "${YELLOW}   → Place in: ios/Runner/GoogleService-Info.plist${NC}"
fi

echo ""

# Check RevenueCat
echo "💰 RevenueCat Setup:"
API_KEY=$(grep -o "String.fromEnvironment('REVENUECAT_API_KEY_IOS', defaultValue: '[^']*')" lib/core/config/app_config.dart 2>/dev/null | grep -o "'[^']*'" | tr -d "'")

if [ "$API_KEY" = "YOUR_REVENUECAT_API_KEY_HERE" ] || [ -z "$API_KEY" ]; then
    echo -e "${RED}❌ RevenueCat API key not configured${NC}"
    echo -e "${YELLOW}   → Get API key from RevenueCat dashboard${NC}"
    echo -e "${YELLOW}   → Set via: --dart-define=REVENUECAT_API_KEY_IOS=appl_xxx${NC}"
else
    if [[ $API_KEY == appl_* ]]; then
        echo -e "${GREEN}✅ RevenueCat API key configured${NC}"
        echo -e "${GREEN}   Key: ${API_KEY:0:20}...${NC}"
    else
        echo -e "${YELLOW}⚠️  API key format looks incorrect (should start with 'appl_')${NC}"
    fi
fi

echo ""

# Check if files are in gitignore
echo "🔒 Security Check:"
if grep -q "GoogleService-Info.plist" .gitignore 2>/dev/null; then
    echo -e "${GREEN}✅ GoogleService-Info.plist in .gitignore${NC}"
else
    echo -e "${YELLOW}⚠️  Consider adding GoogleService-Info.plist to .gitignore${NC}"
fi

echo ""

# Summary
echo "=================================="
echo "📋 Setup Summary:"
echo ""

FIREBASE_OK=$([ -f "ios/Runner/GoogleService-Info.plist" ] && echo "yes" || echo "no")
REVENUECAT_OK=$([ "$API_KEY" != "YOUR_REVENUECAT_API_KEY_HERE" ] && [[ $API_KEY == appl_* ]] && echo "yes" || echo "no")

if [ "$FIREBASE_OK" = "yes" ] && [ "$REVENUECAT_OK" = "yes" ]; then
    echo -e "${GREEN}✅ Both Firebase and RevenueCat are configured!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Test the app: flutter run"
    echo "2. Verify Firebase Analytics in Firebase Console"
    echo "3. Test RevenueCat subscription with sandbox account"
    exit 0
else
    echo -e "${YELLOW}⚠️  Setup incomplete${NC}"
    echo ""
    if [ "$FIREBASE_OK" = "no" ]; then
        echo -e "${RED}❌ Firebase needs configuration${NC}"
    fi
    if [ "$REVENUECAT_OK" = "no" ]; then
        echo -e "${RED}❌ RevenueCat needs configuration${NC}"
    fi
    echo ""
    echo "See docs/FIREBASE_REVENUECAT_SETUP.md for detailed instructions"
    exit 1
fi


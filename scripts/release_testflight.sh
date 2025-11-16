#!/bin/bash

# TestFlight Release Script for Learniq
# This script prepares the app for TestFlight release

set -e  # Exit on error

echo "🚀 Learniq TestFlight Release Script"
echo "===================================="
echo ""

# Get current version
VERSION=$(grep "^version:" pubspec.yaml | sed 's/version: //')
echo "📱 Current version: $VERSION"
echo ""

# Check git status
echo "📋 Checking git status..."
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  Warning: You have uncommitted changes!"
    echo "   Please commit or stash them before releasing."
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "✅ Git working directory is clean"
fi
echo ""

# Clean and prepare
echo "🧹 Cleaning previous builds..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔧 Applying patches..."
if [ -f "./scripts/apply_patches.sh" ]; then
    ./scripts/apply_patches.sh
else
    echo "⚠️  No patches script found, skipping..."
fi

echo ""
echo "🏗️  Building iOS release..."
flutter build ios --release

echo ""
echo "✅ Build complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Open Xcode: open ios/Runner.xcworkspace"
echo "   2. Select 'Any iOS Device' as target"
echo "   3. Product → Archive"
echo "   4. In Organizer: Distribute App → TestFlight & App Store"
echo ""
echo "📚 See docs/TESTFLIGHT_RELEASE_GUIDE.md for detailed instructions"
echo ""


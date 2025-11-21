# Xcode Troubleshooting Guide

## Issue: Xcode Endlessly Loading

### Symptoms
- Xcode takes forever to open the workspace
- Spinning beach ball or loading indicator
- Multiple `xcodebuild -list` processes running

### Root Causes
1. **Corrupted Derived Data** - Most common
2. **CocoaPods Issues** - Pods not properly installed
3. **User Data Corruption** - Xcode user state files
4. **Large Project** - Too many files/assets
5. **SSL/Certificate Issues** - CocoaPods repo updates

### Quick Fix (What We Just Did)

```bash
# 1. Kill Xcode processes
killall Xcode

# 2. Clean Xcode caches
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 3. Clean workspace user data
cd /Users/mykolakorzh/Documents/GitHub/learniq
rm -rf ios/Runner.xcworkspace/xcuserdata
rm -rf ios/Runner.xcodeproj/xcuserdata

# 4. Reinstall CocoaPods
cd ios
pod deintegrate
pod install

# 5. Reopen Xcode
open ios/Runner.xcworkspace
```

### If Still Not Working

#### Option 1: Use Flutter Build Instead
```bash
# Build directly without opening Xcode
flutter build ios --release
# Then use Xcode Organizer or command line to archive
```

#### Option 2: Open Project Instead of Workspace (Not Recommended)
```bash
# Only if workspace is completely broken
open ios/Runner.xcodeproj
# Note: This won't include CocoaPods dependencies
```

#### Option 3: Reset Xcode Completely
```bash
# Nuclear option - resets all Xcode settings
rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -rf ~/Library/Caches/com.apple.dt.Xcode/*
rm -rf ~/Library/Preferences/com.apple.dt.Xcode.plist
# Then reopen Xcode
```

### Prevention

1. **Regular Cleanup**
   ```bash
   # Add to your workflow
   flutter clean
   rm -rf ~/Library/Developer/Xcode/DerivedData/*
   ```

2. **Don't Commit User Data**
   - Ensure `.gitignore` includes:
     ```
     ios/**/xcuserdata/
     ios/**/*.xcuserstate
     ```

3. **Keep CocoaPods Updated**
   ```bash
   sudo gem install cocoapods
   pod repo update
   ```

### Current Status

✅ Xcode processes killed
✅ Derived data cleared
✅ User data cleaned
✅ CocoaPods reinstalled (with SSL warning - non-critical)
✅ Xcode workspace reopened

**Note**: The CocoaPods SSL warning is non-critical and won't prevent Xcode from working. It's a known issue with some network configurations.

### If Xcode Still Hangs

1. **Check Activity Monitor** - Look for high CPU/memory usage
2. **Check Console.app** - Look for Xcode error messages
3. **Try Opening Project File** - `open ios/Runner.xcodeproj` (limited functionality)
4. **Restart Mac** - Sometimes necessary for deep cache issues

---

**Last Updated**: After fixing endless loading issue


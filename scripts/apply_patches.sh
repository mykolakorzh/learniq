#!/bin/bash
# Apply patches to pub dependencies
# This script should be run after 'flutter pub get' or 'flutter clean'

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PATCHES_DIR="$PROJECT_ROOT/patches"

echo "🔧 Applying dependency patches..."

# Function to apply a patch
apply_patch() {
    local package_name=$1
    local package_version=$2
    local patch_file="$PATCHES_DIR/${package_name}.patch"

    if [ ! -f "$patch_file" ]; then
        echo "⚠️  Warning: Patch file not found: $patch_file"
        return 1
    fi

    local package_path="$HOME/.pub-cache/hosted/pub.dev/${package_name}-${package_version}"

    if [ ! -d "$package_path" ]; then
        echo "⚠️  Warning: Package not found: $package_path"
        return 1
    fi

    # Check if patch is already applied by examining the actual file
    cd "$package_path"

    # For flutter_tts, check if the correct import is present
    if [ "$package_name" = "flutter_tts" ]; then
        # Check if file has the fixed import (without 'show kIsWeb')
        if grep -q "^import 'package:flutter/foundation.dart';$" "$package_path/lib/flutter_tts.dart" 2>/dev/null; then
            echo "✓ $package_name@$package_version is already patched"
            return 0
        fi

        # Check if file still has the broken import (with 'show kIsWeb')
        if grep -q "^import 'package:flutter/foundation.dart' show kIsWeb;$" "$package_path/lib/flutter_tts.dart" 2>/dev/null; then
            echo "✓ Applying patch for $package_name@$package_version..."
            patch -p1 -f --no-backup-if-mismatch < "$patch_file" > /dev/null 2>&1 && echo "✓ Patch applied successfully" || echo "⚠️  Failed to apply patch"
            return 0
        fi
    fi

    # Generic patch application
    if patch -p1 --dry-run --silent < "$patch_file" 2>/dev/null; then
        echo "✓ Applying patch for $package_name@$package_version..."
        patch -p1 -f --no-backup-if-mismatch < "$patch_file" > /dev/null 2>&1
        echo "✓ Patch applied successfully"
    else
        echo "✓ $package_name@$package_version is already patched"
    fi
}

# Apply flutter_tts patch
apply_patch "flutter_tts" "4.2.3"

echo "✅ Patch application complete!"

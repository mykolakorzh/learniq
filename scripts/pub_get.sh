#!/bin/bash
# Convenience script for running 'flutter pub get' with automatic patch application

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "📦 Running flutter pub get..."
cd "$PROJECT_ROOT"
flutter pub get

echo ""
echo "🔧 Applying patches..."
"$SCRIPT_DIR/apply_patches.sh"

echo ""
echo "✅ Done! Dependencies installed and patched."

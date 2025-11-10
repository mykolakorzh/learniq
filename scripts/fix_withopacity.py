#!/usr/bin/env python3
"""
Fix withOpacity() deprecation warnings
Replaces .withOpacity(value) with .withValues(alpha: value)
"""

import os
import re
import sys

def fix_with_opacity(file_path):
    """Replace withOpacity with withValues in a file"""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content

    # Replace .withOpacity(value) with .withValues(alpha: value)
    # This regex handles various spacing patterns
    content = re.sub(
        r'\.withOpacity\(([^)]+)\)',
        r'.withValues(alpha: \1)',
        content
    )

    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False

def main():
    files = [
        'lib/core/theme/app_theme.dart',
        'lib/screens/learn_screen.dart',
        'lib/screens/statistics_screen.dart',
        'lib/screens/topic_detail_screen.dart',
        'lib/screens/topics_screen.dart',
        'lib/screens/test_screen.dart',
        'lib/screens/onboarding_screen.dart',
        'lib/screens/settings_screen.dart',
        'lib/screens/main_navigation_screen.dart',
        'lib/theme/theme.dart',
        'lib/widgets/modern_components.dart',
    ]

    fixed_count = 0
    for file_path in files:
        if os.path.exists(file_path):
            if fix_with_opacity(file_path):
                print(f"✓ Fixed: {file_path}")
                fixed_count += 1
        else:
            print(f"⚠ Not found: {file_path}")

    print(f"\n{fixed_count} files updated")

if __name__ == '__main__':
    main()

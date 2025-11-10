#!/usr/bin/env python3
"""
Image Optimization Script for LearnIQ
Reduces image sizes from ~2.5MB to ~100KB while maintaining quality
Target: Reduce 763MB total to ~20MB
"""

import os
import sys
from PIL import Image
from pathlib import Path

# Configuration
MAX_WIDTH = 800  # Max width for images
MAX_HEIGHT = 800  # Max height for images
QUALITY = 85  # JPEG quality (85 is good balance)
TARGET_SIZE_KB = 150  # Target max size per image

def optimize_image(input_path, output_path=None):
    """Optimize a single image file"""
    if output_path is None:
        output_path = input_path

    try:
        with Image.open(input_path) as img:
            # Convert to RGB if necessary (for PNGs with transparency)
            if img.mode in ('RGBA', 'LA', 'P'):
                # Create white background
                background = Image.new('RGB', img.size, (255, 255, 255))
                if img.mode == 'P':
                    img = img.convert('RGBA')
                background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                img = background
            elif img.mode != 'RGB':
                img = img.convert('RGB')

            # Resize if too large
            width, height = img.size
            if width > MAX_WIDTH or height > MAX_HEIGHT:
                img.thumbnail((MAX_WIDTH, MAX_HEIGHT), Image.Resampling.LANCZOS)

            # Get file extension
            ext = os.path.splitext(output_path)[1].lower()

            # Save with optimization
            if ext in ['.jpg', '.jpeg']:
                img.save(output_path, 'JPEG', quality=QUALITY, optimize=True)
            elif ext == '.png':
                # Convert PNG to JPEG for smaller size
                jpg_path = output_path.rsplit('.', 1)[0] + '.jpg'
                img.save(jpg_path, 'JPEG', quality=QUALITY, optimize=True)
                # Remove original PNG if JPEG is smaller
                if os.path.exists(output_path) and os.path.exists(jpg_path):
                    if os.path.getsize(jpg_path) < os.path.getsize(output_path):
                        os.remove(output_path)
                        return jpg_path

            return output_path
    except Exception as e:
        print(f"Error optimizing {input_path}: {e}")
        return None

def get_file_size_mb(path):
    """Get file size in MB"""
    return os.path.getsize(path) / (1024 * 1024)

def optimize_directory(directory):
    """Optimize all images in a directory"""
    image_extensions = {'.png', '.jpg', '.jpeg'}

    total_before = 0
    total_after = 0
    optimized_count = 0

    # Get all image files
    image_files = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if any(file.lower().endswith(ext) for ext in image_extensions):
                # Skip files with "2" in name (duplicates)
                if ' 2.' in file:
                    continue
                image_files.append(os.path.join(root, file))

    print(f"Found {len(image_files)} images to optimize")
    print("=" * 60)

    for i, img_path in enumerate(image_files, 1):
        size_before = get_file_size_mb(img_path)
        total_before += size_before

        result_path = optimize_image(img_path)

        if result_path:
            size_after = get_file_size_mb(result_path)
            total_after += size_after
            reduction = ((size_before - size_after) / size_before * 100) if size_before > 0 else 0

            optimized_count += 1

            if i % 10 == 0 or reduction > 50:
                print(f"[{i}/{len(image_files)}] {os.path.basename(img_path)}: "
                      f"{size_before:.2f}MB → {size_after:.2f}MB ({reduction:.1f}% reduction)")

    print("=" * 60)
    print(f"\nOptimization Complete!")
    print(f"Images processed: {optimized_count}")
    print(f"Total size before: {total_before:.1f} MB")
    print(f"Total size after: {total_after:.1f} MB")
    print(f"Total reduction: {total_before - total_after:.1f} MB ({((total_before - total_after) / total_before * 100):.1f}%)")
    print(f"Average size per image: {(total_after / optimized_count * 1024):.0f} KB")

if __name__ == '__main__':
    assets_dir = 'assets/images'

    if not os.path.exists(assets_dir):
        print(f"Error: Directory '{assets_dir}' not found")
        print("Please run this script from the project root")
        sys.exit(1)

    print("LearnIQ Image Optimization Script")
    print("=" * 60)
    print(f"Target: Reduce images to ~{TARGET_SIZE_KB}KB each")
    print(f"Max dimensions: {MAX_WIDTH}x{MAX_HEIGHT}px")
    print(f"JPEG quality: {QUALITY}%")
    print("=" * 60)
    print()

    optimize_directory(assets_dir)

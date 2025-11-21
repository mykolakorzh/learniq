#!/usr/bin/env python3
"""
Image Validation Script for LearnIQ
Validates all image paths in cards.json and generates a report
"""

import json
import os
from pathlib import Path
from collections import defaultdict

def validate_images():
    """Validate all image paths in cards.json"""
    
    # Load cards
    cards_file = Path('assets/data/cards.json')
    if not cards_file.exists():
        print(f"Error: {cards_file} not found")
        return False
    
    with open(cards_file, 'r', encoding='utf-8') as f:
        cards = json.load(f)
    
    print(f"Validating {len(cards)} cards...")
    print("=" * 60)
    
    # Track issues
    missing_images = []
    valid_images = []
    issues_by_topic = defaultdict(list)
    
    # Get all actual image files
    image_files = set()
    for root, dirs, files in os.walk('assets/images'):
        for file in files:
            if file.lower().endswith(('.png', '.jpg', '.jpeg')):
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, 'assets')
                rel_path = rel_path.replace('\\', '/')
                image_files.add(f"assets/{rel_path}")
    
    # Validate each card
    for card in cards:
        card_id = card.get('id', 'unknown')
        topic_id = card.get('topic_id', 'unknown')
        image_path = card.get('image_asset', '')
        
        if not image_path:
            missing_images.append((card_id, topic_id, 'Missing image_asset field'))
            issues_by_topic[topic_id].append(card_id)
            continue
        
        # Check if file exists
        if image_path in image_files:
            valid_images.append(card_id)
        else:
            # Try to find alternative
            path_parts = image_path.split('/')
            filename = path_parts[-1] if path_parts else ''
            base_name = os.path.splitext(filename)[0].lower()
            
            found_alternative = False
            for img_file in image_files:
                img_filename = os.path.basename(img_file)
                img_base = os.path.splitext(img_filename)[0].lower()
                if img_base == base_name:
                    missing_images.append((
                        card_id,
                        topic_id,
                        f'Path mismatch: {image_path} -> should be {img_file}'
                    ))
                    issues_by_topic[topic_id].append(card_id)
                    found_alternative = True
                    break
            
            if not found_alternative:
                missing_images.append((card_id, topic_id, f'Image not found: {image_path}'))
                issues_by_topic[topic_id].append(card_id)
    
    # Print results
    print(f"\n✅ Valid images: {len(valid_images)}")
    print(f"❌ Issues found: {len(missing_images)}")
    
    if missing_images:
        print("\n" + "=" * 60)
        print("ISSUES BY TOPIC:")
        print("=" * 60)
        
        for topic_id, card_ids in sorted(issues_by_topic.items()):
            print(f"\n{topic_id}: {len(card_ids)} issues")
            for card_id in card_ids[:5]:  # Show first 5
                issue = next((m for m in missing_images if m[0] == card_id), None)
                if issue:
                    print(f"  - {card_id}: {issue[2]}")
            if len(card_ids) > 5:
                print(f"  ... and {len(card_ids) - 5} more")
        
        print("\n" + "=" * 60)
        print("DETAILED ISSUES:")
        print("=" * 60)
        for card_id, topic_id, issue in missing_images[:20]:  # Show first 20
            print(f"{card_id} ({topic_id}): {issue}")
        
        if len(missing_images) > 20:
            print(f"\n... and {len(missing_images) - 20} more issues")
    
    # Summary
    print("\n" + "=" * 60)
    print("SUMMARY")
    print("=" * 60)
    print(f"Total cards: {len(cards)}")
    print(f"Valid: {len(valid_images)} ({len(valid_images)/len(cards)*100:.1f}%)")
    print(f"Invalid: {len(missing_images)} ({len(missing_images)/len(cards)*100:.1f}%)")
    
    return len(missing_images) == 0

if __name__ == '__main__':
    # Change to project root
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    os.chdir(project_root)
    
    success = validate_images()
    exit(0 if success else 1)


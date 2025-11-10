#!/usr/bin/env python3
"""
Fix critical data issues in LearnIQ:
1. Count actual cards per topic and update topics.json
2. Generate Ukrainian translations from Russian
"""

import json
from pathlib import Path
from collections import Counter

# Paths
PROJECT_ROOT = Path("/Users/mykolakorzh/Documents/GitHub/learniq")
CARDS_PATH = PROJECT_ROOT / "assets/data/cards.json"
TOPICS_PATH = PROJECT_ROOT / "assets/data/topics.json"
BACKUP_CARDS = PROJECT_ROOT / "assets/data/cards.json.backup"
BACKUP_TOPICS = PROJECT_ROOT / "assets/data/topics.json.backup"

# Russian to Ukrainian translation mapping
# Since they're similar languages, many words are the same or very similar
RU_TO_UK_MAP = {
    # Common patterns
    "ый": "ий",
    "ая": "а",
    "ое": "е",
    # Specific translations from existing topics.json
    "Квартира": "Квартира",  # Same
    "Транспорт": "Транспорт",  # Same
    "Одежда": "Одяг",
    "Природа": "Природа",  # Same
    "Город": "Місто",
    "Животные": "Тварини",
    "Тело": "Тіло",
}

def load_json(path):
    """Load JSON file"""
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def save_json(path, data):
    """Save JSON file with pretty formatting"""
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"✅ Saved: {path}")

def backup_file(source, backup):
    """Create backup of file"""
    import shutil
    shutil.copy2(source, backup)
    print(f"📦 Backup created: {backup}")

def count_cards_by_topic(cards):
    """Count actual cards per topic"""
    topic_counts = Counter(card['topic_id'] for card in cards)
    return dict(topic_counts)

def translate_ru_to_uk(russian_text):
    """
    Simple Russian to Ukrainian translation
    For proper translation, words should be mapped individually
    """
    if not russian_text:
        return ""

    # Check if already translated
    if russian_text in RU_TO_UK_MAP:
        return RU_TO_UK_MAP[russian_text]

    # Simple pattern-based translation (very basic)
    ukrainian = russian_text

    # Replace common endings
    for ru_ending, uk_ending in [("ый", "ий"), ("ая", "а"), ("ое", "е")]:
        if ukrainian.endswith(ru_ending):
            ukrainian = ukrainian[:-len(ru_ending)] + uk_ending
            break

    return ukrainian

def fix_card_counts():
    """Fix card counts in topics.json"""
    print("\n=== Phase 1: Fix Card Counts ===")

    # Load data
    cards = load_json(CARDS_PATH)
    topics = load_json(TOPICS_PATH)

    # Count actual cards
    actual_counts = count_cards_by_topic(cards)

    print(f"\n📊 Card Count Analysis:")
    print(f"Total cards in cards.json: {len(cards)}")
    print(f"\nPer topic:")

    # Update topics with correct counts
    total_declared = 0
    for topic in topics:
        topic_id = topic['id']
        old_count = topic['card_count']
        new_count = actual_counts.get(topic_id, 0)
        total_declared += old_count

        status = "✅" if old_count == new_count else "❌ MISMATCH"
        print(f"  {topic_id:12} - declared: {old_count:2}, actual: {new_count:2} {status}")

        # Update count
        topic['card_count'] = new_count

    print(f"\nTotal declared in topics.json: {total_declared}")
    print(f"Total actual in cards.json: {len(cards)}")
    print(f"Difference: {len(cards) - total_declared}")

    # Backup and save
    backup_file(TOPICS_PATH, BACKUP_TOPICS)
    save_json(TOPICS_PATH, topics)

    return actual_counts

def add_ukrainian_translations():
    """Add Ukrainian translations to all cards"""
    print("\n=== Phase 2: Add Ukrainian Translations ===")

    # Load cards
    cards = load_json(CARDS_PATH)

    missing_uk = 0
    added_uk = 0

    for card in cards:
        if not card.get('translation_uk'):
            missing_uk += 1

            # Get Russian translation (which might actually be German word)
            russian = card.get('translation_ru', '')

            # Translate to Ukrainian
            ukrainian = translate_ru_to_uk(russian)

            # Update card
            card['translation_uk'] = ukrainian
            added_uk += 1

    print(f"📝 Translation Results:")
    print(f"  Cards with missing Ukrainian: {missing_uk}")
    print(f"  Translations added: {added_uk}")

    # Backup and save
    backup_file(CARDS_PATH, BACKUP_CARDS)
    save_json(CARDS_PATH, cards)

    return added_uk

def main():
    """Main execution"""
    print("🔧 LearnIQ Data Fixer")
    print("=" * 50)

    # Phase 1: Fix card counts
    actual_counts = fix_card_counts()

    # Phase 2: Add Ukrainian translations
    translations_added = add_ukrainian_translations()

    # Summary
    print("\n" + "=" * 50)
    print("✅ COMPLETED")
    print(f"  Card counts updated in topics.json")
    print(f"  {translations_added} Ukrainian translations added")
    print(f"  Backups created:")
    print(f"    - {BACKUP_TOPICS}")
    print(f"    - {BACKUP_CARDS}")
    print("\n⚠️  NOTE: Auto-translations are basic.")
    print("   Review Ukrainian translations for accuracy.")

if __name__ == "__main__":
    main()

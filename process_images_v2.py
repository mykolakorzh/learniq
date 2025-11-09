#!/usr/bin/env python3
"""
Process and standardize LearnIQ topic images - FIXED VERSION.
"""

import os
import re
import shutil
from pathlib import Path

# Paths
DOWNLOAD_PATH = Path.home() / "Downloads" / "Learniq Topics Cards"
ASSETS_PATH = Path("/Users/mykolakorzh/Documents/GitHub/learniq/assets/images")

# Topic folder mapping
TOPIC_MAPPING = {
    "Fahrzeug": "fahrzeug",
    "Kleidung": "kleidung",
    "Natur": "natur",
    "Stadt": "stadt",
    "Tiere": "tiere",
    "Тело - Körper": "korper",
    "Wohnung": "wohnung"
}

# Wohnung Russian to German mapping
WOH_MAPPING = {
    "дверь": "tuer",
    "балкон": "balkon",
    "квартира": "wohnung",
    "лифт": "aufzug",
    "коридор": "flur",
    "окно": "fenster",
    "потолок": "decke",
    "пол": "boden",
    "стена": "wand",
    "лестница": "treppe",
    "подвал": "keller",
    "чердак": "dachboden",
    "шкаф": "schrank",
    "стул": "stuhl",
    "стол": "tisch",
    "кровать": "bett",
    "кресло": "sessel",
    "душ": "dusche",
    "диван": "sofa",
    "ковёр": "teppich",
    "занавеска": "vorhang",
    "зеркало": "spiegel",
    "розетка": "steckdose",
    "обогреватель": "heizung",
    "холодильник": "kuehlschrank",
    "телевизор": "fernseher",
    "ванна": "badewanne",
    "туале": "toilette",  # Added toilet
    "туалет": "toilette",
    "гостиная": "wohnzimmer",
    "спальня": "schlafzimmer",
    "кухня": "kueche",
    "ванная": "badezimmer",
    "комната": "zimmer",
}

# Körper Russian to German mapping
KORPER_MAPPING = {
    "бедро": "oberschenkel",
    "бровь": "augenbraue",
    "волосы": "haare",
    "глаз": "auge",
    "голова": "kopf",
    "горло": "hals",
    "грудь": "brust",
    "губа": "lippe",
    "зуб": "zahn",
    "кисть": "hand",
    "колено": "knie",
    "кулак": "faust",
    "лицо": "gesicht",
    "лоб": "stirn",
    "локоть": "ellbogen",
    "нога": "bein",
    "ноготь": "nagel",
    "нос": "nase",
    "палец": "finger",
    "плечо": "schulter",
    "подбородок": "kinn",
    "пятка": "ferse",
    "рот": "mund",
    "рука": "arm",
    "спина": "ruecken",
    "ухо": "ohr",
    "чб": "_gray",  # For _чб pattern
}

def clean_filename(filename, source_topic):
    """Clean and standardize filename."""
    # Save original extension
    ext_match = re.search(r'\.(png|PNG|jpg|JPG)$', filename)
    if not ext_match:
        return None, False  # Skip if no valid extension

    ext = ext_match.group(1).lower()

    # Remove extension temporarily
    name = filename[:-len(ext)-1]

    # Remove number prefixes like "01 ", "02 "
    name = re.sub(r'^\d+\s+', '', name)

    # Handle " 2", " (2)" type duplicates - remove them
    name = re.sub(r'\s*\(\d+\)$', '', name)
    name = re.sub(r'\s+\d+$', '', name)

    # Check for gray markers
    is_gray = "ч.б" in name or "ч б" in name or "_чб" in name or "чб" in name

    # Remove Russian "ч.б." markers
    name = re.sub(r'\s*ч\.?\s*б\.?\s*', '', name)
    name = re.sub(r'_?чб', '', name)

    # Translate Russian names
    if source_topic == "Wohnung":
        for rus, ger in WOH_MAPPING.items():
            if rus in name:
                name = name.replace(rus, ger)
                break
    elif source_topic == "Тело - Körper":
        for rus, ger in KORPER_MAPPING.items():
            if rus in name:
                name = name.replace(rus, ger)
                break

    # Check if already has _gray suffix
    has_gray_suffix = "_gray" in name.lower()

    # Add _gray suffix if needed and not already present
    if is_gray and not has_gray_suffix:
        name = name + "_gray"

    # Clean up multiple underscores/spaces
    name = re.sub(r'_+', '_', name)
    name = re.sub(r'\s+', '_', name)
    name = name.strip('_')

    # Convert to lowercase
    name = name.lower()

    # Reconstruct with cleaned extension
    final_name = f"{name}.{ext}"

    return final_name, False

def process_topic(source_topic, target_topic):
    """Process one topic folder."""
    source_path = DOWNLOAD_PATH / source_topic
    target_path = ASSETS_PATH / target_topic

    # Create target directory
    target_path.mkdir(parents=True, exist_ok=True)

    print(f"\nProcessing {source_topic} -> {target_topic}")

    # Get all image files
    image_files = []
    for ext in ['*.png', '*.PNG', '*.jpg', '*.JPG']:
        image_files.extend(source_path.glob(ext))

    processed = 0
    skipped = 0
    for img_file in image_files:
        filename = img_file.name

        # Clean filename
        clean_name, _ = clean_filename(filename, source_topic)

        if clean_name is None:
            skipped += 1
            continue

        # Copy file
        target_file = target_path / clean_name
        shutil.copy2(img_file, target_file)
        processed += 1

        if processed <= 3:  # Show first 3 as samples
            print(f"  {img_file.name} -> {clean_name}")

    print(f"  ✓ Processed {processed} files (skipped {skipped})")

def main():
    print("LearnIQ Image Processor v2")
    print("=" * 50)

    # Check if download path exists
    if not DOWNLOAD_PATH.exists():
        print(f"❌ Error: Download path not found: {DOWNLOAD_PATH}")
        return

    # Clean existing assets folders first
    print("\nCleaning existing assets...")
    for target_topic in TOPIC_MAPPING.values():
        target_path = ASSETS_PATH / target_topic
        if target_path.exists():
            shutil.rmtree(target_path)
            print(f"  Removed {target_topic}/")

    # Process each topic
    for source_topic, target_topic in TOPIC_MAPPING.items():
        process_topic(source_topic, target_topic)

    print("\n" + "=" * 50)
    print("✅ All images processed successfully!")
    print(f"Images saved to: {ASSETS_PATH}")

if __name__ == "__main__":
    main()

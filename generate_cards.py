#!/usr/bin/env python3
"""
Generate cards.json from processed images.
Note: Articles (der/die/das) are estimates and should be verified!
"""

import json
import os
from pathlib import Path

ASSETS_PATH = Path("/Users/mykolakorzh/Documents/GitHub/learniq/assets/images")
OUTPUT_PATH = Path("/Users/mykolakorzh/Documents/GitHub/learniq/assets/data/cards.json")

# Known articles from existing data + common patterns
KNOWN_ARTICLES = {
    # Wohnung
    "zimmer": "das", "wohnzimmer": "das", "schlafzimmer": "das", "badezimmer": "das",
    "kueche": "die", "badewanne": "die", "toilette": "die", "tuer": "die",
    "fenster": "das", "decke": "die", "wand": "die", "treppe": "die",
    "flur": "der", "balkon": "der", "aufzug": "der", "keller": "der",
    "dachboden": "der", "schrank": "der", "stuhl": "der", "tisch": "der",
    "bett": "das", "sessel": "der", "dusche": "die", "sofa": "das",
    "teppich": "der", "vorhang": "der", "spiegel": "der", "steckdose": "die",
    "heizung": "die", "kuehlschrank": "der", "fernseher": "der", "boden": "der",

    # Körper
    "kopf": "der", "auge": "das", "nase": "die", "mund": "der",
    "ohr": "das", "zahn": "der", "haar": "das", "haare": "die",
    "hand": "die", "arm": "der", "bein": "das", "fuss": "der",
    "finger": "der", "knie": "das", "schulter": "die", "ruecken": "der",
    "brust": "die", "bauch": "der", "hals": "der", "gesicht": "das",
    "stirn": "die", "kinn": "das", "lippe": "die", "augenbraue": "die",
    "ellbogen": "der", "faust": "die", "ferse": "die", "nagel": "der",
    "oberschenkel": "der",

    # Transport
    "auto": "das", "bus": "der", "zug": "der", "flugzeug": "das",
    "fahrrad": "das", "motorrad": "das", "schiff": "das", "boot": "das",
    "ampel": "die", "strasse": "die", "autobahn": "die", "bahnhof": "der",
    "flughafen": "der", "haltestelle": "die", "parkplatz": "der",
    "tunnel": "der", "bruecke": "die", "kreuzung": "die",
    "buergersteig": "der", "fussgaenger": "der",

    # Stadt
    "haus": "das", "gebaeude": "das", "schule": "die", "kirche": "die",
    "krankenhaus": "das", "apotheke": "die", "bank": "die", "post": "die",
    "restaurant": "das", "cafe": "das", "hotel": "das", "park": "der",
    "platz": "der", "markt": "der", "geschaeft": "das", "supermarkt": "der",
    "kino": "das", "theater": "das", "museum": "das", "bibliothek": "die",
    "rathaus": "das", "polizei": "die", "feuerwehr": "die",
    "stadt": "die", "dorf": "das",

    # Tiere
    "hund": "der", "katze": "die", "pferd": "das", "kuh": "die",
    "schwein": "das", "schaf": "das", "ziege": "die", "huhn": "das",
    "vogel": "der", "fisch": "der", "maus": "die", "elefant": "der",
    "loewe": "der", "tiger": "der", "baer": "der", "affe": "der",
    "schlange": "die", "frosch": "der", "schmetterling": "der",
    "biene": "die", "fliege": "die", "spinne": "die", "delfin": "der",
    "ente": "die", "gans": "die", "buer": "der", "eichhoernchen": "das",
    "igel": "der", "hase": "der", "fuchs": "der", "hirsch": "der",

    # Natur
    "baum": "der", "blume": "die", "gras": "das", "wald": "der",
    "berg": "der", "fluss": "der", "see": "der", "meer": "das",
    "himmel": "der", "sonne": "die", "mond": "der", "stern": "der",
    "wolke": "die", "regen": "der", "schnee": "der", "wind": "der",
    "blatt": "das", "wurzel": "die", "ast": "der", "pilz": "der",
    "stein": "der", "sand": "der", "erde": "die", "wasser": "das",
    "feuer": "das", "regenbogen": "der", "nebel": "der", "gewitter": "das",
    "bach": "der", "beere": "die", "zapfen": "der", "hain": "der",
    "koralle": "die", "riff": "das", "sturm": "der", "orkan": "der",
    "reif": "der", "eiszapfen": "der",

    # Kleidung
    "hose": "die", "hemd": "das", "kleid": "das", "rock": "der",
    "jacke": "die", "mantel": "der", "pullover": "der", "tshirt": "das",
    "schuh": "der", "socke": "die", "hut": "der", "muetze": "die",
    "handschuh": "der", "schal": "der", "guertel": "der",
    "bluse": "die", "anzug": "der", "jeans": "die", "stiefel": "der",
    "tasche": "die", "rucksack": "der", "krawatte": "die",
    "schlafanzug": "der", "unterhemd": "das", "shorts": "die",
}

# Russian translations (partial - from mappings)
RUS_TRANSLATIONS = {
    # Wohnung
    "tuer": "дверь", "balkon": "балкон", "wohnung": "квартира",
    "aufzug": "лифт", "flur": "коридор", "fenster": "окно",
    "decke": "потолок", "boden": "пол", "wand": "стена",
    "treppe": "лестница", "keller": "подвал", "dachboden": "чердак",
    "schrank": "шкаф", "stuhl": "стул", "tisch": "стол",
    "bett": "кровать", "sessel": "кресло", "dusche": "душ",
    "sofa": "диван", "teppich": "ковёр", "vorhang": "занавеска",
    "spiegel": "зеркало", "steckdose": "розетка", "heizung": "обогреватель",
    "kuehlschrank": "холодильник", "fernseher": "телевизор",
    "badewanne": "ванна", "toilette": "туалет", "wohnzimmer": "гостиная",
    "schlafzimmer": "спальня", "kueche": "кухня", "badezimmer": "ванная",
    "zimmer": "комната",

    # Körper
    "oberschenkel": "бедро", "augenbraue": "бровь", "haare": "волосы",
    "auge": "глаз", "kopf": "голова", "hals": "горло",
    "brust": "грудь", "lippe": "губа", "zahn": "зуб",
    "hand": "кисть", "knie": "колено", "faust": "кулак",
    "gesicht": "лицо", "stirn": "лоб", "ellbogen": "локоть",
    "bein": "нога", "nagel": "ноготь", "nase": "нос",
    "finger": "палец", "schulter": "плечо", "kinn": "подбородок",
    "ferse": "пятка", "mund": "рот", "arm": "рука",
    "ruecken": "спина", "ohr": "ухо",
}

def guess_article(word):
    """Guess article based on known words and patterns."""
    word_lower = word.lower()

    # Check known articles
    if word_lower in KNOWN_ARTICLES:
        return KNOWN_ARTICLES[word_lower]

    # Pattern-based guessing (not always accurate!)
    # Diminutives with -chen or -lein are "das"
    if word_lower.endswith(('chen', 'lein')):
        return "das"

    # Words ending in -ung, -heit, -keit, -schaft, -ei are usually "die"
    if word_lower.endswith(('ung', 'heit', 'keit', 'schaft', 'ei', 'ie', 'ik', 'ion', 'taet', 'ur')):
        return "die"

    # Words ending in -er, -el, -en are often "der"
    if word_lower.endswith(('er', 'el', 'en')):
        return "der"

    # Default to "der" if unsure (most common)
    return "der"

def get_translation(word):
    """Get Russian translation."""
    word_lower = word.lower()
    if word_lower in RUS_TRANSLATIONS:
        return RUS_TRANSLATIONS[word_lower]
    # Return German word if no translation
    return word.capitalize()

def generate_cards():
    """Generate cards from image files."""
    cards = []
    card_counter = 1

    topics = ["fahrzeug", "kleidung", "natur", "stadt", "tiere", "korper", "wohnung"]

    for topic in topics:
        topic_path = ASSETS_PATH / topic
        if not topic_path.exists():
            continue

        # Get all non-gray images (color versions only)
        image_files = [f for f in topic_path.glob("*.png") if "_gray" not in f.name]
        image_files += [f for f in topic_path.glob("*.jpg") if "_gray" not in f.name]

        for img_file in sorted(image_files):
            # Extract noun from filename
            noun = img_file.stem  # filename without extension
            noun_clean = noun.replace("_", " ").title()

            # Guess article
            article = guess_article(noun)

            # Get translation
            translation = get_translation(noun)

            # Create card
            card = {
                "id": f"{topic}_{card_counter:02d}",
                "topic_id": topic,
                "noun_de": noun_clean,
                "article": article,
                "phonetic": "",
                "translation_ru": translation,
                "translation_uk": "",
                "image_asset": f"assets/images/{topic}/{img_file.name}"
            }

            cards.append(card)
            card_counter += 1

    return cards

def main():
    print("Generating cards.json...")

    cards = generate_cards()

    # Write to file
    with open(OUTPUT_PATH, 'w', encoding='utf-8') as f:
        json.dump(cards, f, ensure_ascii=False, indent=2)

    print(f"✅ Generated {len(cards)} cards")
    print(f"Saved to: {OUTPUT_PATH}")
    print("\n⚠️  Note: Articles (der/die/das) are estimates. Please verify!")

if __name__ == "__main__":
    main()

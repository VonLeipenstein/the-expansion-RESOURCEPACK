import json
from pathlib import Path
from collections import defaultdict

INPUT_FILE = Path("original.json")
OUTPUT_DIR = Path("split_fonts")

# Starting glyph for each file.
START_CODEPOINT = 0xFF00


def categorize(provider):
    if provider.get("type") == "space":
        return "items"

    file = provider.get("file", "").lower()

    # Pictures: landscapes, guide page, and crafting illustration.
    if (
        "/landscapes/" in file
        or "guide_frontpage" in file
        or "/fabricator/crafting.png" in file
    ):
        return "pictures"

    # All recipe images.
    if "pictures/recipes/" in file:
        return "recipes"

    # Block icons.
    if ":blocks/" in file:
        return "blocks"

    # All remaining item icons, vehicle icons, and mob icons.
    if "/items/" in file or "/vehicles/" in file or "/mobs/" in file:
        return "items"

    # Preserve unexpected providers instead of dropping them.
    return "items"


def main():
    with INPUT_FILE.open("r", encoding="utf-8") as f:
        data = json.load(f)

    if not isinstance(data.get("providers"), list):
        raise ValueError("Input JSON must contain a providers array.")

    categories = defaultdict(list)

    for provider in data["providers"]:
        categories[categorize(provider)].append(provider)

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    total_providers = 0

    for category in ("items", "blocks", "recipes", "pictures"):
        providers = categories.get(category, [])

        # Reassign bitmap glyphs sequentially within each category.
        next_codepoint = START_CODEPOINT

        for provider in providers:
            if provider.get("type") == "bitmap":
                glyph = f"\\u{next_codepoint:04x}"
                provider["chars"] = [glyph]
                next_codepoint += 1

                if next_codepoint > 0xFFFF:
                    raise ValueError(
                        f"BMP Unicode codepoint limit exceeded in {category}.json"
                    )

        output_file = OUTPUT_DIR / f"{category}.json"

        with output_file.open("w", encoding="utf-8") as f:
            json.dump(
                {"providers": providers},
                f,
                indent=2,
                ensure_ascii=True,
            )
            f.write("\n")

        total_providers += len(providers)

        print(
            f"{output_file}: "
            f"{len(providers)} providers, "
            f"{sum(p.get('type') == 'bitmap' for p in providers)} bitmap glyphs"
        )

    print(f"\nFinished: {OUTPUT_DIR.resolve()}")
    print(f"Total providers processed: {total_providers}")


if __name__ == "__main__":
    main()
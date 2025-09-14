#!/usr/bin/env python3
import re, sys, pathlib

ROOT = pathlib.Path(__file__).resolve().parents[1]
DESIGN = ROOT / "docs" / "design"

# Palette: example forbidden colors (extend as needed)
FORBIDDEN_HEX = {
    "#ff0000", "#00ff00", "#0000ff"  # replace with actual forbidden hexes if specified
}

# Telegraph timing keys required in tables (add/adjust to match archive rules)
REQUIRED_TELEGRAPH_KEYS = {"startup", "active", "recovery", "cooldown"}

def fail(msg):
    print(f"VALIDATION ERROR: {msg}")
    sys.exit(1)

def check_palette():
    bad = set()
    for p in DESIGN.rglob("*.md"):
        text = p.read_text(encoding="utf-8", errors="ignore").lower()
        for hexcode in re.findall(r"#(?:[0-9a-f]{3}|[0-9a-f]{6})", text):
            if hexcode in FORBIDDEN_HEX:
                bad.add((p, hexcode))
    if bad:
        lines = "\n".join(f"- {p}:{h}" for p, h in sorted(bad))
        fail(f"Forbidden palette hex codes used:\n{lines}")

def check_telegraph_tables():
    missing_files = []
    for p in DESIGN.rglob("*.md"):
        text = p.read_text(encoding="utf-8", errors="ignore").lower()
        # quick heuristic: if a 'telegraph' table is present, require keys
        if "telegraph" in text and "|" in text:
            for key in REQUIRED_TELEGRAPH_KEYS:
                if key not in text:
                    missing_files.append((p, key))
    if missing_files:
        lines = "\n".join(f"- {p}: missing '{k}'" for p, k in missing_files)
        fail(f"Telegraph tables missing required keys:\n{lines}")


def check_arena_cards():
    from pathlib import Path
    AR = Path("docs/design/arena_cards")
    if not AR.exists():
        return
    required_kv = ["Name:", "Tier:", "Biome:", "Recommended Power:", "Rewards:"]
    required_sections = ["**Objective**", "**Modifiers**", "**Wave Plan (summary)**"]
    errors = []
    for md in AR.glob("*.md"):
        txt = md.read_text(encoding="utf-8", errors="ignore")
        # Metadata KV lines
        for kv in required_kv:
            if kv not in txt:
                errors.append(f"{md}: missing metadata field '{kv}'")
        # Sections
        for sec in required_sections:
            if sec not in txt:
                errors.append(f"{md}: missing section '{sec}'")
    if errors:
        raise SystemExit("Arena card schema errors:\\n" + "\\n".join("- " + e for e in errors))

def main():

    if not DESIGN.exists():
        print("No docs/design directory; skipping.", file=sys.stderr)
        return
    check_palette()
    check_telegraph_tables()
    check_arena_cards()
    print("Design rules OK.")

if __name__ == "__main__":
    main()

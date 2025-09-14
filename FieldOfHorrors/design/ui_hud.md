# UI / HUD Spec – Field of Horrors

## Principles
- **Readable at a glance** on 1080p and Steam Deck.
- Big fonts, high contrast; avoid thin strokes and tiny icons.
- Color-blind safe: do not rely on hue alone.

## HUD Elements (Default Layout)
- **Top-left:** Player HP bar + class icon + stamina bar.
- **Top-right:** Timer; wave/boss indicator; hazard icon queue.
- **Bottom-left:** Weapon icon + ammo/stamina cues; combo meter.
- **Bottom-right:** Mini-log (elite spawns, drops) with icons.
- **Center popups:** Damage numbers (toggle), hit flashes (brief), status icons.

## Style
- Comic/Borderlands vibe: thick outlines, cel-shaded icon art.
- Your locked palette for bars/frames; 1 wild-card color per status if needed.

## Color-Blind Support
- UI preference: **Normal / Deuter / Protan / Tritan** variants.
- Status effects use **icon shapes + patterns**:
  - Stun = lightning bolt in hexagon.
  - Bleed = droplet in triangle.
  - Slow = snowflake in diamond.
  - Confuse = swirl in circle.
- Damage types differentiated by **icon & texture** (not hue only).

## Feedback & Telemetry
- Hit flash: 50–80 ms white overlay with alpha; headshot/crit = gold starburst.
- Enemy elite modifier badges appear over unit frames.
- Pickup callouts with **icon + word** (“Scrap”, “Resin”, “Gem”).
- Controller rumble on heavy hits (optional).

## Menus (Deck-friendly)
- Font size presets: **Large / XL / XXL**.
- Button targets ≥ 44 px; focus states are obvious.
- Pause menu: resume → settings → controls → quit (last).

## Options
- Damage numbers: **None / Minimal / Full**.
- Motion: screen shake (0–100), camera sway toggle.
- Color-blind preset + custom saturation slider.
- Audio ducking slider for VO vs music.

## Implementation Notes
- UI is **data-driven**: JSON or resources for bars, icons, and strings.
- Localize all text from day one (keys in `docs/i18n.md` later).


# Point Guard

**Sport:** Basketball • **Role:** Mobility / support
**Movement:** SPD 6.2 • **HP:** 95 • **Grit Cap:** 20 • **Armor:** Light

## Default Weapons

- **Primary: Energy Pass** – ranged pass attack (stats TBD; no baseline in `design/weapon_balance.md` yet).
- **Secondary: Dashes** – mobility in place of a second weapon.

## Signature

- **Cross-Over Dash** – extra dash with short i-frames (0.15s i-frames, 3.5s cooldown at rank I).

## Skills (Early → Mid)

1. **Cross-Over Dash I → II** – +1 dash with short i-frames, then the dash leaves a 2.0s slow field.
2. **No-Look Pass I → II** – +10% attack speed buff on an ally or summon (6s cooldown), then adds a small heal on the pass target.
3. **Floor General I → Pick-and-Roll** – +5% team move speed aura, then a dash-through that causes a brief stun (0.5s stun, 10s cooldown).

## Capstone (≈6–7 min)

- **Full Court Press** – global -20% enemy speed and +10% team haste for 10s (30s cooldown).

## Perks (passive nodes)

Full list in [detail/point_guard.md](detail/point_guard.md). Two branches:

- **Speed Game:** Ankles (+10% move speed), Breakaway (-12% dash cooldown), keystone Cross-Over (+1 dash charge).
- **Court Control:** Pick-and-Roll (+300ms stun on dash), Floor General (+6% team haste), keystone No-Look Pass (+10% ally attack speed).

## Debuff Crystals

- **Light Frame** – -10% max HP, +10% move speed.
- **Fatigue** – -stamina regen, +crit chance.

## Tips

- Lowest HP in the roster: survive by dashing, not by trading hits.
- Most of the kit buffs allies and summons, so the class is strongest in co-op.
- Timing reference: `design/classes/telegraphs/point_guard.md`.

## Open Questions

- `design/skilltrees/point_guard_skilltree.mmd` is cut off before its capstone section, and the timing doc is cut off after "Readability".
- The timing doc lists **Fast Break** (haste on elite kill, 6s) with no matching tree node; it may be the second capstone.
- An earlier page described Pick & Roll as an ally tether (+move/reload/throw speed) instead of a dash-through stun.
- The v0.1 loadout in `game/classes.yaml` used an Assist Pistol and Carbine. Neither is in the GDD.

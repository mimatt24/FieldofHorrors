# Batter

**Sport:** Baseball • **Role:** Melee crit / knockback bruiser
**Movement:** SPD 5.8 • **HP:** 125 • **Grit Cap:** 35 • **Armor:** Medium

## Default Weapons

- **Primary: Wooden Bat** – 22 dmg, 1.6/s, ~35 DPS, wide arc, small knockback. Upgrades into the Batblade line (`design/weapon_balance.md`, `design/weapon_trees/batblade_tree.mmd`).
- **Secondary: Foam Finger Pike** – see [weapons/foam_finger_pike.md](../weapons/foam_finger_pike.md) (stats still TBD there).

## Signature

- **Power Swing** – full-windup arc that deals high damage and stagger, breaks guard, and knocks down armored or marked targets. A charged variant widens the arc.

## Skills (Early → Mid)

1. **Home Run Timing I → II** – a perfectly timed hit gains +50% crit, then also creates a shockwave.
2. **Line Drive I → II** – 3-hit combo whose last hit adds knockback, then finishers cleave nearby foes.
3. **Pit Grip I → II** – -10% stamina cost on swings, then -20% stamina cost and +5% attack speed.

## Capstone (≈6–7 min)

- **Blood Diamond Bat** – finishers auto-crit and apply Bleed on crit.

## Perks (passive nodes)

Full list in [detail/batter.md](detail/batter.md). Two branches:

- **Combo Engine:** Three Count (+20% combo build rate), Finish Him (+25% finisher damage), keystone On the Sweet Spot (+50% timed crit bonus).
- **Bleed:** Razor Tape (+12% bleed chance), Open Wound (+20% bleed DPS), keystone Home Crowd (+20% knockback).

## Debuff Crystals

- **Heavy Bat** – -8% move speed, +12% bat damage.
- **Glass Hands** – -10% block/parry, +15% crit damage.

## Tips

- Melee carries a risk premium: Batter DPS should sit above ranged classes at the same tier.
- Build the combo on trash, then spend the finisher on elites.
- Timing reference: [telegraphs/batter.md](../telegraphs/batter.md) (Bunt Jab, Power Swing, Pop-Fly Uppercut).

## Open Questions

- The skill tree lists **Slugger's Rage** (10s enrage on killstreak) as a second capstone.
- The v0.1 loadout in `game/classes.yaml` gave Batter an SMG, Bunt (parry), Pine Tar, and a Grand Slam ultimate. None of that is in the GDD.

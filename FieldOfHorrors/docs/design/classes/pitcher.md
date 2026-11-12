# Pitcher

**Sport:** Baseball • **Role:** Ranged precision / control
**Movement:** SPD 6.1 • **HP:** 100 • **Grit Cap:** 25 • **Armor:** Light

## Default Weapons

- **Primary: Baseballs** – Fastball (18 dmg, 3.0/s, ~54 DPS, pierce 1, long-range crit) and Curveball (14 dmg, 2.6/s, ~36 DPS, slow/confuse chance). Baselines from `design/weapon_balance.md`.
- **Secondary: Whistle Bomb** – arc throw, 3s fuse, cookable. See [weapons/whistle_bomb.md](../weapons/whistle_bomb.md) (stats still TBD there).

## Signature

- **Curveball** – arcing projectile that slows and can confuse on hit.

## Skills (Early → Mid)

1. **Fastball I → II** – +projectile speed and +1 pierce, then +crit chance at long range.
2. **Curveball I → II** – arcing path with low confuse chance, then a wider arc with slow on near miss.
3. **Rosin Bag I → Change-Up** – -10% stamina on throws, then random speed variance with a bonus damage window.

## Capstone (≈6–7 min)

- **Grand Slam Pitch** – casts 5 flaming fastballs in a spread; fire DoT tuned against mid-run elite HP.

## Perks (passive nodes)

Full list in [detail/pitcher.md](detail/pitcher.md). Two branches:

- **Long Range:** Grip Strength (+12% projectile speed), Spot Hitter (+20% headshot damage), keystone Ace Pitch (+1 Fastball pierce, +4% crit chance).
- **Control:** Changeup (+12% enemy slow on Curveball), Paint the Corners (+6% confuse chance), keystone Curve Control (+20% Curveball slow, +10% confuse chance).

## Debuff Crystals

- **Sore Shoulder** – -10% attack speed, +15% damage.
- **Wild Pitch** – +spread, +AOE on impact.

## Tips

- Plays as zone denial: hold chokepoints and keep enemies slowed before they reach you.
- Weak against armor-stacked elites; lean on pierce and team marks.
- Pairs well with Linebacker stuns and Quarterback summons that hold a line.
- Timing reference: [telegraphs/pitcher.md](../telegraphs/pitcher.md).

## Open Questions

- The skill tree (`design/skilltrees/pitcher_skilltree.mmd`) lists **Perfect Game** and **Knuckleball Mayhem** as capstones instead of Grand Slam Pitch. Grand Slam Pitch is used here because the GDD and the detail page agree on it.
- An earlier page had Curveball applying **Marked** (+15% team damage, 4s) instead of slow/confuse.
- The v1 draft also listed Resin Fuse, Smoke Screen, and a Perfect Release passive (+20% blast radius). See [_archive_v1/pitcher.md](_archive_v1/pitcher.md).

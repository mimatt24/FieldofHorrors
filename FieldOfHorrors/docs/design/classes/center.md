# Center

**Sport:** Basketball • **Role:** Zone control / AOE slams
**Movement:** SPD 5.9 • **HP:** 120 • **Grit Cap:** 30 • **Armor:** Medium

## Default Weapons

- **Primary: Dunk attacks** – slams and the Hook Shot short cone (stats TBD; no baseline in `design/weapon_balance.md` yet).
- **Secondary: Grapples** – grab-and-throw moves in place of a second weapon.

## Signature

- **Box Out** – knockback aura around the player (4.0s aura, 10s cooldown, about 120 units/s knockback tick).

## Skills (Early → Mid)

1. **Box Out I → II** – small knockback aura, then a larger radius with stronger knockback.
2. **Hook Shot I → Alley-Oop Grab** – short cone hit with minor stagger (4.5s cooldown), then pull enemies in and slam them (12s cooldown).
3. **Rebounder I → Paint Dominance** – chance to auto-pull nearby pickups, then damage reduction while stationary (8s, 18s cooldown).

## Capstone (≈6–7 min)

- **Slam of the Damned** – massive dunk AOE with a gore shockwave; elite-shatter tuned around a ~20% threshold (0.8s telegraph, 28s cooldown).

## Perks (passive nodes)

Full list in [detail/center.md](detail/center.md). Two branches:

- **Paint Control:** Paint Dominance (+12% DR while stationary), Hard Screen (+12% reflect chance), keystone Box Out (knockback aura +20% strength).
- **Slam:** Alley-Oop (pull on slam), Who's In The Paint? (+18% AOE damage), keystone Rebounder (+25% pickup magnet radius).

## Debuff Crystals

- **Heavy Shoes** – -8% move speed, +AOE damage.
- **Glass Knees** – -dodge i-frames, +block strength.

## Tips

- Pick a spot and own it: most of the kit rewards standing still.
- Keep slam wind-ups at 0.7s or longer so they stay readable.
- Timing reference: `design/classes/telegraphs/center.md`.

## Open Questions

- This class was briefly named **Power Forward**. Stats (SPD 5.9, HP 120, Grit 30, Medium armor) carry over from that page; the kit comes from the GDD's Center.
- The skill tree lists **Hard Screen** (reflect while standing still) as a second capstone.
- The v0.1 loadout in `game/classes.yaml` used a Board Crusher, DMR, Second Chance, and Putback. None of that is in the GDD.

# Quarterback (QB)

**Sport:** Football • **Role:** Summoner / field general
**Movement:** SPD 6.0 • **HP:** 100 • **Grit Cap:** 20 • **Armor:** Light

## Default Weapons

- **Primary: Precision Pass** – thrown ball, 16 dmg, 2.2/s, ~35 DPS, small AOE on final pierce (`design/weapon_balance.md`). Move timings in [weapons/spiral_disc.md](../weapons/spiral_disc.md).
- **Secondary: Command calls** – summons and tactical calls in place of a second weapon.

## Signature

- **Summons** – AI-controlled Linemen (shield, slow push, taunt) and Receivers (ranged support). See [skills/qb_summons.md](../skills/qb_summons.md).

## Skills (Early → Mid)

1. **Offensive Line I → II** – summon 1 Lineman, then +1 Lineman with a taunt pulse on spawn.
2. **Precision Pass I → II** – thrown ball pierces 1 target, then explodes on the last pierce (small AOE).
3. **Playbook I → Audible Call** – +10% summon HP and +5% player move speed, then swap Linemen to Receivers mid-fight (15s cooldown).

## Capstone (≈6–7 min)

- **Hail Mary** – timed push: +5 Receivers and +2 Linemen for 12s.

## Perks (passive nodes)

Full list in [detail/quarterback.md](detail/quarterback.md). Two branches:

- **Summons:** Anchor Block (+20% summon HP), Route Tree (+15% summon damage), keystone Offensive Line (+2 Linemen).
- **Passing Game:** Precision Pass (+15% pass AOE radius), Handoff (on-pass explosion), keystone Two-Minute Playbook (+8% team haste).

## Debuff Crystals

- **Selfish Captain** – -15% player damage, +20% summon damage.
- **Fatigue** – -10% stamina regen, +10% crit chance (summons and throws).

## Tips

- Use Linemen to body-block a lane, then throw over them.
- Summon Power scales with player count, so the class is not overpowered solo.
- Timing reference: [telegraphs/qb.md](../telegraphs/qb.md) (Spiral Pass, Hail Mary, Pump Fake).

## Open Questions

- Summon roster differs between docs: Linemen and Receivers (GDD, skill tree), Receiver/Fullback/Kicker (`skills/qb_summons.md`), Receiver/Lineman/Kicker (v1 draft). Linemen and Receivers are treated as the MVP set here.
- Hail Mary size differs: +3 Receivers in the skill tree, +5 in the GDD and detail page. +5 is used here.
- The skill tree lists **Two-Minute Drill** (+30% team attack/move speed burst) as a second capstone.
- The v0.1 loadout in `game/classes.yaml` used a Playbook Launcher, Sidearm, and Pep Talk. See [_archive_v1/qb.md](_archive_v1/qb.md).

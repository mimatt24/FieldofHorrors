# Field of Horrors — Godot project

This folder is the Godot 4 project. It currently holds the **Pitcher vertical
slice**: one class, one arena, one enemy type, one boss, one full run.

## Run it

1. Open Godot 4.3 or newer.
2. Choose **Import**, pick `FieldOfHorrors/game/project.godot`, then **Import & Edit**.
3. Press **F5**.

## Controls

| Action | Keyboard and mouse | Gamepad / Steam Deck |
| --- | --- | --- |
| Move | WASD or arrows | Left stick |
| Aim | Mouse | Right stick |
| Fastball | Left mouse (hold) | RT |
| Curveball | Right mouse (hold) | LT |
| Whistle Bomb | Hold Q or E to cook, release to throw | RB |
| Dash | Space or Shift | A |
| Grand Slam Pitch (capstone) | F | Y |
| Start / restart | Enter | A |
| Pause | Esc | Start |

## What is in the slice

- **Pitcher** with Fastball, Curveball, Whistle Bomb, a dash, and the Grand
  Slam Pitch capstone that unlocks at 6:00.
- **Zombie Fan** trash enemies on a rising spawn curve, with an elite about
  every 90 seconds.
- **Referee King** boss gate at 6:00, Phase 1 only (Stun Flag Toss and
  Whistle Shockwave).
- HUD laid out per `design/ui_hud.md`, win and loss screens, and a score.
- Placeholder art: everything is drawn as shapes in the design palette.

## Layout

- `data/tuning.json` — every gameplay number. Each block names the design
  doc it came from. Values listed under `_provisional` were not in the
  design docs and are starting guesses to tune in playtests.
- `scripts/` — one script per thing (`player.gd`, `enemy.gd`,
  `referee_king.gd`, `projectile.gd`, `whistle_bomb.gd`, `hud.gd`, `main.gd`).
- `scenes/main.tscn` — the only scene. Everything else is built in code.
- `tests/smoke_test.gd` — scripted playthrough used by CI.
- `classes.yaml` — class data for all six classes (design reference; the
  slice reads `data/tuning.json`).

## Automated check

```bash
godot --headless --path . -- --smoke-test
```

This plays a scripted run (shoot, kill, bomb, boss, win, lose) and prints
`SMOKE TEST PASSED`. GitHub runs the same check on every push that touches
this folder (`.github/workflows/godot-check.yml`).

## Not in the slice yet

- The other five classes, co-op, and meta progression.
- Referee King phases 2 and 3, adds, and arena hazards.
- Skill-tree choices, debuff crystals, loot, and crafting.
- Real art, audio, and the 2.5D camera (the slice is flat top-down).

# Stadium Tier 1 — Rookie Warmup
**Status:** draft  
**Owner:** design  
**Last-updated:** 2025-09-14

## Overview
Short, forgiving opener. Teach movement, spacing, and tells.

## Pacing Beats (0:00–4:00)
- 0:00–1:00: Light fodder, 1 hazard intro
- 1:00–2:30: Elite telegraph lesson
- 2:30–4:00: Mini-boss + safe window

## Hazards
- Whistle Bomb telegraph lane
- Strobe tunnel w/ safe tiles

## Win/Lose States
- Win: Clear mini-boss, 70% team HP+
- Lose: Team wipe or 3 fails on hazard

## Player Loadouts (Baseline Weapons)
- Pitcher: [Whistle Bomb](../weapons/whistle_bomb.md)
- Batter:  [Foam-Finger Pike](../weapons/foam_finger_pike.md)
- Linebacker: [Shoulder Ram](../weapons/shoulder_ram.md)

## Spawn Logic (sketch)
- Wave JSON sketch goes here (enemy id, count, interval)

## Telemetry Hooks
- death_event, hazard_fail, boss_clear_time

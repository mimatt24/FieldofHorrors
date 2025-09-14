# Field Of Horrors — Documentation Bundle


---
## design\_catalog\README.md

# FOH Design Catalog
This folder auto-lists and bundles all `.md`/`.mmd` into a single `ALL_DOCS.md`.
Upload just that one file to ChatGPT to bypass per-file limits.


---
## design\arena_cards\README.md

# Arena Cards Index
- T1: Rookie Warmup (baseline loadouts and movement lanes)


---
## design\arena_cards\stadium_t1_rookie_warmup.md

# Arena Challenge – Stadium T1: Rookie Warm-Up

**Metadata**
- Name: Stadium T1 – Rookie Warm-Up
- Tier: 1
- Biome: stadium
- Recommended Power: 1
- Rewards: 100 ⚾ Scrip, 1x Common Mod

**Objective**
- Primary: Clear all waves within **3:00**.
- Secondary (optional): Take **≤1** hit(s).
- Fail: Timer expires or team wipe.

**Modifiers**
- Global: Crowd Noise (minor telegraph audio dampening).
- Enemy: None (training match).
- Player: +10% stamina regen between waves.

**Wave Plan (summary)**
- Wave 1 (0:00): 2x Pitcher (fastball/curveball basics)
- Wave 2 (0:45): 1x Pitcher, 1x Batter (introduces melee spacing)
- Wave 3 (1:30): 2x Batter (power swing spacing test)

**Enemy Telegraph References**
- Pitcher: [../telegraphs/pitcher.md](../telegraphs/pitcher.md)
- Batter:  [../telegraphs/batter.md](../telegraphs/batter.md)

---

## Flow (Mermaid preview)

```mermaid
flowchart TD
  Start([Enter]) --> W1[Wave 1: 2x Pitcher]
  W1 -->|Clear| W2[Wave 2: 1x Pitcher + 1x Batter]
  W2 -->|Clear| W3[Wave 3: 2x Batter]
  W3 -->|Clear| Success([Success - Rewards])
  Start -. "Timer 3:00" .-> T[Timer]
  T -->|0:00| Fail([Fail])
  Start -. "Team wipe" .-> Fail



## Player Loadouts (Baseline Weapons)
- Pitcher: [Whistle Bomb](../weapons/whistle_bomb.md)
- Batter:  [Foam-Finger Pike](../weapons/foam_finger_pike.md)
- Linebacker: [Shoulder Ram](../weapons/shoulder_ram.md)
- Quarterback: [Spiral Disc](../weapons/spiral_disc.md)


---
## design\arena_cards\stadium_t1_rookie_warmup.mmd

%% Stadium T1 – Rookie Warm-Up (Flow)
flowchart TD
  Start([Enter Arena]) --> W1[Wave 1: 2× Pitcher]
  W1 -->|Clear| W2[Wave 2: 1× Pitcher + 1× Batter]
  W2 -->|Clear| W3[Wave 3: 2× Batter]
  W3 -->|Clear| Success([Success • Rewards])

  Start -. "Timer 3:00" .-> T[Timer]
  T -->|0:00| Fail([Fail])
  Start -. "Team wipe" .-> Fail


---
## design\arena_cards\template.md

# Arena Challenge – Template

**Metadata**
- Name: <challenge name>
- Tier: 1–5
- Biome: stadium | ice | court | street
- Recommended Power: <value>
- Rewards: <currency/items/perks>

**Objective**
- Primary: …
- Secondary (optional): …
- Fail: <timeout | wipe | objective break>

**Modifiers**
- Global: …
- Enemy: …
- Player: …

**Wave Plan (summary)**
- Wave 1: <composition, cadence>
- Wave 2: …
- Boss/Miniboss (if any): …

---

## Mermaid – Flow (authoring example)
```mermaid
flowchart TD
  Start([Enter]) --> W1[Wave 1]
  W1 -->|Clear| W2[Wave 2]
  W2 -->|Clear| Boss{Boss?}
  Boss -->|No| Success([Success])
  Boss -->|Yes| WB[Boss Wave] --> Success
  Start -. Fail condition .-> Fail([Fail])



---
## design\classes\batter.md

# Batter
**Role:** Bruiser/Breaker  
**Movement:** SPD 5.8 • **HP:** 125 • **Grit Cap:** 35 • **Armor:** Medium

## Default Weapons
- Primary: (see weapons/)
- Secondary: (see weapons/ or gadget)

## Signature
- Power Swing – cone hit, Knockdown on armored/marked

## Skills
1. (Skill A) – …
2. (Skill B) – …
3. (Ultimate) – …

## Perks (early picks)
- Node A: …
- Node B: …
- Node C: …

## Tips
- …


---
## design\classes\linebacker.md

# Linebacker
**Role:** Vanguard/Protector  
**Movement:** SPD 5.7 • **HP:** 140 • **Grit Cap:** 45 • **Armor:** Heavy

## Default Weapons
- Primary: (see weapons/)
- Secondary: (see weapons/ or gadget)

## Signature
- Goal Line Stand – team Grit regen aura, -10% dmg taken

## Skills
1. (Skill A) – …
2. (Skill B) – …
3. (Ultimate) – …

## Perks (early picks)
- Node A: …
- Node B: …
- Node C: …

## Tips
- …


---
## design\classes\pitcher.md

# Pitcher
**Role:** Skirmisher/Controller  
**Movement:** SPD 6.1 • **HP:** 100 • **Grit Cap:** 25 • **Armor:** Light

## Default Weapons
- Primary: (see weapons/)
- Secondary: (see weapons/ or gadget)

## Signature
- Curveball – arced throw that Marks targets (+15% team dmg, 4s)

## Skills
1. (Skill A) – …
2. (Skill B) – …
3. (Ultimate) – …

## Perks (early picks)
- Node A: …
- Node B: …
- Node C: …

## Tips
- …


---
## design\classes\point_guard.md

# Point Guard
**Role:** Support/Tempo  
**Movement:** SPD 6.2 • **HP:** 95 • **Grit Cap:** 20 • **Armor:** Light

## Default Weapons
- Primary: (see weapons/)
- Secondary: (see weapons/ or gadget)

## Signature
- Pick & Roll – ally tether: +move/reload/throw speed

## Skills
1. (Skill A) – …
2. (Skill B) – …
3. (Ultimate) – …

## Perks (early picks)
- Node A: …
- Node B: …
- Node C: …

## Tips
- …


---
## design\classes\power_forward.md

# Power Forward
**Role:** AOE/Zone Control  
**Movement:** SPD 5.9 • **HP:** 120 • **Grit Cap:** 30 • **Armor:** Medium

## Default Weapons
- Primary: (see weapons/)
- Secondary: (see weapons/ or gadget)

## Signature
- Box Out – ring slow; -20% enemy melee inside

## Skills
1. (Skill A) – …
2. (Skill B) – …
3. (Ultimate) – …

## Perks (early picks)
- Node A: …
- Node B: …
- Node C: …

## Tips
- …


---
## design\classes\qb.md

# QB
**Role:** Summoner/Field General  
**Movement:** SPD 6.0 • **HP:** 100 • **Grit Cap:** 20 • **Armor:** Light

## Default Weapons
- Primary: (see weapons/)
- Secondary: (see weapons/ or gadget)

## Signature
- Audible – swap summons (Receiver/Fullback/Kicker)

## Skills
1. (Skill A) – …
2. (Skill B) – …
3. (Ultimate) – …

## Perks (early picks)
- Node A: …
- Node B: …
- Node C: …

## Tips
- …


---
## design\open_threads.md

# Open Threads

- Telegraph tables
- Arena Challenge templates
- Expanded weapon trees
- Wave presets
- Co-op synergy


---
## design\overview.mmd

%% Field of Horrors – Design Overview (auto-generated)
flowchart TD
A["docs/design"]
DG["telegraphs"]
AC["arena_cards"]
W["weapons"]
CA["chat_archive.md TODO"]
OT["open_threads.md ✅"]
DGM["diagrams (CI artifacts)"]
A --> DG
A --> AC
A --> W
A --> CA
A --> OT
A -. rendered by CI .-> DGM
subgraph CLASSES["Classes"]
  C_P["Pitcher"]
  C_B["Batter"]
  C_L["Linebacker"]
  C_Q["Quarterback"]
end
subgraph TSG["telegraphs"]
  T_pitcher_md["pitcher.md ✅"]
  T_batter_md["batter.md ✅"]
  T_linebacker_md["linebacker.md ✅"]
  T_qb_md["qb.md ✅"]
  T_README_md["README.md ✅"]
end
subgraph ACG["arena_cards"]
  A_template_md["template.md ✅"]
  A_stadium_t1_rookie_warmup_md["stadium_t1_rookie_warmup.md ✅"]
  A_stadium_t1_rookie_warmup_mmd["stadium_t1_rookie_warmup.mmd ✅"]
end
subgraph WG["weapons"]
  W_whistle_bomb_mmd["whistle_bomb.mmd ✅"]
  W_foam_finger_pike_mmd["foam_finger_pike.mmd ✅"]
  W_shoulder_ram_mmd["shoulder_ram.mmd TODO"]
  W_spiral_disc_mmd["spiral_disc.mmd TODO"]
  WS_whistle_bomb_md["whistle_bomb.md ✅"]
  WS_foam_finger_pike_md["foam_finger_pike.md ✅"]
  WS_shoulder_ram_md["shoulder_ram.md ✅"]
  WS_spiral_disc_md["spiral_disc.md ✅"]
end
C_P --> W_whistle_bomb_mmd
C_B --> W_foam_finger_pike_mmd
C_L --> W_shoulder_ram_mmd
C_Q --> W_spiral_disc_mmd
W_whistle_bomb_mmd --> A_stadium_t1_rookie_warmup_md
W_foam_finger_pike_mmd --> A_stadium_t1_rookie_warmup_md
W_shoulder_ram_mmd --> A_stadium_t1_rookie_warmup_md
W_spiral_disc_mmd --> A_stadium_t1_rookie_warmup_md
ST1SVG["stadium_t1_rookie_warmup.svg"]
WBSVG["whistle_bomb.svg"]
FPSVG["foam_finger_pike.svg"]
DGM --> ST1SVG
DGM --> WBSVG
DGM --> FPSVG


---
## design\skills\qb_summons.md

# QB Summons
- Receiver: Ranged support
- Fullback: Taunt melee
- Kicker: Slow mines (area denial)


---
## design\systems\combat_overview.md

# Combat Overview
- TTK target: quick on-ramp → avg 1.5–2.0s at higher difficulty
- Resources: Stamina (move), Focus (skills), Grit (temp soak)
- Armor: Light/Medium/Heavy; Damage: Kinetic/Explosive/Utility
- Status: Stagger/Daze/Knockdown/Bleed/Slow/Marked
- Headshot 1.75x, weak-point 1.5x (ranged); thrown 1.25x
- Movement baseline SPD 6.0; role deltas ±0.5


---
## design\telegraphs\README.md

# Telegraph Tables – Schema

**Columns (required):**
| move | startup | active | recovery | cooldown | range | tells | damage | stagger | counterplay | variations | notes |
|------|---------|--------|----------|----------|-------|-------|--------|---------|-------------|------------|-------|

**Timing units:** frames (f) or seconds (s). Pick one per table and stick to it.  
**Ranges:** tiles or meters; be consistent within a table.  
**Tells:** animations, SFX, VFX, windups.  
**Counterplay:** dodge windows, parry timings, interrupts, terrain use.  
**Variations:** elite/boss modifiers, status, elemental, “on enraged,” etc.


---
## design\telegraphs\batter.md

# BATTER – Telegraphs (frames)

| move | startup | active | recovery | cooldown | range | tells | damage | stagger | counterplay | variations | notes |
|------|---------|--------|----------|----------|-------|-------|--------|---------|-------------|------------|-------|
| Bunt Jab | 12f | 2f | 16f | 20f | 1 tile | Bat lift to chest | Low | Low | Micro-sidestep; free punish 14–20f | Double jab chain | Used to check space |
| Power Swing | 30f | 6f | 28f | 36f | 2 tiles arc | Full windup; grunt | High | High | Roll through hips at 28–32f | Charged variant (wider arc) | Breaks guard |
| Pop-Fly Uppercut | 22f | 4f | 24f | 28f | 1 tile vertical | Knees bend; elbow flare | Med | Med | Jump cancel; parry early | Launcher (juggles) | Anti-air punish tool |


---
## design\telegraphs\linebacker.md

# LINEBACKER – Telegraphs (frames)

| move | startup | active | recovery | cooldown | range | tells | damage | stagger | counterplay | variations | notes |
|------|---------|--------|----------|----------|-------|-------|--------|---------|-------------|------------|-------|
| Bull Rush | 20f | 14f | 26f | 34f | 6 tiles line | Snort; shoulder dip | Med | High | Side-dodge on windup; trip hazard counters | Frenzy (longer active) | Collides with walls |
| Tackle | 24f | 8f | 22f | 30f | 2 tiles | Hip rotate; stomp | High | High | Jump back; bait into trap | Stun on hit | Armor during startup |
| Guard Breaker | 18f | 3f | 18f | 26f | 1 tile | Hand open, then fist | Low | High | Parry 2f pre-active; counterthrow | Shield-only bonus | Opens ripostes |


---
## design\telegraphs\pitcher.md

# PITCHER – Telegraphs (frames)

| move | startup | active | recovery | cooldown | range | tells | damage | stagger | counterplay | variations | notes |
|------|---------|--------|----------|----------|-------|-------|--------|---------|-------------|------------|-------|
| Fastball | 18f | 4f | 22f | 30f | 10 tiles line | Shoulder cocks back; glove tap | Med | Low | Sidestep at 18–22f; shield blocks | Curveball (homes lightly) | Rolls if hits wall |
| Curveball | 22f | 6f | 24f | 32f | 8 tiles arc | Wrist twist; ball glow pulse | Med | Med | Move inward on apex; jump over inner arc | Slippery turf: +2 tiles | Punishes greedy melee |
| Change-up | 26f | 4f | 18f | 28f | 10 tiles line (slow) | Long exhale; slower arm | Low | Low | Walk dodge; counterthrow window 24–30f | Fake windup (rare) | Baits early dodge |


---
## design\telegraphs\qb.md

# QB – Telegraphs (frames)

| move | startup | active | recovery | cooldown | range | tells | damage | stagger | counterplay | variations | notes |
|------|---------|--------|----------|----------|-------|-------|--------|---------|-------------|------------|-------|
| Spiral Pass | 16f | 3f | 18f | 26f | 12 tiles line | Finger lace spin; wrist snap | Med | Low | Step off-line 14–18f | Homing (light) | Can tag allies |
| Hail Mary | 36f | 8f | 30f | 40f | 16 tiles arc | Deep lean back | High | Med | Close distance during windup; interrupt | Multi-ball spread | Arena hazard synergy |
| Pump Fake | 10f | 0f | 8f | 12f | — | Quick shoulder twitch | — | — | Hold dodge; punish recovery | Into Spiral Pass | Baits parry windows |


---
## design\weapons\foam_finger_pike.md

# Foam-Finger Pike
Type: Melee (Pierce) • Reach: Long • Multi-hit line
Synergy: Batter burst lanes; Power Forward zones


---
## design\weapons\foam_finger_pike.mmd

%% Foam-Finger Pike – Upgrade Tree
flowchart TD
  FP0["Foam-Finger Pike (Base)"] --> FP1A["Tier1: Lunge Booster (+range)"]
  FP0 --> FP1B["Tier1: Guard Point (startup armor)"]

  FP1A --> FP2A["Tier2: Spear Wall (multi-hit line)"]
  FP1A --> FP2B["Tier2: Pivot Stab (instant turn)"]

  FP1B --> FP2C["Tier2: Riposte Window (parry → bonus)"]
  FP1B --> FP2D["Tier2: Brace (reduced knockback)"]

  %% Tier 3 caps
  FP2A --> FP3A["Tier3: Phalanx (ally aura)"]
  FP2B --> FP3B["Tier3: Whirl (short arc sweep)"]
  FP2C --> FP3C["Tier3: Perfect Counter (auto-crit)"]
  FP2D --> FP3D["Tier3: Iron Line (party guard)"]


---
## design\weapons\shoulder_ram.md

# Shoulder Ram
Type: Charge • Stagger: High • Cooldown: 10s
Synergy: Linebacker engage/peel, converts damage to team Grit (ult)


---
## design\weapons\spiral_disc.md

# SPIRAL DISC — Base Stats (frames, tiles)

| move | startup | active | recovery | cooldown | range | tells | damage | stagger | counterplay | variations | notes |
|------|---------|--------|----------|----------|-------|-------|--------|---------|-------------|------------|-------|
| Straight Pass | 12f | 3f (on contact) | 14f | 22f | 8 tiles line | Wrist snap; finger lace spin | Med | Low | Step off-line 10–14f; shield blocks | N/A | Slight aim magnet to center-mass |
| Pump → Pass | 10f (fake) + 12f | 3f | 16f | 24f | 8 tiles line | Shoulder twitch (fake) then full release | Med | Low | Hold dodge on fake; punish recovery | N/A | Fake does not fire; teaches patience |


---
## design\weapons\whistle_bomb.md

# Whistle Bomb
Type: Thrown Explosive • Radius: Small • Stagger: High • Fuse: 1.2s
Synergy: Pitcher (Mark setups), Batter (ignite Pine Tar lanes)


---
## design\weapons\whistle_bomb.mmd

%% Whistle Bomb – Upgrade Tree
flowchart TD
  WB0["Whistle Bomb (Base)"] --> WB1A["Tier1: Sticky Fuse (+DoT)"]
  WB0 --> WB1B["Tier1: Quick Whistle (-startup)"]

  WB1A --> WB2A["Tier2: Cluster Pop (split on hit)"]
  WB1A --> WB2B["Tier2: Siren Pitch (fear on near-miss)"]

  WB1B --> WB2C["Tier2: Curve Throw (manual curve)"]
  WB1B --> WB2D["Tier2: Silent Fuse (no tell)"]

  %% Tier 3 caps (choose one)
  WB2A --> WB3A["Tier3: Grand Slam (large AoE, longer cooldown)"]
  WB2B --> WB3B["Tier3: Panic Chain (fear spreads)"]
  WB2C --> WB3C["Tier3: Perfect Spiral (pierce)"]
  WB2D --> WB3D["Tier3: Ghost Fuse (invisible arc, lower damage)"]


---
## weekly_report_template.md

# Field of Horrors – Weekly Report
**Week of:** {{DATE}}

## Highlights
- Combat: ...
- Classes: ...
- Art/Music: ...

## Diagrams Updated
- flow.png
- systems.png

## Next Week Goals
- ...

## Risks / Needs
- ...


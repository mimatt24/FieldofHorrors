# Field of Horrors – Chat Archive (Master Reference)

This archive captures **all design work, prompts, decisions, and setup steps** so development can continue without losing context. Treat this as the **single source of truth** for the project. Pair it with the raw logs in `history/raw_logs/` when you need verbatim details.

---

## 0) Project Identity

**Title:** Field of Horrors  
**Genre:** Roguelite / action-ARPG hybrid (5–10 min runs)  
**Tone:** Gore with comedy  
**Visuals:** 2.5D – 3D characters on a 2D plane; cel-shaded, Borderlands-style lines + kitbashed realism  
**Target platform:** Steam (incl. Steam Deck) @ 60 FPS 1080p (Deck: 800p/60)  
**Monetization:** $8 at 1.0; Steam Playtest pre-alpha  
**IP Policy:** Use fictional analogs; unique colors/logos. Flag any risk and swap assets when needed.

---

## 1) Core Fantasy & Elevator Pitch

> In a world where sports heroes fight **zombie fans**, you craft and command sports-themed weapons and squads from your underground base. Survive short, intense runs; face bosses; and climb seasonal leaderboards. Will you save the Field of Horrors?

- “Brag line” after a run: **“Play Action. Play Ball. Zombie Fans destroyed.” / “I orchestrated chaos with sports-crafted weapons.”**
- Gore/comedy blend; readable carnage; chunky hit feedback.

---

## 2) Player Classes (Base)

Each sport has **two subclasses**, hard-counter specialties (à la PoE Ascendancies). Branching “skill crystals,” deterministic debuffs.

### Baseball
- **Pitcher (Ranger):** Fastballs/curveballs, pierce/arc, crits at range.  
- **Batter (Melee/Scout):** Timed swing crits, wide arcs, mobility cancels.

### Football
- **Linebacker (Tank/Control):** Bash/taunt, DR, knockdowns.  
- **Quarterback (Summoner/Tactical):** Spawns **linemen** (shield push) and **receivers** (rush/damage); throws with AOE on final pierce.

### Basketball
- **Point Guard (Mobility/Support):** Dashes, buffs, no-look passes, team haste windows.  
- **Center (Space Control/Slams):** Box-out aura, grabs, dunk AOEs, reflect when stationary.

> **Ultimates:** You prefer not to use “traditional ultimates”; instead, **capstones** act as stage-clearing moments (e.g., “Hail Mary”). We keep them as skill-tree capstones rather than separate ult buttons.

**Cosmetics:** Jerseys/gear evolve from bloody → glowing → championship tier; prestige skins at max rank.

---

## 3) Skill Trees (Mermaid, deterministic)

- Branching tiers: **Early → Mid → Capstone** (with optional **Debuff Crystals**).
- Implemented Mermaid trees (auto-render to PNG via CI):
  - `design/skilltrees/`  
    - `batter_skilltree.mmd`  
    - `pitcher_skilltree.mmd` (labels quoted; “%” written as “pct”)  
    - `linebacker_skilltree.mmd`  
    - `qb_skilltree.mmd` (quoted labels fix)  
    - `point_guard_skilltree.mmd` (quoted labels + one-edge-per-line fix)  
    - `center_skilltree.mmd`

**Style rules for Mermaid (important):**
- Quote all labels: `["text"]` and `{{"text"}}`.
- Replace `%` with **`pct`** OR keep `%` only inside quotes.
- **One statement per line** (no “define + edge” on same line).

---

## 4) Enemies

**Baseline:** Zombie Fans. **Variations** are **mechanical** (not only cosmetic) and use your **locked 10-color palette** plus **one wild-card** highlight each.

- **Foam Finger Zombie** – oversized finger; heavy slap/knockback.  
- **Mascot Mask Zombie** – cracked heads; erratic charges.  
- **Referee Zombie** – throws stun flags; slows/immobilizes.  
- **Tailgate Bruiser** – bottle AOE; grapples.  
- **Streaker Zombie** – blazing rushdown.  
- **Cheerleader Zombie** – confusion/reversed controls.  
- **Ultra Fan Zombie** – tanky brawler.  
- **Merch Seller Zombie** – T-shirt cannon/merch bombs.

**Elites (modifiers):** (max 2 simultaneous)  
Overtime, Thick Skin, Explosive, Fanatic, Conductor, Flagbearer, T-Shirt Cannon, Mascot Shell.  
- Clear telegraphs; visible **before** they matter.

**Spawn Curves (5–10 min runs):**  
- **Curve A (Default):** Linear ramp + elite pulses (every 90s; 1 mod early, 2 mods later).  
- **Curve B (Wavey):** 90s spike + 15s relief windows.  
- **Curve C (Hazard-Driven):** Steady spawns; hazards escalate.

---

## 5) Boss – Referee King

**Phases:**  
- **P1 – Flag Control:** Stun Flags, Whistle Shockwave, Penalty Line; Ballboy adds.  
- **P2 – Rulebook Rage:** Yellow Card Rain, Holding tethers, Replay Review (brief invuln), Ump DR auras.  
- **P3 – Overtime Judgment:** Two-Minute Drill (haste), Double Flag, Ejection (tele-slam), soft enrage.

**Telegraphs (MVP timings):** Stun Flag 0.6s tell; Shockwave 0.75s; Penalty Line 0.9s; Card Rain 1.2s; Replay Review invuln ≤ 1.5–2.0s; Two-Minute Drill 0.8s cast; Ejection 0.7s.

**Rewards:** Ref’s Golden Whistle (on-hit micro-stun CD), Championship Gem Shard (Batblade recipe), striped glow jersey, penalty trail VFX.

**Diagrams:**  
- `design/bosses/referee_king_phases.mmd` → auto PNG.

---

## 6) Weapons & Crafting (Deterministic Trees)

**Crafting:** Base-camp only; deterministic recipes (no RNG needed).  
**Families:** Batblade, Foam-Finger Pike, Mascot Maul, Whistle Bomb, Goalpost Boomerang, Bloodied Bat+Ball.

**Mermaid trees:**  
- `design/weapon_trees/foam_finger_pike.mmd`  
- `design/weapon_trees/whistle_bomb_tree.mmd`  
- `design/weapon_trees/goalpost_boomerang.mmd`  
- `design/weapon_trees/mascot_maul_tree.mmd`

**Balance (MVP baselines):**
- Melee > Ranged DPS baseline (risk premium).
- Capstones ~20–30% above tier-3 DPS, gated by mechanics.

---

## 7) Stages & Hazards

**Themes (examples):** Graveyard Gridiron, Diamond of Dread, Rink of Ruin, Court of Carnage, parking lots, streets.

**Hazards Catalog:**  
Firework Barrage, Bleacher Collapse, Spotlight Sweep, Tailgate Flames, Black Ice, Zamboni Cross, Loose Hoops, Shot Clock Alarm, Car Alarms, Lamp Flicker.  
**Arena Mods:** Double Hazards, No Dash Zone, Elite Frenzy.  
**Tuning:** Telegraph ≥ 0.9s; cadence 8–15s; hazards punish positioning more than raw HP.

---

## 8) Base of Operations

**Rooms (MVP):** Crafting, Training Center, War Table, Archive, Locker Room.  
**Look:** Overt sports theming; underground fluorescent vibe (not blood-red battle lighting).  
**Concepts created:** Wide cinematic cutaway + schematic overlay.  
**Pacing:** Upgrades between runs; keep cadence meaningful (one unlock per 2–3 sessions).

---

## 9) Modes, Flow, Leaderboards

**MVP Modes:**  
- **Survival (Default):** 5–10 min; optional boss gate ~9–10 min.  
- **Arena Challenges:** 3–5 waves + hazards; daily/weekly seeded challenges.

**Run Flow:**  
Main Menu → Class/Subclass → Mode → Run → Boss Gate → Boss → Rewards/Crafting → Base Upgrades → Ascension check → Leaderboard submission → Season rollover.  
- Mermaid: `design/flow.mmd` (syntax fixed: one edge per line, quoted labels).

**Leaderboards (“ScoreBoard”):**  
- Metrics: kills, elites/bosses, time bonus, style bonus (combo, no-hit), hazard bonus.  
- Boards: per parent class, plus Hardcore Solo Self-Found & Hardcore Co-op.  
- Daily/Weekly challenges + **6-month Seasons** (optional reset to L1).  
- Carryover on season reset: **cosmetics only**; power resets per prestige rules.  
- Steam achievements: base progress + season participation/placement.

---

## 10) Ascension (“National Championship”)

**Trigger:** Beat end boss.  
**Prestige:** Resets most power; gains **Hall of Fame Points** (meta boosts).  
**Seasons:** Every 6 months; optional reset to L1; cosmetics carry.  
**Multi-Talented (post-ascension):** Limited **dual-class** fusions (e.g., QB + Pitcher) with unique abilities; enemies may gain fusion traits later for difficulty.  
**Cosmetics:** Unique glowing jerseys, banners, weapon evolutions (Batblade → Championship Bat).

---

## 11) UI/HUD & Accessibility

**HUD:** Big fonts, high contrast, thick outlines; Deck-friendly.  
- Top-left: HP + class + stamina.  
- Top-right: timer, wave/boss, hazard queue.  
- Bottom-left: weapon + ammo/stamina; combo meter.  
- Bottom-right: event mini-log.  
- Center: damage popups (toggle), hit flashes, status icons.

**Color-blind safety:** Do not rely on hue; use shape/pattern + icon. Presets for Deuter/Protan/Tritan; custom saturation slider.

**Options:** Damage numbers: none/min/full; motion sliders; audio ducking; font size Large/XL/XXL; big focus states.

---

## 12) Art Direction & Palette

**Locked 10-color palette** (wild-card per asset allowed).  
All concept art (weapons, characters, base) adheres to palette.  
- Concept pieces created:  
  - Bloodied wooden **baseball bat + ball**  
  - **QB vs. Zombies** battle scene (cel-shaded; tweaks: sky red, QB purple/black, zombie jerseys lightened)  
  - **Base of Operations** (brightened version + schematic)  
  - **Regular zombie** variations and accessories

> Rule: Any suggestion to add a new color requires your approval; display a swatch sample before adding to the standard palette.

---

## 13) Repo, Tooling, and CI

**Repo:** `mimatt24/FieldofHorrors`  
**Local stack:** Git Bash + VS Code + GitHub Desktop optional.  
**SSH:** ed25519 key configured; remote set to `origin`.  
**Folder structure:**  
- `design/` (markdown specs, Mermaid diagrams)  
- `art/` (concepts; `autogen/` for CI outputs)  
- `docs/` (general docs; PDFs dropped due to friction)  
- `history/` (digest + raw logs)  
- `tools/` (helper scripts)

**CI (Mermaid-only, stable):**  
- Triggers on `design/**/*.mmd` and workflow changes.  
- Renders to `art/autogen/*.png`, uploads artifact, and **auto-commits** PNGs.  
- PDFs: attempted via Pandoc + wkhtmltopdf → **removed** to reduce friction.

**Known Mermaid fixes:**  
- Quote all labels.  
- Replace `%` with `pct` or keep `%` inside quotes.  
- One statement per line.

---

## 14) Raw Logs & Knowledge Portability

- **Digest:** This file (curated summary).  
- **Raw logs:** `history/raw_logs/` (verbatim USER/ASSISTANT).  
  - Template & README included; helper: `tools/add_log.sh`.  
  - First log: `history/raw_logs/session_2025-09-13.md`.

**How to use in new chats:**  
> “Load the design archive:  
> https://github.com/mimatt24/FieldofHorrors/blob/main/FieldOfHorrors/history/chat_archive.md  
> Use it as context and refer to `history/raw_logs/` for verbatim details.”

---

## 15) Open Threads / Next Tasks

- Add telegraph tables for **Pitcher, Batter, Linebacker, QB**.  
- Add Arena Challenge card templates (Mermaid + authoring guide).  
- Expand deterministic weapon trees: **Whistle Bomb** tiers, **Foam-Finger Pike** variants.  
- Enemy wave presets per **stage theme** (stadium/ice/court/street).  
- Co-op synergy rules post-ascension.

---

## Raw Logs Index
- [Session 2025-09-13 (verbatim log)](history/raw_logs/session_2025-09-13.md)
- See **history/raw_logs/** for all verbatim sessions going forward.

# Usage
- Reference this file when starting any **new ChatGPT project window**:
  > “This is my design archive: https://github.com/mimatt24/FieldofHorrors/blob/main/FieldOfHorrors/history/chat_archive.md. Load this and continue development from here.”

---

## Changelog Index
- See **history/changelog/** for dated, detailed daily logs.
- Latest: [2025-09-13](history/changelog/2025-09-13.md)

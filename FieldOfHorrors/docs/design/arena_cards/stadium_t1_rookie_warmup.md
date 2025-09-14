# Arena Challenge – Stadium T1: Rookie Warm-Up

**Metadata**
- Name: Stadium T1 – Rookie Warm-Up
- Tier: 1
- Biome: stadium
- Recommended Power: 1
- Rewards: 100 ⚾ Scrip, 1x Common Mod

**Objective**
- Primary: Clear all waves within **3:00**.
- Secondary: Take **≤1** hit(s).
- Fail: Timer expires or team wipe.

**Modifiers**
- Global: Crowd Noise (+5% per cleared wave)
- Enemy: None (training match)
- Player: +10% stamina regen between waves; 0.4s slow-mo on first incoming projectile

**Wave Plan (summary)**
- Wave 1 (0:00): 2× Pitcher (desynced throws; opposite corners)
- Wave 2 (0:45): 1× Pitcher + 1× Batter (Batter spawns closer)
- Wave 3 (1:30): 2× Batter (Bunt Jab opener → Power Swing teach)

**Onboarding Beats**
- Entry tip: “Watch windup; dodge during release.”
- First Batter windup: ground arc outline 6f early; tip if hit twice: “Roll through hips.”

**Safeguards**
- Single Power Swing active at a time (W3).
- Safe spawn radius (≥3 tiles from player/enemies).
- Projectiles auto-despawn at 2s or on wall.
- 20% stamina restored during 3–4s inter-wave buffer.

**Enemy Telegraph References**
- Pitcher: [../telegraphs/pitcher.md](../telegraphs/pitcher.md)
- Batter:  [../telegraphs/batter.md](../telegraphs/batter.md)

## Flow (Mermaid preview)
```mermaid
flowchart TD
  Start([Enter]) --> W1[Wave 1\n2× Pitcher]
  W1 -->|Clear| W2[Wave 2\n1× Pitcher + 1× Batter]
  W2 -->|Clear| W3[Wave 3\n2× Batter]
  W3 -->|Clear| Success([Success\nRewards])
  Start -. "Timer 3:00" .-> T[Timer]
  T -->|0:00| Fail([Fail])
  Start -. "Team wipe" .-> Fail


## 2) (Optional) Tighter Mermaid card (labels ≤ ASCII to avoid fonts/encoding hiccups)
```bash
cat > docs/design/arena_cards/stadium_t1_rookie_warmup.mmd <<'EOF'
%% Stadium T1 - Rookie Warm-Up (Flow)
flowchart TD
  Start([Enter Arena]) --> W1[Wave 1: 2x Pitcher]
  W1 -->|Clear| W2[Wave 2: 1x Pitcher + 1x Batter]
  W2 -->|Clear| W3[Wave 3: 2x Batter]
  W3 -->|Clear| Success([Success - Rewards])
  Start -. "Timer 3:00" .-> T[Timer]
  T -->|0:00| Fail([Fail])
  Start -. "Team wipe" .-> Fail

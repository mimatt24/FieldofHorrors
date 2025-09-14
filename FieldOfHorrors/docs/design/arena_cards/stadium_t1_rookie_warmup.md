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
  Start([Enter]) --> W1[Wave 1\n2x Pitcher]
  W1 -->|Clear| W2[Wave 2\n1x Pitcher + 1x Batter]
  W2 -->|Clear| W3[Wave 3\n2x Batter]
  W3 -->|Clear| Success([Success\nRewards])
  Start -. "Timer 3:00" .-> T[Timer]
  T -->|0:00| Fail([Fail])
  Start -. "Team wipe" .-> Fail


# 2) (Optional) keep the separate Mermaid file very ASCII-safe
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

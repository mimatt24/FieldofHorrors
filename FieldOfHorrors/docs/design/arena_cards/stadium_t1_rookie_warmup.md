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
- Wave 1 (0:00): 2× Pitcher (fastball/curveball basics)
- Wave 2 (0:45): 1× Pitcher, 1× Batter (introduces melee spacing)
- Wave 3 (1:30): 2× Batter (power swing spacing test)

**Enemy Telegraph References**
- Pitcher: [docs/design/telegraphs/pitcher.md](../telegraphs/pitcher.md)
- Batter:  [docs/design/telegraphs/batter.md](../telegraphs/batter.md)

---

## Flow (Mermaid preview)
```mermaid
flowchart TD
  Start([Enter Arena]) --> W1[Wave 1\n2× Pitcher]
  W1 -->|Clear| W2[Wave 2\n1× Pitcher + 1× Batter]
  W2 -->|Clear| W3[Wave 3\n2× Batter]
  W3 -->|Clear| Success([Success\nRewards Payout])
  Start -. "Timer 3:00" .-> T[Timer]
  T -->|0:00| Fail([Fail])
  Start -. "Team wipe" .-> Fail


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


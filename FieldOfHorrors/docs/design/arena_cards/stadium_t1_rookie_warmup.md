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


# 2) Replace the overview generator with a bulletproof version
This avoids slashes/parentheses in labels, prints one statement per line, and has a correct `if __name__ == "__main__"` block.

```bash
cat > tools/gen_overview_mermaid.py <<'EOF'
#!/usr/bin/env python3
import pathlib

ROOT   = pathlib.Path(__file__).resolve().parents[1]
DESIGN = ROOT / "docs" / "design"
OUT    = DESIGN / "overview.mmd"

def ok(p): return "✅" if p.exists() else "TODO"

def main():
    tele = DESIGN / "telegraphs"
    arena = DESIGN / "arena_cards"
    weap = DESIGN / "weapons"

    lines = []
    lines.append("%% Field of Horrors – Design Overview (auto-generated)")
    lines.append("flowchart TD")
    # Top-level nodes
    lines.append('A["docs/design"]')
    lines.append('DG["telegraphs"]')
    lines.append('AC["arena_cards"]')
    lines.append('W["weapons"]')
    lines.append(f'CA["chat_archive.md {ok(DESIGN / "chat_archive.md")}"]')
    lines.append(f'OT["open_threads.md {ok(DESIGN / "open_threads.md")}"]')
    lines.append('DGM["diagrams (CI artifacts)"]')
    # Edges
    lines.append("A --> DG")
    lines.append("A --> AC")
    lines.append("A --> W")
    lines.append("A --> CA")
    lines.append("A --> OT")
    lines.append("A -. rendered by CI .-> DGM")
    # TELEGRAPHS
    lines.append('subgraph TSG["telegraphs"]')
    for name in ["pitcher.md","batter.md","linebacker.md","qb.md","README.md"]:
        nid = "T_" + name.replace(".","_")
        lines.append(f'  {nid}["{name} {ok(tele / name)}"]')
    lines.append("end")
    # ARENA CARDS
    lines.append('subgraph ACG["arena_cards"]')
    for name in ["template.md","stadium_t1_rookie_warmup.md","stadium_t1_rookie_warmup.mmd"]:
        nid = "A_" + name.replace(".","_")
        lines.append(f'  {nid}["{name} {ok(arena / name)}"]')
    lines.append("end")
    # WEAPONS
    lines.append('subgraph WG["weapons"]')
    for name in ["whistle_bomb.mmd","foam_finger_pike.mmd"]:
        nid = "W_" + name.replace(".","_")
        lines.append(f'  {nid}["{name} {ok(weap / name)}"]')
    lines.append("end")
    # Rendered outputs
    lines.append('ST1SVG["stadium_t1_rookie_warmup.svg"]')
    lines.append('WBSVG["whistle_bomb.svg"]')
    lines.append('FPSVG["foam_finger_pike.svg"]')
    lines.append("DGM --> ST1SVG")
    lines.append("DGM --> WBSVG")
    lines.append("DGM --> FPSVG")

    OUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Wrote {OUT}")

if __name__ == "__main__":
    main()

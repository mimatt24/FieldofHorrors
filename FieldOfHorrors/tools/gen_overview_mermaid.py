#!/usr/bin/env python3
import pathlib

ROOT   = pathlib.Path(__file__).resolve().parents[1]
DESIGN = ROOT / "docs" / "design"
OUT    = DESIGN / "overview.mmd"

def ok(p): return "✅" if p.exists() else "TODO"
def nid(prefix, name): return f"{prefix}_" + name.replace(".", "_").replace("-", "_")

def main():
    tele = DESIGN / "telegraphs"
    arena = DESIGN / "arena_cards"
    weap = DESIGN / "weapons"

    # File names we care about explicitly
    tele_files  = ["pitcher.md","batter.md","linebacker.md","qb.md","README.md"]
    arena_files = ["template.md","stadium_t1_rookie_warmup.md","stadium_t1_rookie_warmup.mmd"]
    weapon_files= ["whistle_bomb.mmd","foam_finger_pike.mmd","shoulder_ram.mmd","spiral_disc.mmd"]

    lines = []
    lines.append("%% Field of Horrors – Design Overview (auto-generated)")
    lines.append("flowchart TD")

    # --- Top-level nodes
    lines.append('A["docs/design"]')
    lines.append('DG["telegraphs"]')
    lines.append('AC["arena_cards"]')
    lines.append('W["weapons"]')
    lines.append(f'CA["chat_archive.md {ok(DESIGN / "chat_archive.md")}"]')
    lines.append(f'OT["open_threads.md {ok(DESIGN / "open_threads.md")}"]')
    lines.append('DGM["diagrams (CI artifacts)"]')

    # Edges among top-level
    lines.append("A --> DG")
    lines.append("A --> AC")
    lines.append("A --> W")
    lines.append("A --> CA")
    lines.append("A --> OT")
    lines.append("A -. rendered by CI .-> DGM")

    # --- CLASSES → baseline weapons
    lines.append('subgraph CLASSES["Classes"]')
    lines.append('  C_P["Pitcher"]')
    lines.append('  C_B["Batter"]')
    lines.append('  C_L["Linebacker"]')
    lines.append('  C_Q["Quarterback"]')
    lines.append("end")

    # --- TELEGRAPHS
    lines.append('subgraph TSG["telegraphs"]')
    for name in tele_files:
        lines.append(f'  {nid("T",name)}["{name} {ok(tele / name)}"]')
    lines.append("end")

    # --- ARENA CARDS
    lines.append('subgraph ACG["arena_cards"]')
    arena_ids = {}
    for name in arena_files:
        the_id = nid("A", name)
        arena_ids[name] = the_id
        lines.append(f'  {the_id}["{name} {ok(arena / name)}"]')
    lines.append("end")

    # --- WEAPONS
    lines.append('subgraph WG["weapons"]')
    weapon_ids = {}
    for name in weapon_files:
        the_id = nid("W", name)
        weapon_ids[name] = the_id
        lines.append(f'  {the_id}["{name} {ok(weap / name)}"]')
    lines.append("end")

    # Link classes to baseline weapons (WB/FP/SR/SD)
    # Map filenames -> short aliases for readability
    wb = weapon_ids.get("whistle_bomb.mmd", "W_whistle_bomb_mmd")
    fp = weapon_ids.get("foam_finger_pike.mmd", "W_foam_finger_pike_mmd")
    sr = weapon_ids.get("shoulder_ram.mmd", "W_shoulder_ram_mmd")
    sd = weapon_ids.get("spiral_disc.mmd", "W_spiral_disc_mmd")
    lines.append(f"C_P --> {wb}")
    lines.append(f"C_B --> {fp}")
    lines.append(f"C_L --> {sr}")
    lines.append(f"C_Q --> {sd}")

    # Link all baseline weapons to Stadium T1 (prefer the .md card)
    st1 = arena_ids.get("stadium_t1_rookie_warmup.md") or arena_ids.get("stadium_t1_rookie_warmup.mmd")
    if st1:
        lines.append(f"{wb} --> {st1}")
        lines.append(f"{fp} --> {st1}")
        lines.append(f"{sr} --> {st1}")
        lines.append(f"{sd} --> {st1}")

    # Rendered outputs (examples)
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

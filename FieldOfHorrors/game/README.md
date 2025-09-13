# Field of Horrors
Roguelike sports‑horror game — design, code, art, music, and docs.

## What’s inside
- **design/**: Game design docs, Mermaid (flow.mmd), PlantUML (systems.puml), palette (palette.json).
- **art/**: Concept art and CI‑generated assets (autogen).
- **game/**: Your engine project (e.g., Godot 4).
- **music/**: WIP stems/loops.
- **docs/**: Weekly report templates and exported PDFs.
- **tools/**: Utility scripts (e.g., palette builder).
- **.github/workflows/**: GitHub Actions for diagrams/PDFs/Discord posts.

## Quick start
1) Edit files in **design/** (e.g., `gdd.md`, `flow.mmd`, `palette.json`).
2) Push to `main`. CI will render:
   - `/art/autogen/flow.png` (Mermaid)
   - `/art/autogen/systems.png` (PlantUML)
   - `/art/autogen/palette.png` & `palette.gpl` (from palette.json)
   - `/docs/out/*.pdf` (GDD + Weekly Report)
3) (Optional) Add **DISCORD_WEBHOOK_URL** secret to post updates into your Discord.

## Conventions
- Use Git LFS for large binaries (PNG/JPG/WAV/MP4).
- Avoid committing very large files directly to `main`.

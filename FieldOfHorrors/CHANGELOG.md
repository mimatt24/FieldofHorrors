# Field of Horrors – Design Changelog

This changelog tracks **design documents, diagrams, and archive updates**.  
It complements the full archive (`history/chat_archive.md`) and raw logs (`history/raw_logs/`).

---

## [2025-09-13]
- **Created master archive** at `history/chat_archive.md` (digest of all design sessions).
- **Raw logs system added**:
  - `history/raw_logs/README.md` (instructions)
  - `history/raw_logs/session_template.md`
  - `history/raw_logs/session_2025-09-13.md` (first session log)
  - Helper script: `tools/add_log.sh`
- **CI simplified** to Mermaid-only (PNG auto-commit).
- Added new **weapon trees**:
  - `goalpost_boomerang.mmd`
  - `mascot_maul_tree.mmd`
- Added new **class telegraph docs**:
  - Point Guard (`point_guard.md`)
  - Center (`center.md`)
- Fixed **Mermaid syntax errors** in multiple skill trees (quotes + `%` → `pct`).
- Added **enemy spawn curves** (`enemy_spawn_curves.md`) and **weapon balance baselines** (`weapon_balance.md`).
- Linked first raw log from master archive.

---

## Format for Future Updates
When adding new designs, append entries like this:

\`\`\`markdown
## [YYYY-MM-DD]
- Added **document/diagram name** at `path/to/file`
- Updated **existing doc** with XYZ details
- Fixed **syntax error** in Mermaid diagram
- Expanded **archive** with section on XYZ
\`\`\`


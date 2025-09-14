# Contributing – Field of Horrors

## Branches
- `main`: protected.
- `design/*`: docs/diagrams.
- `feat/*`: gameplay/features.
- `balance/*`: data tuning.

## Commits
Use Conventional Commits: feat:, fix:, docs:, chore:, refactor:, ci:, test:.

## PR checklist
- [ ] Palette rules honored
- [ ] Telegraph timing keys valid
- [ ] Mermaid renders locally or via CI
- [ ] Updated docs (chat_archive links if relevant)
- [ ] CI green

## Running validators
- Python: `python tools/validate_design_rules.py`
- Mermaid (optional local): `npx @mermaid-js/mermaid-cli -i input.mmd -o out.svg`

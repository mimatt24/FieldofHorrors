# Raw Chat Logs – Field of Horrors

This directory stores **verbatim prompt/response logs** for long-term reference.

## Why keep raw logs?
- New ChatGPT threads can load context from these logs.
- Design decisions and reasoning remain searchable.
- Collaborators can review exact instructions, wording, and outcomes.

---

## Recommended Capture Methods

### Option A — Manual paste (fastest)
1) After a session, copy the **entire** conversation text (user + assistant).
2) Create or open a file for today in `history/raw_logs/` (see template below).
3) Paste under the correct headings (`USER:` / `ASSISTANT:`), save, commit.

### Option B — ChatGPT Export (full archive)
ChatGPT → **Settings → Data Controls → Export data**  
You’ll receive a download link (JSON/HTML). From that:
- Copy the relevant conversation into a dated `.md` file in this folder.
- If the raw JSON is huge, keep it outside the repo or prune sensitive parts.

---

## File Naming
Use one file per day or per major milestone:

- `session_YYYY-MM-DD.md`  
  e.g., `session_2025-09-13.md`

If multiple big sessions in a day: `session_2025-09-13_part2.md`.

---

## Session Template
Copy the file `session_template.md` in this folder, or use this block:

\`\`\`markdown
# Session YYYY-MM-DD – Field of Horrors (Raw Log)

## Context / Goal
- (One-liner: what we tried to accomplish)

---

## Log
### USER
<verbatim user message (copy/paste)>

### ASSISTANT
<verbatim assistant reply (copy/paste)>

### USER
<next message...>

### ASSISTANT
<next reply...>

(Repeat until the end of the session)
\`\`\`

---

## Tips
- Keep it **verbatim** (don’t rewrite).
- Break long conversations with `---` separators.
- If images were generated, link or reference the file in `/art/` by relative path.
- If you paste Mermaid blocks, wrap them in fenced code blocks (triple backticks + `mermaid`) so GitHub renders them.

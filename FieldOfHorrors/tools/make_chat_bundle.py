#!/usr/bin/env python3
"""
Concatenate project docs into a single ChatGPT-friendly bundle with a TOC.
Usage: python tools/make_chat_bundle.py [OUTPUT_PATH]
"""
import sys, re
from pathlib import Path
root = Path(__file__).resolve().parents[1]
docs = [*root.glob("docs/**/*.md"), *root.glob("docs/**/*.mmd")]
docs = sorted(docs, key=lambda p: str(p).lower())
out = Path(sys.argv[1]) if len(sys.argv)>1 else root/"chat_bundle/bundle.md"
out.parent.mkdir(parents=True, exist_ok=True)

def title_of(p):
    try:
        for line in p.read_text(encoding="utf-8", errors="ignore").splitlines():
            if line.strip().startswith("# "):
                return line.strip()[2:]
    except Exception:
        pass
    return p.name

toc = ["# Field of Horrors — Chat Bundle\n", "## Table of Contents\n"]
body = []
for i, p in enumerate(docs, 1):
    t = title_of(p)
    anchor = re.sub(r'[^a-z0-9]+','-', t.lower()).strip('-')
    toc.append(f"{i}. [{t}](#{anchor}) — `{p.relative_to(root)}`")
for p in docs:
    txt = p.read_text(encoding="utf-8", errors="ignore")
    body.append(f"\n\n---\n# {title_of(p)}\n\n> Source: `{p.relative_to(root)}`\n\n{txt}\n")

out.write_text("\n".join(toc)+ "".join(body), encoding="utf-8")
print(f"Wrote {out}")

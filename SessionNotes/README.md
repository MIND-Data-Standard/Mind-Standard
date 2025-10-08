# SessionNotes Handoff Guide

A lightweight workflow to keep continuity across chats and avoid losing context.

Use this in every new session:
1) Update `SessionNotes/Oct-5-2025/gpt-context.json` (or the current date folder) with the latest goal, acceptanceCriteria, openTodos, and a new checkpoint.
2) Start the new chat by pasting the Handoff Header below (fill in the blanks) and point to the context file path.
3) Keep tasks small and explicit; reference files by path and line ranges instead of pasting large blobs.
4) Snapshot decisions and next steps after meaningful changes.

Handoff Header (copy into a new chat)
- Repo: C:\Users\kbnea\OneDrive\Documents\GitHub\MIND-Standard
- Task: <one sentence>
- Acceptance criteria: <3–5 bullets>
- Key files: <paths>
- Constraints: <perf/compat/style>
- Context file: SessionNotes/Oct-5-2025/gpt-context.json

Context JSON fields
- goal: 1–2 sentences of what we’re doing next.
- acceptanceCriteria: 3–7 bullets the AI can verify.
- keyFiles: repo-relative paths to the files in play.
- decisions: short list of decisions made and why.
- openTodos: small, prioritized list.
- commands: reproducible run/build/test commands (Windows cmd.exe format).
- checkpoints: brief timestamps with progress notes.

Tips
- Prefer concrete asks: “Open X, add Y under section Z, validate with rule A” and provide file paths or line ranges.
- Trim logs/diffs to the most recent 100–200 lines.
- When the thread grows long, start a fresh one with the Handoff Header above.



# Global instructions

## Working together
1. Be direct. Push back with reasons; no flattery. Say early when you're unsure.
2. Never guess at APIs, CLI flags, env vars, or config. Check docs/--help, or say you don't know.
3. If something is ambiguous, ask one question rather than assuming. State assumptions you do make.
4. For anything beyond a small fix, propose a short plan and wait for my OK.
5. When making technical decisions, prefer quality, simplicity, robustness, scalability,
   and long-term maintainability.

## Changes
6. Smallest change that solves the task. Touch only what's needed; no drive-by refactors.
7. Keep structural changes (rename, move, extract) separate from behavior changes.
   If both are needed, do the structural one first and tell me.
8. Match the existing style. Use the project's formatter rather than hand-formatting.
9. Fix root causes, not symptoms. If you can't find the cause, say so.
10. Ask before adding dependencies or installing anything system-wide (apt, global npm/pip).
11. Never manually modify CHANGELOG.md or any file marked as auto-generated.

## Bugs and testing
12. When fixing a bug, first reproduce it end-to-end, as close as possible to how a real user
    would hit it. This makes sure you find the real problem and the fix actually solves it.
13. Run the project's tests/linters/build if they exist and report actual results.
    Never claim something works without running it.
14. Don't write tests that only test mocks.
15. If you notice unrelated problems (lint errors, failing or flaky tests, bugs, UI defects),
    don't fix them. List them at the end of your summary so I can decide.
16. Never skip, weaken, or delete a test to make it pass. If a test failed before your
    change, say so explicitly.

## Git
17. Never commit, push, or rewrite history unless I ask. I review diffs first.
18. Run git status before staging; never git add -A blindly. Never bypass hooks.

## Writing
19. Never use the em dash. Use a plain dash "-" instead.
20. When writing or substantially editing long Markdown files, put each full sentence on its own line.
    Keep normal Markdown structure otherwise.

## Environment
21. Debian over SSH in tmux; no GUI or browser. Prefer rg and fd.

## When you finish
22. Summarize changes per file, plus anything you're unsure about or skipped.

## Improving these instructions
23. When I correct you on something likely to recur, propose a one-line addition
    to this file (or the project's CLAUDE.md or AGENTS.md if it's project-specific). Show it; don't edit without OK.

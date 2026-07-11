# project.md — Project Context Skill File

> Paste this at the top of any coding loop conversation. Fill it in once per project. Stops the agent from re-deriving your context every session.

---

```
# Project context

## What this project is
[one paragraph: what it does, who uses it, what problem it solves]

## Stack
- Language: [e.g. Python 3.12]
- Framework: [e.g. FastAPI]
- Database: [e.g. PostgreSQL via SQLAlchemy]
- Key dependencies: [list 3-5 important ones]

## Conventions you must follow
- [e.g. "All functions must have type hints"]
- [e.g. "No raw SQL — use the ORM layer"]
- [e.g. "Tests live in /tests, mirror the src/ structure"]
- [e.g. "Never commit secrets — use .env and python-dotenv"]

## Things we do NOT do (and why)
- [e.g. "No global state — caused a race condition in v1"]
- [e.g. "No floats for currency — use Decimal"]

## How to run tests
[command]

## How to run the app locally
[command]

## Current known issues / tech debt
- [item 1]
- [item 2]

## Definition of done
- All tests pass
- No type errors (mypy strict)
- PR description explains the why, not just the what
```

---

**How to use:** Save a filled-in copy of this file per project (e.g. `myapp-context.md`). Paste the contents at the very top of your conversation before the loop prompt.

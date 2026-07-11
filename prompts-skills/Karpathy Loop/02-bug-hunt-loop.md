# Bug Hunt Loop

> Structured debugging — reproduces, isolates, fixes, and verifies in one autonomous run.

---

```
You are debugging autonomously. Work in a loop until the bug is fixed and verified.

BUG REPORT:
- Symptom: [what goes wrong]
- Expected: [what should happen]
- Steps to reproduce: [step by step]
- Error output / stack trace:
  [paste here]

ENVIRONMENT:
- Stack: [language, framework, versions]
- Relevant files: [list them]

LOOP PROTOCOL:
1. HYPOTHESIZE – list 3 possible root causes, ranked by likelihood
2. INVESTIGATE – identify which evidence confirms/rules out each hypothesis
3. FIX         – implement the fix for the most likely cause
4. VERIFY      – trace through the fix mentally. Does it fully resolve
                 the symptom? Any regressions?
5. DECIDE      – if the root cause is confirmed fixed: print RESOLVED
                 + a one-line summary.
                 Otherwise: print NEXT HYPOTHESIS and go again with new info.

RULES:
- Never claim fixed without tracing through the full execution path
- If a hypothesis is ruled out, do not revisit it
- State every assumption you make

Begin.
```

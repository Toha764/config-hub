# Bilevel Loop (Meta-Improvement)

> Two nested loops. The inner loop executes. The outer loop watches and improves how the inner loop searches — the architecture behind the 5x result in the Bilevel Autoresearch paper.

---

```
You are running a bilevel optimization loop.

OBJECTIVE:
[what you are trying to improve — be specific and measurable]

METRIC:
[how you will score success — must be a number or pass/fail]

=== OUTER LOOP (triggers every 3 inner cycles) ===
Watch how the inner loop is searching. Ask:
- Is it trying the same type of change repeatedly?
- Has it avoided entire categories of solutions?
- Is it getting stuck in local improvements and missing bigger moves?

After 3 inner cycles: print META-REVIEW, identify the search pattern
that is stuck, then print a SEARCH DIRECTIVE that forces the inner loop
to explore a different direction.

=== INNER LOOP (runs continuously) ===
1. PROPOSE   – suggest one change to improve the objective
2. APPLY     – describe what the change looks like in practice
3. MEASURE   – score it against the metric (be honest — did it actually help?)
4. COMMIT    – if the score improved: keep it and note it in CHANGE LOG.
               If it did not: roll it back and note what you learned.
5. After 3 cycles: trigger OUTER LOOP

CHANGE LOG (update every cycle):
- Cycle 1: [change] → [result]
- ...

RULES:
- The outer loop cannot touch the work directly — it can only change
  how the inner loop searches
- Both loops use the same model — smarter search, not a smarter model
- Stop when the metric plateaus for 3 consecutive outer cycles,
  or when you reach [N] total cycles

Begin inner loop, cycle 1.
```

---

**Tip:** Use this when a single loop plateaus. The outer loop breaks the inner loop's habits by forcing it into search directions the model's instincts naturally avoid.

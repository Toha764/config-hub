# Karpathy Loop Prompts

Ready-to-use autonomous loop prompts for coding, research, and meta-optimization.
Based on Andrej Karpathy's AutoResearch and the Bilevel Autoresearch paper.

---

## How to use

1. Pick the prompt that matches your task
2. Fill in the bracketed sections
3. For skill files (07, 08): paste them **above** the loop prompt at the start of your conversation
4. Paste into Claude and let it run

---

## Prompts

### Coding
| File | Use when |
|------|----------|
| `01-code-iteration-loop.md` | Building or fixing a feature from scratch |
| `02-bug-hunt-loop.md` | You have a bug and a stack trace |
| `03-code-review-loop.md` | You want a strict second opinion on your code |

### Research
| File | Use when |
|------|----------|
| `04-deep-research-loop.md` | You need thorough coverage of a topic |
| `05-decision-analysis-loop.md` | You need to stress-test a decision |

### Meta
| File | Use when |
|------|----------|
| `06-bilevel-loop.md` | A single loop has plateaued — add a second loop on top |

### Skill files (paste before any loop)
| File | Use when |
|------|----------|
| `07-skill-project.md` | Starting a coding loop — gives the agent your project context |
| `08-skill-research-context.md` | Starting a research loop — carries forward what you already know |

---

## When NOT to use a loop

A loop costs more tokens than a single prompt. Only worth it when all four are true:

- The task repeats at least weekly
- Verification can happen without you (tests, linters, a build)
- Your token budget can absorb ~3-10x the normal output
- The agent has enough context to act without asking you questions

If any of these are false, use one well-crafted prompt instead.

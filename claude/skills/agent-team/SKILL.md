---
name: agent-team
description: Orchestrate a team of Sonnet sub-agents — Orchestrator + parallel specialists + Synthesizer — for investigations, audits, comparisons, and other tasks that benefit from divided, parallel work culminating in a single consolidated report. Trigger when the user says "team of agents", "multi-agent", "spawn agents to investigate/compare/audit X", or describes a job too broad for one agent and naturally split across roles.
---

# agent-team

A reusable playbook for assembling and running a role-divided team of sub-agents on a single task. Produces **one** consolidated markdown report with classified findings and recommendations — not a pile of raw transcripts.

## When this skill applies

Use it when the task has **all three** properties:

1. **Investigative or comparative** — auditing, reviewing, diffing, mapping, cataloguing. Not "write feature X".
2. **Naturally parallelizable** — the work splits cleanly along axes (pages, files, layers, concerns) so multiple agents can run without blocking each other.
3. **Wants one synthesized output** — the user wants a single report with judgement, not five separate agent transcripts.

If the task is a single focused query → just spawn one Explore/general-purpose agent. If it's a feature implementation → use Plan + direct work. Don't reach for this skill by reflex.

## The four-step playbook

### 1. Scope — extract the brief

Pull from the user's request (and a quick recon if needed):

- **Subject** — what's being investigated/compared (one site vs another, one branch vs main, a codebase area, an external API, etc.).
- **Axes of work** — what dimensions partition the task (pages × languages × viewports, files × concerns, services × environments, …).
- **Deliverable path** — where the final report goes. Default: `docs/<task-slug>-report.md` if in a repo, else `./<task-slug>-report.md`.
- **Artifacts directory** — `artifacts/<task-slug>/<ISO-timestamp>/…` so reruns don't clobber.
- **Constraints** — read-only? rate-limited external targets? no-commit? Surface these as ground rules to every sub-agent.

If recon would meaningfully change the role split (e.g. finding existing tooling to reuse), do a small Bash/Read pass first. Don't do a full investigation here — you're scoping, not solving.

### 2. Roles — compose the team

Pick **3–6 specialist roles** based on the task. Roles must be **distinct concerns** with non-overlapping outputs; if two roles would produce the same artifact, merge them.

Common role archetypes (pick what fits, don't force all of them):

- **Mapper / Inventory** — enumerate the surface (URLs, files, endpoints, entities) and produce a matched inventory of "exists on A only / B only / both".
- **Visual / Pixel** — screenshots, image diffs, layout deltas. Use Playwright if available.
- **Content / Copy** — text extraction and diffing. Translation gaps, placeholders, missing sections.
- **Structure / Schema** — DOM, AST, schema, metadata, types. Anything structural rather than visual.
- **Functional / Behavioural** — exercise interactions, run flows, capture console/network errors.
- **Security / Compliance** — auth, headers, secrets, permissions, license.
- **Performance** — bundle size, network waterfalls, render timings, query plans.
- **Synthesizer** — **always present, always last, always sequential.** Reads every other agent's output, classifies findings, recommends action, writes the single report.

Each role gets a **one-paragraph charter** in the dispatch prompt: goal, inputs, output path, what to flag, what to ignore.

### 3. Dispatch — parallel specialists, then synthesizer

- Send **all specialist agents in a single message with multiple Agent tool calls** so they actually run in parallel. Sequential dispatch wastes the whole point of the skill.
- Use `subagent_type: general-purpose` with `model: sonnet` unless a more specific subagent (Explore, Plan, etc.) is a strict fit.
- Each prompt is **self-contained**: the agent has no conversation context, so include the subject URLs/paths, the role charter, the exact output location, the tools to use, and the ground rules verbatim.
- Wait for all specialists to complete. **Then** dispatch the Synthesizer with their reported output paths as input. The Synthesizer must read the artifacts directly — do not paraphrase findings into its prompt.

### 4. Synthesize — one report, classified, actionable

The Synthesizer's report MUST contain, for every finding:

- **Classification** — one of: `regression`, `intentional`, `improvement`, `unknown`.
- **Recommendation** — one of: `fix`, `keep`, `investigate`.
- **Rationale** — one or two sentences.

If the Synthesizer cannot tell whether something is intentional, it marks `unknown` + `investigate` and lists it in an **Open questions** section for the user — it does NOT guess.

Report skeleton:

```markdown
# <Task title>
_Generated <ISO date>_

## Executive summary
- <N> findings total — <N> regressions, <N> improvements, <N> unknown
- Priority-1: …

## <Per-axis findings — one section per role or per partitioned unit>
**Finding:** …
**Classification:** regression | intentional | improvement | unknown
**Recommendation:** fix | keep | investigate
**Rationale:** …

## Cross-cutting issues
(anything not partition-specific)

## Open questions
(for `unknown` findings — explicit user-facing questions)

## Suggested fix order
1. …
```

## Ground rules every sub-agent inherits

- **Sonnet only** unless the user specified otherwise.
- **Read-only by default** — no source edits, no commits, no pushes, no settings/config writes. Only writes allowed are to the agreed artifacts directory and the final report path.
- **Headless and clean** — kill dev servers, browsers, and report viewers before returning.
- **Don't block on one failure** — if a unit fails (page won't load, file unreadable), record the failure and continue.
- **Respect external services** — serial requests with a small delay (≥250 ms) when hitting live third-party origins. Never parallel-hammer.
- **Report by path, not by paste** — each agent's return message lists the artifact paths it wrote, not the contents. The Synthesizer reads the files.

## Orchestrator end-of-run checklist

Before declaring the task done, verify:

- [ ] Artifacts directory exists at the agreed path with every specialist's outputs.
- [ ] Final report exists at the agreed path.
- [ ] Report classifies every finding and includes recommendations.
- [ ] No leftover background processes or browser instances.
- [ ] Tell the user the report path and a one-line summary (`N findings, M regressions, top priority: X`).

Do not commit the report or artifacts unless the user explicitly asks.

## Anti-patterns — don't do these

- **Solo orchestrator doing the work.** If you find yourself reading files and writing the report yourself "while the agents run", you've skipped the dispatch step. Spawn the team or don't use this skill.
- **Sequential specialists.** Defeats the purpose. One message, multiple Agent calls.
- **Overlapping role outputs.** If two roles both produce a "differences list", you'll get duplicate findings and contradictions. Partition cleanly.
- **Dumping raw diffs in the report.** The Synthesizer's job is judgement: classify and recommend. Raw artifacts live in the artifacts dir; the report references them.
- **Skipping the Synthesizer.** Without it, the user gets N separate transcripts and has to do the synthesis themselves — which was the whole reason to use the skill.
- **Asking the user clarifying questions mid-run.** Scope upfront in step 1; if genuinely blocked, surface it in the Open questions section of the final report.

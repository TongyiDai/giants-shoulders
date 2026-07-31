---
name: giants-shoulders
description: |
  Pre-flight prior-art scan. Before starting a build-from-scratch task, search the internet for existing work that already solves the same or an adjacent problem, then report what to reuse, what to avoid, and how the current task differs. Named after Newton's "shoulders of Giants." Use at the START of a task that creates something new: building a tool, script, library, CLI, skill, plugin, agent, workflow, integration, prototype, or product; designing an architecture; or picking a framework/library/algorithm. Trigger even without an explicit research request — if the user is about to build something, check first. Also triggers on "I want to build", "should I build X", "is there already a", "has anyone done this", "什么现成方案", "别人怎么做的", "先看看有没有轮子". Do NOT use for trivial one-liners (translation, a quick edit, looking up the time) or tasks with no external prior art (editing the user's own private files/data).
---

# 巨人之肩 (Giants' Shoulders)

> "If I have seen further it is by standing on the shoulders of Giants." — Isaac Newton, 1675

## Overview

先运行 `scripts/doctor.sh --json` 检查本地安装。随后确认当前 Agent 是否提供网页搜索、代码托管搜索和页面抓取能力；能力缺失时输出 `blocked_no_search`，不要用记忆补齐调研结果。详细运行约定见 [runtime.md](references/runtime.md)。

Before building something new, find out who already built something like it.
Most ideas have been tried: some solved well, some solved badly, some abandoned
for instructive reasons, a few genuinely open. The goal is not to copy — it is
to start from the current frontier instead of a blank page: reuse proven
approaches, avoid known dead-ends, and see clearly where the task actually
diverges from what exists.

Agent-agnostic: works with any agent that can search the web (Claude Code,
Codex, Cursor, TRAE, or others). Use whatever web-search / fetch tools the host
provides. Run this **at the start of the task, before designing or coding**, and
keep it proportional — a short scan, not a literature review.

## When to run vs. skip

**Run it** when the task creates something new or picks an approach: building a
tool / script / library / CLI / skill / plugin / agent / workflow / integration
/ prototype / product, designing an architecture, or choosing a framework,
library, or algorithm.

**Skip it** for trivial tasks (translate a line, rename a variable, check the
time) or tasks with no external prior art (editing the user's own private
files/data). If unsure whether it's worth it, ask one sentence: "要不要我先花
一两分钟看看有没有现成方案？"

## Workflow

### 1. Restate the problem in one line

Strip the task down to the **core problem**, in plain terms — not the user's
chosen solution. E.g. "build a script to dedupe my CSV" → core problem = "row
deduplication in tabular data". If the framing is so broad it matches an entire
tool category, ask **exactly one** clarifying question before searching (offer
up to 3 example dimensions as prompts, not a questionnaire).

### 2. Generate a vocabulary before searching

Different communities use different words for the same thing. Before running any
query, write out **6–10 framings** of the problem from distinct vantage points,
and map each search query to one framing. This prevents the most common failure
mode: five queries all landing in the same semantic neighborhood. Cover at least:

- **Builder framing** — the user's own words
- **User-of-the-tool framing** — what someone searching for this would type
- **Academic / research framing** — if applicable
- **Infrastructure / implementation framing** — the low-level name for it
- **Adjacent-community framing** — the next-door discipline that likely solved it first

Include at least one **English** framing — most prior art and repos surface
better in English.

### 3. Search where builders actually publish

Use the host's web tools (search first, then fetch promising hits). Run **3–6
targeted queries** across distinct framings and sources — don't run one generic
query and stop.

| Source | What it finds | How |
|---|---|---|
| Web search | Products, comparisons, "best X for Y", blog posts | host search tool |
| **Code hosts** | Real implementations, libraries, "awesome-*" lists | `site:github.com <problem>`, GitLab; `gh search repos/code "<keywords>"` if `gh` CLI exists |
| Package registries | Existing libraries | npm, PyPI, crates.io, pkg.go.dev, Hugging Face (ML) |
| Product / community | Launched products, war stories | Product Hunt, Hacker News "Show HN", relevant subreddits |
| Q&A / forums | Gotchas, why approaches fail | Stack Overflow, HN threads |
| Domain venues | The canonical way | official docs, RFCs/standards, arXiv, model cards |

Prefer **primary sources** (repos, Show HN threads, project homepages) over
aggregator listicles. One 200-star GitHub repo beats a Medium listicle.

### 4. Trace one layer down on every direct match

This is where the scan most often fails — by stopping one layer too early. When
a project's docs say "built on X", "wraps Y", "official harness for Z", or
"runs through W", that named thing is often the **real incumbent** and the
project you found is a thin wrapper. Treat every named dependency in a direct
match as a search lead: follow it with a dedicated query before concluding.
Don't let the first (possibly tiny) project you find anchor the answer.

### 5. Cluster findings into four buckets

Don't dump raw results. Group them:

- **Direct matches** — same problem, same approach
- **Adjacent solutions** — same problem, different approach
- **Partial solutions** — solves a subset
- **Abandoned / stale** — existed, now dead (note last-commit date and, if
  findable, *why* it died — that's often the most instructive prior art)

### 6. Extract the standard patterns

Across the matches, what recurs? Common architecture, libraries, design
decisions, naming, pricing models. That's the default playbook the task would
be building on or competing with.

### 7. Benchmark the task's angle — honestly

In one paragraph, compare the user's specific framing against what exists. Name
the real differentiator, or admit there isn't one. **Don't manufacture novelty
to be nice**, and don't invent competitors to look thorough.

### 8. Deliver a verdict, then continue

Pick one verdict and lead with it (see `references/report-template.md` for the
exact output shape):

- **Use existing** — already solved well; name the best option(s)
- **Fork / extend** — closest project + specifically what to add
- **Contribute** — the feature belongs upstream; suggest where
- **Build it** — genuine gap; the differentiator is clear and defensible
- **Investigate first** — someone tried and abandoned it; understand why before spending time

Then hand off to the actual task, informed by what you found. Don't stall for
approval unless a finding materially changes scope (e.g. a mature tool already
does exactly this) — in that case surface it and ask.

## Budget & guardrails

- **Time-box it.** Aim for ≤10 total queries; stop earlier if the landscape is
  clear after 3–4 *and* at least one traced a dependency one layer down (step 4).
  This precedes the real work; it must not dominate it.
- **Report honestly.** "No direct prior art found" is a valid, valuable result —
  say where you looked rather than padding with weak matches or fake competitors.
- **Don't recommend "build" when something good exists.** Building custom carries
  ongoing maintenance cost that's routinely underestimated. Default to
  use/adapt/contribute unless nothing fits.
- **Check maintenance, not just stars.** Recent commits, issue response, release
  cadence, and bus factor reveal more than star count. A stable 500-star tool can
  beat a trending 50k one.
- **Respect licenses.** Note a project's license when suggesting reuse.
- **Cite sources.** Every named item gets a link so findings are verifiable.
- **No network?** Say so, note the scan was skipped, fall back to what you know —
  flag it as memory-derived and possibly stale — then proceed.
- **Synthesize, don't just list.** The value is the comparison (reuse vs. gap),
  not a pile of links.

## Reference files

- `references/report-template.md` — the exact output structure and a worked
  example. Read it when composing the brief.

## Optional: make it a default rule

By default this skill triggers only when its description matches the task. To
have it run automatically before every build-from-scratch task, add a rule to
the host agent's instruction file. Run once (opt-in, idempotent, safe to re-run):

```bash
scripts/install.sh
```

It asks whether to make Giants' Shoulders a default rule, and if yes appends a
marker-wrapped rule block to the agent's instruction files it finds (`AGENTS.md`
for Codex/TRAE/Cursor, `CLAUDE.md` for Claude Code). Declining writes nothing.
Set `GIANTS_SHOULDERS_ASSUME_YES=1` to install non-interactively.

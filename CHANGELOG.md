# Changelog

## 1.3.0 — 2026-08-09

Support for non-Claude tools.

`SKILL.md` is a cross-tool format, so Codex CLI, Cursor, Antigravity and similar
agent tools can use these skills unchanged — that part is documentation, not new
code. README now covers where to copy the folders for each.

ChatGPT Custom GPTs and Gemini Gems have no filesystem and cap their instruction
boxes below the size of the overhaul (8,000 and roughly 4,000 characters against
about 21,000). `build.sh` now generates `dist/single-file/`, where the overhaul is
flattened into one document with the four stage instruction sets appended inline
and the `stages/` references rewritten. These are meant to be uploaded as
Knowledge; README gives the loader text to paste into the instruction box.

The flattening is driven by explicit `<!-- bundled:… -->` / `<!-- singlefile:… -->`
markers in `resume-overhaul/SKILL.md` rather than by pattern-matching its prose,
and the build aborts if any stage path survives the rewrite. `check.sh` gained
checks that the single-file editions are in sync, carry every specialist's output
spec, and contain no dangling `stages/` paths.

No condensed or hand-written variants: every edition is generated from the same
five source files, so none of them can quietly fall behind.

## 1.2.0 — 2026-08-08

`resume-overhaul` is now self-contained. 1.1.0 made it delegate to the other four
skills, which fixed depth for Claude Code users but left browser users worse off:
someone who uploaded only `resume-overhaul.skill` got a run with the output specs
but none of the methodology behind them, including the anti-fabrication rules that
live in the specialist skills. It now bundles verbatim copies of all four under
`stages/` and reads them from there, so it works standalone with nothing else
installed. The degraded-mode branch is gone — there is nothing left to degrade to.

Same artifact ships to both channels: the Claude Code plugin and the browser
`.skill` file are identical, so there is only one behaviour to test.

Adds `build.sh` and `check.sh`. The four specialist `SKILL.md` files remain the
single source of truth; `stages/*.md` and `dist/` are generated. `check.sh`
verifies they haven't drifted and asserts the bundle still contains every
specialist's output spec — the static check that would have caught the 1.0.0 bug.

Also fixes a naming collision where "Stage 4" referred to two different things,
and README Route B, which no longer applies to the overhaul now that it is a
multi-file bundle.

## 1.1.0 — 2026-08-08

`resume-overhaul` is now a true orchestrator. It previously carried its own
condensed summaries of the diagnose, keyword and rewrite stages, so running it
produced noticeably shallower results than running the four skills by hand. It
now loads and runs `resume-diagnoser`, `resume-recruiter` and `resume-rewriter`
in full, passes each stage's output forward as the next stage's input, and hands
off to `resume-hiring-manager` for the interview. Inputs are collected once up
front so the specialist skills don't each stop to ask. If a specialist skill
isn't installed, the overhaul now says so and marks that stage's output as
degraded rather than silently substituting a thinner version.

Assembly, export and the closing report are unchanged — they are the overhaul's
own work and no specialist skill covers them.

## 1.0.0 — 2026-08-08

Initial release. Five skills packaged as a Claude Code plugin and marketplace:
`resume-diagnoser`, `resume-recruiter`, `resume-rewriter`,
`resume-hiring-manager`, `resume-overhaul`. The original `.skill` files are
also published under `dist/` for use with Claude in the browser.

---

Reminder: `version` is set in `plugins/shortlist/.claude-plugin/plugin.json`.
It must be bumped on every release, or installed users will not receive the
update.

# Changelog

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

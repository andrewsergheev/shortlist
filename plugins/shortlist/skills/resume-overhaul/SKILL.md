---
name: resume-overhaul
description: Run the whole resume overhaul end to end — diagnose, keyword-check, rewrite every bullet, then rebuild the CV as a finished ATS-safe document and export it to DOCX and PDF. Use when the user wants the full job done in one go, asks to rebuild or overhaul their entire resume or CV, wants the rewritten version back as a file, or asks for a resume as a docx or pdf.
---

# The Overhaul

You run the full loop in one pass and hand back a finished document.

This skill is an **orchestrator**. It does not contain its own diagnosis, keyword, or rewrite logic — it runs the four specialist skills in order and then assembles what they produce into a document. Running the overhaul must give the user the same depth as running the four skills by hand, because it *is* running them.

## The four skills it runs

| Stage | Skill | Produces |
| --- | --- | --- |
| 1 | `resume-diagnoser` | What's broken, ranked top 5 fixes |
| 2 | `resume-recruiter` | Keywords the role is screened on, gap list |
| 3 | `resume-rewriter` | Every bullet rebuilt on the XYZ pattern |
| 4 | `resume-hiring-manager` | Mock interview, scored — offered at the end |

Stages 1–3 run automatically and back to back. They need no input from the user beyond the resume itself.

Stage 4 cannot run inside the automatic pass, because an interview depends on the user answering questions live. Offer it once the document is done, and run it if they say yes.

## How to run each stage

For each of stages 1–3, in order:

1. **Load the specialist skill and follow it in full.** Invoke it the way this environment invokes skills — the Skill tool in Claude Code, or by reading the sibling skill file directly. Do not work from the summary in the table above.
2. **Produce that skill's complete output**, every section it specifies, in the chat. The diagnoser's top-5-ranked fixes with a before-and-after; the recruiter's top 15 ranked keywords, split gap list, trending skills, buzzwords to cut, and ranked action list; the rewriter's full rewritten section, five before-and-after pairs, and coverage note. If you find yourself producing a shorter version of a stage than that skill would produce on its own, you have got this wrong.
3. **Pass the output forward.** Each stage is the next stage's input — the recruiter reads the diagnosis, the rewriter takes the recruiter's missing-keywords list verbatim. Never ask the user to paste back something you produced two messages ago.

Don't skip stages to save time. The rewrite is only as good as the keyword pass in front of it.

**If a specialist skill isn't available** — the user installed this one on its own, or the skill won't load — say so plainly and name the missing skill before you continue. Then run that stage as best you can and mark its output as degraded, so the user knows which part to redo. Never silently substitute a thinner version.

## Collecting inputs

Collect everything **once**, up front, so the specialist skills don't each stop to ask.

You need: **target role**, **industry**, **seniority** (junior / mid / senior / lead), **the resume**, and optionally a **specific job posting** and **target companies**.

Read before you ask:

1. **The triggering message** — "overhaul my CV for a senior backend role" already carries the role.
2. **Earlier in this conversation** — if the resume or any earlier stage output is already here, reuse it.
3. **The resume itself** — seniority and industry are usually obvious from the work history. Infer them, state the inference, and move on.

Ask for anything still missing in **one short message**, then run the whole thing without stopping for approval between stages.

Take the resume as an **attachment** (PDF, DOCX, TXT, MD) or as **pasted text**. Prefer the file: layout problems like columns, tables, and text inside headers are visible in the file and invisible in extracted text. Ask for the original file if you only have text and the layout matters.

If the user has a specific job posting, ask for it. Everything downstream gets sharper when it's tailored to a real ad rather than a job title.

## Stage 4 — Assemble the document

This stage is the overhaul's own work — no specialist skill covers it.

Build the full CV as clean Markdown first. This is the source of truth for both exports.

Formatting rules, non-negotiable because they're the whole point of the exercise:

- Single column. No tables, text boxes, columns, or graphics.
- Name and contact details as ordinary body text at the top of page one — never in a header or footer.
- Standard section headings: Summary, Experience, Skills, Education, Certifications.
- Dates as `MMM YYYY`, consistently, e.g. `Aug 2023 – Dec 2025`.
- Standard fonts only — Calibri, Arial, or Georgia — at 10–11pt body.
- No icons, logos, photos, or text inside images.
- Two pages maximum unless the user says otherwise. If it overruns, cut the oldest roles down to one line each rather than shrinking the type.

Fold in every fix stage 1 identified, every keyword stage 2 said was landable, and the bullets exactly as stage 3 rewrote them. Rewrite the summary and normalise the skills section against the keyword list.

Keep the user's real dates, employers, and titles exactly as given. Carry `[metric needed]` markers through into the document rather than inventing a figure to fill them.

## Stage 5 — Export

Produce **DOCX and PDF**. How depends on where you're running:

**If you can create files directly** (claude.ai, the desktop app, Cowork — anywhere a document skill or file creation is available): use the available `docx` and `pdf` skills to generate both, then present the files for download. Don't hand-roll a converter when a document skill exists.

**If you're in Claude Code**, write the Markdown to disk, then convert with whatever the machine has. Check before using:

1. `pandoc` for Markdown → DOCX: `pandoc cv.md -o cv.docx`
2. DOCX → PDF: `soffice --headless --convert-to pdf cv.docx` (LibreOffice)
3. Or Markdown → PDF directly if a PDF engine is present: `pandoc cv.md -o cv.pdf --pdf-engine=weasyprint` (or `tectonic`, `wkhtmltopdf`)

If none of these are installed, save `cv.md` and a styled single-column `cv.html`, tell the user plainly that no converter was found, and print the one-line install command for their platform (`brew install pandoc`, `sudo apt install pandoc libreoffice`). Don't silently skip the export.

Ask where to save before writing files, and never overwrite an existing CV file without asking.

Verify after converting: the PDF must have selectable text, not an image of text. If your converter produced a scanned-looking PDF, say so — that file will fail every ATS it meets.

Name the files `CV-<Surname>-<Role>.docx` / `.pdf`.

## Stage 6 — Report and hand off to the interview

After the files, give a short summary in the chat:

1. The five things that were broken, and what you did about each
2. Keywords you landed, and any you left out with the reason
3. **Questions to answer** — every bullet marked `[metric needed]`, with the specific question for each. Tell the user to send the answers and you'll patch the document.

Keep this tight. The document is the deliverable; the report is the receipt.

Then offer the last stage: "Your CV is rebuilt. Want to run the mock interview now? You'll be asked to defend every number we just put on it."

If they say yes, run the **resume-hiring-manager** skill in full — load it and follow it, same as stages 1–3. The resume and role are already on file, so go straight to question 1 rather than asking again.

---
name: resume-overhaul
description: Run the whole resume overhaul end to end — diagnose, keyword-check, rewrite every bullet, then rebuild the CV as a finished ATS-safe document and export it to DOCX and PDF. Self-contained; needs no other skills installed. Use when the user wants the full job done in one go, asks to rebuild or overhaul their entire resume or CV, wants the rewritten version back as a file, or asks for a resume as a docx or pdf.
---

# The Overhaul

You run the full loop in one pass and hand back a finished document.

<!-- bundled:begin -->
Everything you need is bundled in this skill. The four specialist stages live in
`stages/` and you read them from there — no other skill has to be installed, and
you must never work from memory of what those stages contain.
<!-- bundled:end -->
<!-- singlefile: Everything you need is in this document. The four specialist stage instruction sets are appended in full at the end — no other skill has to be installed, and you must never work from memory of what those stages contain. -->

| Stage | Instructions | Produces |
| --- | --- | --- |
| 1 | `stages/resume-diagnoser.md` | What's broken, top 5 fixes ranked by impact |
| 2 | `stages/resume-recruiter.md` | Keywords the role is screened on, split gap list |
| 3 | `stages/resume-rewriter.md` | Every bullet rebuilt on the XYZ pattern |
| 4–6 | this file | The assembled document, the exports, the report |
| 7 | `stages/resume-hiring-manager.md` | Mock interview, scored — offered at the end |

## How to run a stage

For each of stages 1, 2 and 3, in order:

<!-- bundled:begin -->
1. **Read the stage file.** Open `stages/<name>.md` and follow it in full. Read
   the whole file — not the first screenful.
<!-- bundled:end -->
<!-- singlefile: 1. **Read the stage's instructions** in the matching section at the end of this document, and follow them in full. Read the whole section — not the first few lines. -->
2. **Produce that stage's complete output** in the chat, every section it
   specifies. The output specs in those files are the deliverable, not a
   suggestion. If you produce something shorter than the stage file describes,
   you have got this wrong and the user gets a worse CV than they would have by
   running the stages one at a time.
3. **Pass the output forward.** Each stage is the next stage's input — stage 3
   takes stage 2's missing-keywords list verbatim. Never ask the user to paste
   back something you produced two messages ago.

Run stages 1–3 back to back without stopping for approval between them.

**Two things to ignore in the stage files.** They are verbatim copies of skills
that can also run standalone, so each one carries a `Collecting inputs` section
and a closing line handing off to the next skill. Inside the overhaul both are
wrong: inputs are collected once, below, and you control the sequencing. Follow
everything else in those files exactly, especially the rules about not inventing
numbers, statistics, or keywords.

## Collecting inputs

Collect everything **once**, up front.

You need: **target role**, **industry**, **seniority** (junior / mid / senior /
lead), **the resume**, and optionally a **specific job posting** and **target
companies**.

Read before you ask:

1. **The triggering message** — "overhaul my CV for a senior backend role"
   already carries the role.
2. **Earlier in this conversation** — if the resume or any earlier stage output
   is already here, reuse it.
3. **The resume itself** — seniority and industry are usually obvious from the
   work history. Infer them, state the inference, and move on.

Ask for anything still missing in **one short message**, then run the whole thing
without stopping.

Take the resume as an **attachment** (PDF, DOCX, TXT, MD) or as **pasted text**.
Prefer the file: layout problems like columns, tables, and text inside headers
are visible in the file and invisible in extracted text. Ask for the original
file if you only have text and the layout matters.

If the user has a specific job posting, ask for it. Everything downstream gets
sharper when it's tailored to a real ad rather than a job title.

## Stage 4 — Assemble the document

Build the full CV as clean Markdown first. This is the source of truth for both
exports.

Formatting rules, non-negotiable because they're the whole point of the exercise:

- Single column. No tables, text boxes, columns, or graphics.
- Name and contact details as ordinary body text at the top of page one — never
  in a header or footer.
- Standard section headings: Summary, Experience, Skills, Education,
  Certifications.
- Dates as `MMM YYYY`, consistently, e.g. `Aug 2023 – Dec 2025`.
- Standard fonts only — Calibri, Arial, or Georgia — at 10–11pt body.
- No icons, logos, photos, or text inside images.
- Two pages maximum unless the user says otherwise. If it overruns, cut the
  oldest roles down to one line each rather than shrinking the type.

Fold in every fix stage 1 identified, every keyword stage 2 said was landable,
and the bullets exactly as stage 3 rewrote them. Rewrite the summary and
normalise the skills section against the keyword list.

Keep the user's real dates, employers, and titles exactly as given. Carry
`[metric needed]` markers through into the document rather than inventing a
figure to fill them.

## Stage 5 — Export

Produce **DOCX and PDF**. How depends on where you're running:

**If you can create files directly** (claude.ai, the desktop app, Cowork —
anywhere a document skill or file creation is available): use the available
`docx` and `pdf` skills to generate both, then present the files for download.
Don't hand-roll a converter when a document skill exists.

**If you're in Claude Code**, write the Markdown to disk, then convert with
whatever the machine has. Check before using:

1. `pandoc` for Markdown → DOCX: `pandoc cv.md -o cv.docx`
2. DOCX → PDF: `soffice --headless --convert-to pdf cv.docx` (LibreOffice)
3. Or Markdown → PDF directly if a PDF engine is present:
   `pandoc cv.md -o cv.pdf --pdf-engine=weasyprint` (or `tectonic`, `wkhtmltopdf`)

If none of these are installed, save `cv.md` and a styled single-column
`cv.html`, tell the user plainly that no converter was found, and print the
one-line install command for their platform (`brew install pandoc`,
`sudo apt install pandoc libreoffice`). Don't silently skip the export.

Ask where to save before writing files, and never overwrite an existing CV file
without asking.

Verify after converting: the PDF must have selectable text, not an image of
text. If your converter produced a scanned-looking PDF, say so — that file will
fail every ATS it meets.

Name the files `CV-<Surname>-<Role>.docx` / `.pdf`.

## Stage 6 — Report

After the files, give a short summary in the chat:

1. The five things that were broken, and what you did about each
2. Keywords you landed, and any you left out with the reason
3. **Questions to answer** — every bullet marked `[metric needed]`, with the
   specific question for each. Tell the user to send the answers and you'll patch
   the document.

Keep this tight. The document is the deliverable; the report is the receipt.

## Stage 7 — Offer the interview

The interview can't run inside the automatic pass, because it depends on the user
answering questions live. Offer it once the document is done:

> "Your CV is rebuilt. Want to run the mock interview now? You'll be asked to
> defend every number we just put on it."

If they say yes, read `stages/resume-hiring-manager.md` and follow it in full.
The resume and role are already on file, so go straight to question 1 rather than
asking again.

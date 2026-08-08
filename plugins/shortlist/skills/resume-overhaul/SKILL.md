---
name: resume-overhaul
description: Run the whole resume overhaul end to end — diagnose, keyword-check, rewrite every bullet, then rebuild the CV as a finished ATS-safe document and export it to DOCX and PDF. Use when the user wants the full job done in one go, asks to rebuild or overhaul their entire resume or CV, wants the rewritten version back as a file, or asks for a resume as a docx or pdf.
---

# The Overhaul

You run the full loop in one pass and hand back a finished document. Four stages, then two files.

## What this does and doesn't cover

Stages 1–3 (diagnose, keyword-check, rewrite) run automatically — they need no input from the user beyond the resume itself.

Stage 4 of the loop, the mock interview, cannot run automatically. It depends on the user answering questions live. Finish the document, then offer it: "Your CV is rebuilt. Want to run the mock interview now? You'll be asked to defend every number we just put on it." If the **resume-hiring-manager** skill is installed, say they can run it directly.

Don't skip stages to save time. The rewrite is only as good as the keyword pass in front of it.

## Collecting inputs

You need: **target role**, **the resume**, and optionally a **specific job posting** and **target companies**.

Read before you ask:

1. **The triggering message** — "overhaul my CV for a senior backend role" already carries the role.
2. **Earlier in this conversation** — if the resume or any earlier stage output is already here, reuse it.
3. **The resume itself** — seniority and industry are usually obvious from the work history. Infer them, state the inference, and move on.

Ask for anything still missing in **one short message**, then run the whole thing without stopping for approval between stages.

Take the resume as an **attachment** (PDF, DOCX, TXT, MD) or as **pasted text**. Prefer the file: layout problems like columns, tables, and text inside headers are visible in the file and invisible in extracted text. Ask for the original file if you only have text and the layout matters.

If the user has a specific job posting, ask for it. Everything downstream gets sharper when it's tailored to a real ad rather than a job title.

## Stage 1 — Diagnose

Identify what's breaking. Cover ATS-killers (multi-column layouts, tables, content in headers or footers, text baked into images, ambiguous date formats, non-standard section headings), the weakest line in each section, and the signals a hiring manager for this role expects and can't find.

Don't invent rejection statistics and don't pad the list. Flag what genuinely breaks parsing or buries content, not what is merely unfashionable.

## Stage 2 — Keyword check

Work out what this role is actually screened on.

- If the user supplied a job posting, that's your source. Analyse it directly.
- If you have web search, search current postings for this role, seniority, and location, and base the list on what you find. Say roughly how many you looked at.
- If you have neither, say so plainly and give a pattern-based list, flagged as such.

Produce the terms that matter, then split what's missing from the resume in two:

- **Has it, hasn't said it** — real experience the resume doesn't surface. Fix these first; they're free.
- **Doesn't have it** — genuine gaps. Say whether each is a dealbreaker at this level or a nice-to-have.

## Stage 3 — Rewrite

Rebuild every bullet in the experience section on the XYZ pattern: *accomplished **X** as measured by **Y**, by doing **Z***.

- Lead with a verb. No "responsible for," "helped with," "assisted in."
- Carry a number, percentage, or measurable outcome wherever one honestly exists.
- **Never invent a figure.** If a bullet needs a metric the user hasn't given you, collect it in the questions list at the end and mark the bullet `[metric needed]` in the document rather than guessing. An invented number fails at the interview, and that failure is worse than a weak bullet.
- Use the plainest verb that is true — "led" over "spearheaded," "built" over "architected" if they wrote the code. Inflation is what an experienced screener notices first.
- Work the missing keywords in where real experience supports them. Where none does, leave the keyword out and say so.
- One line per bullet, two at most.

Also rewrite the summary and normalise the skills section against the keyword list.

## Stage 4 — Assemble the document

Build the full CV as clean Markdown first. This is the source of truth for both exports.

Formatting rules, non-negotiable because they're the whole point of the exercise:

- Single column. No tables, text boxes, columns, or graphics.
- Name and contact details as ordinary body text at the top of page one — never in a header or footer.
- Standard section headings: Summary, Experience, Skills, Education, Certifications.
- Dates as `MMM YYYY`, consistently, e.g. `Aug 2023 – Dec 2025`.
- Standard fonts only — Calibri, Arial, or Georgia — at 10–11pt body.
- No icons, logos, photos, or text inside images.
- Two pages maximum unless the user says otherwise. If it overruns, cut the oldest roles down to one line each rather than shrinking the type.

Keep the user's real dates, employers, and titles exactly as given.

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

## Stage 6 — Report

After the files, give a short summary in the chat:

1. The five things that were broken, and what you did about each
2. Keywords you landed, and any you left out with the reason
3. **Questions to answer** — every bullet marked `[metric needed]`, with the specific question for each. Tell the user to send the answers and you'll patch the document.
4. The offer to run the mock interview

Keep this tight. The document is the deliverable; the report is the receipt.

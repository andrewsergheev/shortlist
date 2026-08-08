# Shortlist

Five skills that take a resume from screened-out to shortlisted. Each one does a
single job — diagnose the CV, find the keywords the role is screened on, rewrite
the bullets, or interview you on the result — and you can run them one at a time
in that order. Or run `resume-overhaul` and get the whole thing done in one go,
finishing with a rebuilt CV exported as DOCX and PDF.

## The five commands

| Command | What it does |
| --- | --- |
| `/shortlist:resume-diagnoser` | What's broken and why |
| `/shortlist:resume-recruiter` | Keywords the role is screened on |
| `/shortlist:resume-rewriter` | Every bullet rebuilt on the XYZ pattern |
| `/shortlist:resume-hiring-manager` | Mock interview, scored |
| `/shortlist:resume-overhaul` | All of the above, plus a finished CV exported as DOCX and PDF |

Run individually, the order is **diagnoser → recruiter → rewriter →
hiring-manager**.

`resume-overhaul` is self-contained — it bundles the other four inside itself, so
it works on its own with nothing else installed. It runs the first three stages
in full, same depth as running them by hand, feeding each stage's output into the
next, then assembles and exports the document. It offers the interview at the end
rather than folding it into the automatic pass, because an interview needs live
back-and-forth; say yes and it runs the interview stage for you.

## Install for Claude Code

```
/plugin marketplace add andrewsergheev/shortlist
/plugin install shortlist@shortlist
```

For DOCX and PDF export, `resume-overhaul` needs a converter installed on your
machine: `pandoc` for DOCX, and either LibreOffice or weasyprint for PDF.

```sh
# macOS
brew install pandoc
brew install --cask libreoffice   # or: brew install weasyprint

# Debian / Ubuntu
sudo apt install pandoc
sudo apt install libreoffice      # or: sudo apt install weasyprint
```

Without them the skill still works — it just produces Markdown and HTML instead
of DOCX and PDF.

## Install for Claude in the browser (no terminal needed)

There are two ways to do this, and neither one needs a command line.

**Route A — upload the file. This is the one to use.** Open the
[`dist/`](dist/) folder at the top of this page and click the skill you want, for
example `resume-overhaul.skill`. Click the download button to save it to your
computer. Now open Claude, go to **Settings → Capabilities → Skills → Add**, and
upload the file you just downloaded.

If you only want one, make it `resume-overhaul.skill` — it contains the other
four and does the whole job on its own.

**Route B — copy and paste the text.** This works for the four single-file
skills only, *not* for `resume-overhaul`, which is a bundle of several files and
has to be uploaded as a file. For any of the other four, open the
[`plugins/shortlist/skills/`](plugins/shortlist/skills/) folder above, click the
skill's folder, then click its `SKILL.md` file. Select everything on the page and
copy it. In Claude, go to **Settings → Capabilities → Skills → Add**, choose
**"Write skill instructions"**, and paste it in.

DOCX and PDF export works in the browser without installing anything, as long as
file creation is turned on in Settings.

## How to use it

Attach your CV to the chat and type:

```
/shortlist:resume-overhaul senior backend engineer
```

You get a rebuilt CV back as two files, a DOCX and a PDF. The resume can be an
attachment or just pasted in as text, and you can paste a real job ad along with
it to tailor the result to that specific listing.

## Working on this repo

The four specialist `SKILL.md` files are the single source of truth.
`resume-overhaul/stages/*.md` and everything in `dist/` are generated — never
edit them by hand.

```sh
./build.sh   # regenerate stages/ and dist/ after editing any skill
./check.sh   # verify nothing has drifted out of sync
```

`check.sh` also asserts that the overhaul bundle still contains every
specialist's output spec. That check exists because v1.0.0 shipped a condensed
paraphrase that silently dropped most of them.

## Credits

Adapted from Cindy Zhu's guide, [4 Claude skills that make your resume unrejectable](https://cindyzhu.com.au/guides/resume-unrejectable.html).

## License

The MIT license covers the packaging.

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

## Install for other AI tools

### Codex CLI, Cursor, Antigravity, and other agent tools

`SKILL.md` is a cross-tool format — these skills work unchanged, no conversion
needed. Clone the repo and copy the skill folders where your tool looks for them:

```sh
git clone https://github.com/andrewsergheev/shortlist
cd shortlist

# OpenAI Codex CLI — personal
cp -r plugins/shortlist/skills/* ~/.codex/skills/

# Google Antigravity, or any tool using the .agents convention
mkdir -p .agents/skills && cp -r plugins/shortlist/skills/* .agents/skills/
```

Codex has moved its skills directory between releases — if the skills don't show
up under `/skills`, check where your version looks and copy there instead. Either
way, `resume-overhaul` brings its `stages/` folder with it, so keep the folder
structure intact rather than copying loose `SKILL.md` files.

### ChatGPT (Custom GPT)

A Custom GPT's instructions box holds 8,000 characters. The overhaul is about
21,000, so it goes in **Knowledge**, not in the instructions box.

1. Download [`dist/single-file/resume-overhaul.md`](dist/single-file/) — one file,
   everything included.
2. In ChatGPT go to **Explore GPTs → Create → Configure**.
3. Under **Knowledge**, click **Upload files** and add the file you downloaded.
4. Paste this into **Instructions**:

```text
You rebuild resumes. The file resume-overhaul.md in your Knowledge contains your
full instructions. Read it in full before you start, and follow every stage in it
exactly, including the stage instruction sections at the end of that document.
Do not summarise or shorten any stage. When the user gives you a resume and a
target role, run the whole process from that file.
```

The four individual skills are in the same folder if you'd rather build a GPT per
stage. Each is under 4,000 characters, so those *do* fit in the instructions box
directly.

### Gemini (Gems)

Gems cap instructions at roughly 4,000 characters, so the overhaul takes the same
Knowledge route.

1. Download [`dist/single-file/resume-overhaul.md`](dist/single-file/).
2. In Gemini go to **Gems → New Gem**.
3. Under **Knowledge**, upload the file.
4. Paste the same instruction text shown above for ChatGPT.

The four individual skills fit inside a Gem's instruction box directly.

### Anything else

Every one of these is just Markdown. If your tool takes a system prompt, a custom
instruction, or an uploaded file, paste in whichever file from
[`dist/single-file/`](dist/single-file/) matches what you want.

## How to use it

Attach your CV to the chat and type:

```
/shortlist:resume-overhaul senior backend engineer
```

You get a rebuilt CV back as two files, a DOCX and a PDF. The resume can be an
attachment or just pasted in as text, and you can paste a real job ad along with
it to tailor the result to that specific listing.

## Working on this repo

The five `SKILL.md` files under `plugins/shortlist/skills/` are the single source
of truth. `resume-overhaul/stages/*.md` and everything in `dist/` — the `.skill`
zips and the `single-file/` editions — are generated. Never edit those by hand.

`resume-overhaul/SKILL.md` carries `<!-- bundled:… -->` and `<!-- singlefile:… -->`
markers around the few lines that differ between the folder edition and the
flattened one. They're HTML comments, so they don't render; `build.sh` uses them
to swap those lines and fails loudly if a stage path survives the rewrite.

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

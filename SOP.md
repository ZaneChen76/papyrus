# SOP — Standard Operating Procedure

> **This document is mandatory.** Follow every step in order. Do not skip or reorder.

## Phase 0: Information Gathering

1. **Confirm the paper URL** — arXiv e-print preferred (`https://arxiv.org/abs/XXXX.NNNNN`)
2. **Confirm output preferences**: title, language, font size (default: 10pt), page size (default: A4)

## Phase 1: Fetch and Parse Source

```bash
./SCRIPTS/fetch_arxiv.sh https://arxiv.org/abs/XXXX.NNNNN /tmp/papyrus_paper
```

This downloads the LaTeX source tar.gz and extracts:
- `ms.tex` or `main.tex` — primary manuscript
- `Figures/` — original figure PNG/PDF files
- `vis/` — visualization PDFs (if any)
- `*.bib` — bibliography

**Verify**: check that `Figures/` contains the expected number of images.

## Phase 2: Figure Mapping (CRITICAL)

**Do NOT guess which image file corresponds to which paper figure.**

1. Fetch the arXiv HTML version: `https://arxiv.org/html/XXXX.NNNNN`
2. Extract all `<figure>` blocks from the HTML
3. Parse `id=` attributes and `src=` paths to build the mapping table:

   | arXiv HTML `id` | Paper Figure | Source File |
   |---|---|---|
   | `S3.F1` | Figure 1 | `Figures/XXX.png` |
   | `S3.F2` | Figure 2 | `Figures/XXX.png` + `Figures/YYY.png` |
   | `Sx1.F3` | Figure 3 | `x1.png` |
   | `Sx1.F4` | Figure 4 | `x2.png` + `x3.png` |

4. Download any `x1.png`, `x2.png` ..., `xN.png` images from the arXiv HTML page (these are often NOT in the source tar.gz — they are appendix figures generated from vector graphics).

**Verification**: for each figure, confirm the image dimensions match a known cross-reference from the PDF.

## Phase 3: Formula Extraction and Rendering

1. Scan the paper for all displayed formulas (not inline math)
2. Extract each to LaTeX source
3. Render each formula via codecogs:

```bash
./SCRIPTS/render_formulas.sh formulas.txt /tmp/papyrus_formulas/
```

**Formula rendering rules**:
- Use `\dpi{150}` prefix for crisp resolution
- Use `\mathrm{}` for function names (Attention, softmax, FFN, etc.)
- Use `\displaystyle` for block formulas
- Use `\left(` and `\right)` for properly sized parentheses
- **Never upscale** the rendered PNGs — use them at native resolution
- Embed in HTML with `max-width: 100%; height: auto; display: block; margin: 0 auto`

**Service URL format**:
```
https://latex.codecogs.com/png.image?\dpi{150}%20\displaystyle%20%5Cmathrm{formula}
```

## Phase 4: Build Annotated HTML

Use `TEMPLATES/paper.html` as the base template. Build the document section by section:

### 4.1 Section structure
For each paper section/resubsection, create:
```html
<div class="section-title" id="sec-intro">1 Introduction · 引言</div>
<div class="bilingual-block">
  <div class="english-text"><!-- Original English --></div>
  <div class="chinese-text"><!-- Chinese translation --></div>
  <div class="commentary"><!-- Expert commentary --></div>
</div>
```

### 4.2 Figure embedding
```html
<div class="figure-container">
  <img src="ModalNet-XX.png" alt="Figure caption" style="max-width:100%; height:auto; border-radius:4pt;">
</div>
<div class="figure-caption">图N：中文标题（原论文 Figure N）。</div>
```

For multi-panel figures in the appendix (e.g., x1.png-x5.png), add a dedicated appendix section.

### 4.3 Formula embedding
```html
<div class="formula-block">
  <img src="formula_N.png" alt="Formula N" style="max-width:100%; height:auto; display:block; margin:0 auto;">
</div>
<div class="formula-caption">公式N：公式说明。</div>
```

### 4.4 Table embedding
Use HTML `<table>` with Kami-styled headers. Include bilingual column headers.

### 4.5 Commentary rules
- **No fabrication**: all content must derive from the original paper
- **No scope creep**: stay within confirmed boundaries
- **Be insightful**: explain WHY, not just WHAT
- Max 3-4 sentences per commentary block

### 4.6 Typesetting specification
```css
:root {
  --h1: 22pt; --h2: 17pt; --h3: 13pt;
  --body-lead: 11pt; --body: 10pt; --body-dense: 9pt;
  --caption: 9pt; --label: 9pt;
}
body { font-family: "MingLiU", "LiSong Pro", "SimSun", "Songti SC", serif; }
.english-text { font-family: "Times New Roman", "Charter", "Georgia", serif; }
```

## Phase 5: Build PDF

```bash
./SCRIPTS/build_pdf.sh /tmp/papyrus_paper/annotated.html /tmp/papyrus_paper/output.pdf
```

Uses WeasyPrint to convert HTML → PDF. All images must be in the same directory as the HTML or absolute paths.

## Phase 6: Quality Control (Three-Round)

### Round 1: Structural Check
- [ ] All sections present (abstract through references)
- [ ] All original figures embedded with correct source files
- [ ] All formulas visible and correctly positioned
- [ ] No page breaks in the middle of formula blocks or tables
- [ ] No empty/blank pages
- [ ] Table of Contents page intact

### Round 2: Content Consistency
- [ ] English text matches original paper verbatim
- [ ] Chinese translation is accurate and idiomatic
- [ ] Commentary blocks are relevant and non-redundant
- [ ] Figure captions match paper's actual figure labels
- [ ] Table data matches paper's numbers exactly
- [ ] No <strong> tags on structural labels (section markers, config names)

### Round 3: Quality and Polish
- [ ] Formulas are sharp (no pixelation, no blur, no overflow)
- [ ] Formula images at native resolution (no CSS height-based scaling)
- [ ] Long formulas fit within wireframe box without overflow
- [ ] Font rendering is clean (MingLiU for CN, Times New Roman for EN)
- [ ] Page margins consistent throughout
- [ ] Color contrast meets accessibility minimums
- [ ] Hyperlinks working (footnotes, cross-references)

## Done Checklist

- [ ] PDF generated and delivered
- [ ] Source HTML archived for future edits
- [ ] Figure mapping documented in session notes
- [ ] Any formula rendering issues noted in ERRORS.md

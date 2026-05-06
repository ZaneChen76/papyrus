# Papyrus — Academic Paper Deep-Read Skill

> Turn arXiv papers into bilingual, beautifully formatted, annotation-rich PDFs.

## Identity

**Papyrus** (莎草纸) transforms academic papers into deep-read study documents. Input a paper (arXiv URL or local PDF), output a PDF with:

- **Original text preserved** — exact English wording, figures, tables, equations
- **Chinese translation** — paragraph-by-paragraph, accurate and readable
- **Expert commentary** — technical insights, historical context, design rationale
- **Professional typesetting** — Kami-inspired design, visible formula wireframes, proper fonts

## Prerequisites

- Python 3.10+ with `weasyprint`, `pypdf`, `Pillow`, `requests`
- Node.js (for KaTeX fallback)
- Internet access (for codecogs.com formula rendering and arXiv downloads)

## Quick Start

```bash
# Minimal invocation
./SCRIPTS/run.sh --paper https://arxiv.org/abs/1706.03762

# Full options
./SCRIPTS/run.sh \
  --paper https://arxiv.org/abs/1706.03762 \
  --language zh-CN \
  --output ~/Desktop/annotated-paper.pdf \
  --title "Attention Is All You Need — 逐段精读"
```

## Output

A single PDF containing:
1. Cover page with title, authors, abstract (bilingual)
2. Body text in bilingual blocks (English → Chinese → Commentary)
3. All original figures with translated captions
4. All formulas rendered as crisp LaTeX PNGs from codecogs
5. Tables with bilingual headers
6. Appendix figures (if any)
7. Epilogue with key takeaways

## Design System

- **Body**: 10pt MingLiU / Times New Roman
- **Accent**: #1B365D (ink blue), #f5f4ed (warm parchment)
- **Formula wireframe**: 1pt #d0dce9 border, rounded corners, light background
- **Page**: A4, 20mm margins

## Directory Structure

```
papyrus/
├── SKILL.md           ← You are here
├── SOP.md             ← Standard Operating Procedure (mandatory steps)
├── README.md          ← GitHub project README
├── SCRIPTS/
│   ├── run.sh         ← Main entry point
│   ├── fetch_arxiv.sh ← Download arXiv source (tar.gz)
│   ├── render_formulas.sh ← Render LaTeX → PNG via codecogs
│   ├── build_html.py  ← Build annotated bilingual HTML
│   └── build_pdf.sh   ← HTML → WeasyPrint PDF
├── TEMPLATES/
│   └── paper.html     ← Base HTML template (Kami design system)
└── PROMPTS/
    └── qc_checklist.md ← Three-round quality control checklist
```

## Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| Formula rendering: codecogs PNG @ `\dpi{150}` | No LaTeX dependency, crisp at native resolution, portable |
| Images: `max-width:100%; height:auto` | Never upscale; avoids blur from LANCZOS enlarging |
| Formula wireframe: visible border | User-requested: visually distinguishes formulas from text |
| Bilingual blocks: EN→CN→Commentary | Three-layer depth progressively builds understanding |
| Font: MingLiU for CN, Times New Roman for EN | Academic, readable, widely available on macOS/Windows |

## Known Limitations

- codecogs.com requires internet; no offline mode
- WeasyPrint SVG math rendering is unreliable → always use PNG
- Font availability varies by OS → fallback chain: MingLiU → LiSong Pro → SimSun → Songti SC
- arXiv source must be downloadable (no paywalled papers)

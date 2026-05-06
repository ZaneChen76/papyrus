# 📜 Papyrus

> Turn arXiv papers into bilingual, beautifully formatted, annotation-rich PDFs.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python 3.10+](https://img.shields.io/badge/Python-3.10%2B-green)](https://python.org)

Papyrus (莎草纸) transforms academic papers into deep-read study documents. Given a paper URL, it produces a single PDF containing the original English text, paragraph-by-paragraph Chinese translation, expert commentary, all figures and formulas — typeset with professional Kami-inspired design.

---

## ✨ What You Get

| Feature | Description |
|---------|-------------|
| Original text preserved | Exact English wording, figures, tables, equations |
| Chinese translation | Paragraph-by-paragraph, accurate and idiomatic |
| Expert commentary | Technical insights, historical context, design rationale |
| Crisp formulas | LaTeX rendered at 150 DPI via codecogs, zero blur |
| Visible formula wireframes | Clean border + background for each equation block |
| Professional typesetting | Kami design system — 10pt MingLiU + Times New Roman |
| Appendix figures | All attention visualizations and supplementary charts |

## 🚀 Quick Start

```bash
# CLI entry point
./SCRIPTS/run.sh --paper https://arxiv.org/abs/1706.03762 \
    --title "Attention Is All You Need — 逐段精读"
```

The pipeline:
1. **Fetch** — Downloads arXiv LaTeX source
2. **Render** — Converts LaTeX formulas to PNG via codecogs.com
3. **Build** — Constructs annotated bilingual HTML (LLM-assisted)
4. **Export** — WeasyPrint HTML → PDF

> ⚠️ Steps 2 (formula identification) and 3 (translation/commentary) require LLM assistance. Papyrus provides the scaffolding; the LLM fills in content following `SOP.md`.

## 📁 Structure

```
papyrus/
├── SKILL.md              # Skill definition and design decisions
├── SOP.md                # Standard Operating Procedure (mandatory)
├── README.md             # You are here
├── LICENSE               # MIT
├── SCRIPTS/
│   ├── run.sh            # Main entry point
│   ├── fetch_arxiv.sh    # Download arXiv LaTeX source
│   ├── render_formulas.sh # Render LaTeX → PNG
│   ├── build_html.py     # Build annotated HTML skeleton
│   └── build_pdf.sh      # HTML → PDF via WeasyPrint
├── TEMPLATES/
│   └── paper.html        # Kami-styled HTML template
└── PROMPTS/
    └── qc_checklist.md    # Three-round quality control
```

## 🔧 Dependencies

- **Python 3.10+** — `weasyprint`, `pypdf`, `Pillow`, `requests`
- **bash** — standard Unix tools
- **Internet** — codecogs.com for formula rendering, arXiv for paper downloads

Install Python dependencies:
```bash
pip3 install weasyprint pypdf Pillow requests
```

## 🎨 Design Philosophy

- **No scaling, no blur.** Formula images use native 150 DPI resolution with `max-width:100%; height:auto`. Never upscale.
- **Visible structure.** Formula blocks have a wireframe box to visually separate math from text.
- **Three-layer depth.** Each paragraph: original English → Chinese translation → expert commentary.
- **Defensive figure mapping.** Always verify figure-to-file mapping from arXiv HTML source. Never guess.

## 📚 Example Output

See `examples/` for a complete output: "Attention Is All You Need — Annotated Deep-Read" (38 pages, bilingual, 7 formulas, 5 figures).

## 🤝 Contributing

Found a rendering bug? Have a paper that Papyrus struggles with? Open an issue with:
1. The paper URL
2. A description of the problem
3. Screenshots of the issue

## 📄 License

MIT — see [LICENSE](LICENSE).

---

*Papyrus was born from the observation that reading academic papers shouldn't require fighting with layout engines. One session with "Attention Is All You Need" produced enough learnings to codify the entire pipeline.*

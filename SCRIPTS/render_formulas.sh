#!/usr/bin/env bash
# render_formulas.sh — Render LaTeX formulas to PNG via codecogs.com
#
# Usage: ./render_formulas.sh <formulas.txt> <output_dir>
# formulas.txt format: one LaTeX formula per line
#   Lines starting with # are comments
#   Lines starting with @ are captions (attached to next formula)

set -euo pipefail

FORMULAS_FILE="${1:-}"
OUTPUT_DIR="${2:-/tmp/papyrus_formulas}"

if [ -z "$FORMULAS_FILE" ] || [ ! -f "$FORMULAS_FILE" ]; then
    echo "Usage: $0 <formulas.txt> <output_dir>"
    echo ""
    echo "formulas.txt format (one formula per line):"
    echo "  @name=formula1_attention @caption=缩放点积注意力"
    echo "  \\displaystyle \\mathrm{Attention}(Q,K,V)=\\mathrm{softmax}\\left(\\frac{QK^{\\mathrm{T}}}{\\sqrt{d_{k}}}\\right)V"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "🔢 Rendering LaTeX formulas via codecogs.com"
echo ""

INDEX=0
cat "$FORMULAS_FILE" | while IFS= read -r line; do
    # Skip comments and empty lines
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "$line" ]] && continue

    # Check for @name directive
    if [[ "$line" =~ ^@name=([^[:space:]]+) ]]; then
        NAME="${BASH_REMATCH[1]}"
        continue
    fi

    # Skip comment-only lines
    [[ "$line" =~ ^[[:space:]]*$ ]] && continue

    # Render the formula
    INDEX=$((INDEX + 1))
    SAFE_NAME="${NAME:-formula_${INDEX}}"

    # Build codecogs URL with dpi=150
    ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('${line}'))")
    URL="https://latex.codecogs.com/png.image?${ENCODED}"

    echo "  [${SAFE_NAME}] ${line:0:60}..."
    python3 -c "
import urllib.request, sys
req = urllib.request.Request('${URL}', headers={'User-Agent': 'Mozilla/5.0'})
try:
    resp = urllib.request.urlopen(req, timeout=15)
    data = resp.read()
    with open('${OUTPUT_DIR}/${SAFE_NAME}.png', 'wb') as f:
        f.write(data)
    from PIL import Image
    img = Image.open('${OUTPUT_DIR}/${SAFE_NAME}.png')
    print(f'    → {img.size[0]}×{img.size[1]} px, {len(data)} bytes')
except Exception as e:
    print(f'    ✗ ERROR: {e}', file=sys.stderr)
"

    NAME=""  # Reset for next formula
done

echo ""
echo "✅ Formulas rendered to: $OUTPUT_DIR"

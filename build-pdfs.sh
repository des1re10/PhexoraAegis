#!/usr/bin/env bash
#
# Phexora Aegis - PDF Build Script
# Converts active root-level Markdown papers to PDF using DocWizard-Pro
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCWIZARD_ROOT="$(dirname "$SCRIPT_DIR")/DocWizard-Pro"
DOCWIZARD_SCRIPT="$DOCWIZARD_ROOT/Src/universal_converter.py"
DOCWIZARD_PYTHON="$DOCWIZARD_ROOT/.venv/bin/python"
PAPERS_DIR="$SCRIPT_DIR/papers/zkprivacy"

echo "================================================"
echo "  Phexora Aegis - PDF Build Script"
echo "================================================"
echo ""

# Check if DocWizard-Pro exists
if [ ! -f "$DOCWIZARD_SCRIPT" ]; then
    echo "ERROR: DocWizard-Pro not found at: $DOCWIZARD_SCRIPT"
    echo "       Make sure DocWizard-Pro is in the same parent directory as Phexora Aegis"
    exit 1
fi

if [ ! -x "$DOCWIZARD_PYTHON" ]; then
    echo "ERROR: DocWizard-Pro Python runtime not found at: $DOCWIZARD_PYTHON"
    echo "       Prepare the DocWizard-Pro .venv before building Phexora Aegis PDFs"
    exit 1
fi

# Check if Pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo "ERROR: Pandoc is not installed"
    echo "       Install from: https://pandoc.org/installing.html"
    exit 1
fi

shopt -s nullglob
PAPER_SOURCES=("$PAPERS_DIR"/*.md)

if [ "${#PAPER_SOURCES[@]}" -eq 0 ]; then
    echo "ERROR: No active Markdown papers found in: $PAPERS_DIR"
    exit 1
fi

echo "Building ${#PAPER_SOURCES[@]} active paper PDF(s)..."
echo ""

paper_index=0
for paper_source in "${PAPER_SOURCES[@]}"; do
    paper_index=$((paper_index + 1))
    paper_name="$(basename "$paper_source" .md)"
    paper_pdf="$PAPERS_DIR/$paper_name.pdf"

    echo "[$paper_index/${#PAPER_SOURCES[@]}] Converting $paper_name.md..."
    "$DOCWIZARD_PYTHON" "$DOCWIZARD_SCRIPT" "$paper_source" "$paper_pdf"
    echo "      Done: $paper_name.pdf"
done

echo ""
echo "================================================"
echo "  Build complete!"
echo "  PDFs generated in: $PAPERS_DIR"
echo "================================================"

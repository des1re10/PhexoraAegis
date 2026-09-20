#!/bin/bash
#
# Phexora Aegis - Local Development Server
# Quick start script for testing the website locally
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PAPERS_DIR="$SCRIPT_DIR/papers/zkprivacy"
LIBRARIES_PYTHON="$SCRIPT_DIR/../Libraries/Python"
PORT="${1-}"

if [ -z "$PORT" ]; then
    if [ ! -d "$LIBRARIES_PYTHON" ]; then
        echo "ERROR: Shared application registry directory not found at: $LIBRARIES_PYTHON" >&2
        exit 1
    fi

    PORT="$(PYTHONPATH="$LIBRARIES_PYTHON" python3 - <<'PY'
from ApplicationRegistry import get_application

config = get_application("aegis")
if config is None:
    raise RuntimeError("Phexora Aegis is missing from ApplicationRegistry")
if config.local_preview_port is None:
    raise RuntimeError("Phexora Aegis local_preview_port is not configured")
print(config.local_preview_port)
PY
)"
fi

if ! [[ "$PORT" =~ ^[0-9]{1,5}$ ]] || (( 10#$PORT < 1 || 10#$PORT > 65535 )); then
    echo "ERROR: Preview port must be an integer between 1 and 65535; received: $PORT" >&2
    exit 1
fi

cd "$SCRIPT_DIR"

echo "================================================"
echo "  Phexora Aegis - Privacy, Scalability and Post-Quantum Security Research"
echo "  Local Development Server"
echo "================================================"
echo ""

# Function to check if PDF needs rebuild
needs_rebuild() {
    local md_file="$1"
    local pdf_file="$2"

    # PDF doesn't exist
    if [ ! -f "$pdf_file" ]; then
        return 0
    fi

    # MD is newer than PDF
    if [ "$md_file" -nt "$pdf_file" ]; then
        return 0
    fi

    return 1
}

# Check if PDFs need to be built
REBUILD_NEEDED=false

shopt -s nullglob
PAPER_SOURCES=("$PAPERS_DIR"/*.md)

if [ "${#PAPER_SOURCES[@]}" -eq 0 ]; then
    echo "ERROR: No active Markdown papers found in: $PAPERS_DIR"
    exit 1
fi

for paper_source in "${PAPER_SOURCES[@]}"; do
    if needs_rebuild "$paper_source" "${paper_source%.md}.pdf"; then
        REBUILD_NEEDED=true
        break
    fi
done

# Auto-generate PDFs if needed
if [ "$REBUILD_NEEDED" = true ]; then
    echo "PDFs missing or outdated. Building automatically..."
    echo ""

    if [ ! -x "$SCRIPT_DIR/build-pdfs.sh" ]; then
        echo "ERROR: Executable PDF build script not found at: $SCRIPT_DIR/build-pdfs.sh"
        exit 1
    fi

    if ! "$SCRIPT_DIR/build-pdfs.sh"; then
        echo ""
        echo "ERROR: PDF generation failed; local preview was not started"
        exit 1
    fi

    echo ""
else
    echo "PDFs are up to date."
    echo ""
fi

echo "Starting local web server..."
echo "URL: http://127.0.0.1:$PORT"
echo "Press Ctrl+C to stop"
echo ""

exec python3 -m http.server "$PORT" --bind 127.0.0.1

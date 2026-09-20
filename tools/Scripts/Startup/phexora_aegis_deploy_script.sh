#!/bin/bash

# ============================================================================
# Phexora Aegis - Server Deployment Script
# ============================================================================
# Deploys static documentation website from pCloud to web server
# Uses shared deployment infrastructure for consistency with other projects
#
# Usage: ./phexora_aegis_deploy_script.sh
# ============================================================================

# Fix own line endings first (handles Windows CRLF -> Unix LF)
# IMPORTANT: Properly resolve symlinks to avoid overwriting shortcuts in ~/Desktop/Run scripts/
SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_REAL_PATH=""
if [ -L "$SCRIPT_PATH" ]; then
    # Script is being run via symlink - resolve to actual file
    SCRIPT_REAL_PATH=$(readlink -f "$SCRIPT_PATH" 2>/dev/null)
    if [ -z "$SCRIPT_REAL_PATH" ] || [ ! -f "$SCRIPT_REAL_PATH" ]; then
        # Could not resolve symlink - skip sed to avoid destroying the symlink
        echo "Note: Running via symlink, skipping CRLF fix on script itself"
    else
        sed -i 's/\r$//' "$SCRIPT_REAL_PATH" 2>/dev/null || true
    fi
else
    # Not a symlink, safe to modify directly
    sed -i 's/\r$//' "$SCRIPT_PATH" 2>/dev/null || true
fi

# Ensure all messages and errors are displayed (with function error propagation)
set -eE
set -o pipefail
if [ -n "${SCRIPT_REAL_PATH:-}" ] && [ -f "$SCRIPT_REAL_PATH" ]; then
    SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_REAL_PATH")" >/dev/null 2>&1 && pwd)"
else
    SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_PATH")" >/dev/null 2>&1 && pwd)"
fi
AEGIS_OUTPUT_FILE=""

# Determine the system type
SYSTEM=$(uname -s)

# Set path variables for different systems
if [[ "$SYSTEM" == "Linux" ]]; then
    if grep -q "microsoft" /proc/version; then
        # WSL - not supported for deployment
        echo "ERROR: This script must run on the Linux server, not WSL"
        exit 1
    else
        # Linux server - pCloud mounted
        SOURCE_BASE="$HOME/pCloudDrive/Crypto Folder/Phexora Aegis Sources/Phexora Aegis"
        HOME_BASE="$HOME"
    fi
elif [[ "$SYSTEM" == "Darwin" ]]; then
    # Mac path
    SOURCE_BASE="$HOME/pCloudDrive/Crypto Folder/Phexora Aegis Sources/Phexora Aegis"
    HOME_BASE="$HOME"
else
    echo "Unsupported system type: $SYSTEM"
    exit 1
fi

if [ -n "${SOURCE_BASE_OVERRIDE:-}" ]; then
    SOURCE_BASE="$SOURCE_BASE_OVERRIDE"
fi

echo "================================================"
echo "  Phexora Aegis - Server Deployment"
echo "================================================"
echo ""
echo "Source directory: $SOURCE_BASE"

# Shared deployment tooling is owned by AppManager's installed Libraries checkout.
# Centralized/archive deployment supplies an isolated verified copy through
# LOCAL_DEPLOY_SCRIPTS_DIR.
if [ -z "${LOCAL_DEPLOY_SCRIPTS_DIR:-}" ]; then
    LOCAL_DEPLOY_SCRIPTS_DIR="$HOME/AppManager/Libraries/Scripts"
fi
export LOCAL_DEPLOY_SCRIPTS_DIR

SHARED_DEPLOY_SCRIPT="$LOCAL_DEPLOY_SCRIPTS_DIR/deploy_common.sh"
SHARED_FUNCTIONS_SCRIPT="$LOCAL_DEPLOY_SCRIPTS_DIR/deploy_functions.sh"
for required_tool in \
    "$SHARED_DEPLOY_SCRIPT" \
    "$SHARED_FUNCTIONS_SCRIPT" \
    "$LOCAL_DEPLOY_SCRIPTS_DIR/common_functions.sh" \
    "$LOCAL_DEPLOY_SCRIPTS_DIR/setup_subdomain_ssl.sh" \
    "$LOCAL_DEPLOY_SCRIPTS_DIR/validate_deployment_manifest.py"; do
    if [ ! -f "$required_tool" ]; then
        echo "ERROR: Required shared deployment tool is missing: $required_tool"
        exit 1
    fi
done

# Make sure the shared scripts are executable
chmod +x "$SHARED_DEPLOY_SCRIPT"

# Source shared functions.
chmod +x "$SHARED_FUNCTIONS_SCRIPT"
sed -i 's/\r$//' "$SHARED_FUNCTIONS_SCRIPT" 2>/dev/null || true
source "$SHARED_FUNCTIONS_SCRIPT"
echo "Using shared deployment functions"

# Ask for the deployment target (or use AUTO_DEPLOY_SERVER)
if [ "$AUTO_DEPLOY" == "1" ]; then
    DEPLOY_TARGET="${AUTO_DEPLOY_SERVER:-main}"
    echo "[AUTO_DEPLOY] Deployment target: $DEPLOY_TARGET"
else
    while true; do
        echo "Do you want to deploy to the test server or the main server? (test/main)"
        read DEPLOY_TARGET

        if [ "$DEPLOY_TARGET" == "main" ] || [ "$DEPLOY_TARGET" == "test" ]; then
            break
        else
            echo "Invalid input. Please enter 'test' or 'main'."
        fi
    done
fi

# Set paths based on deployment target
if [ "$DEPLOY_TARGET" == "main" ]; then
    TARGET_DIR="$HOME_BASE/PhexoraAegis/PhexoraAegis"
    WEB_ROOT="/var/www/phexora-aegis"
    DOMAIN="aegis.phexora.ai"
    echo "Deploying to MAIN server: $WEB_ROOT"
else
    TARGET_DIR="$HOME_BASE/PhexoraAegisTest/PhexoraAegis"
    WEB_ROOT="/var/www/phexora-aegis-test"
    DOMAIN="test.aegis.phexora.ai"
    echo "Deploying to TEST server: $WEB_ROOT"
fi

# Verify source directory exists
if [ ! -d "$SOURCE_BASE" ]; then
    echo "ERROR: Source directory not found!"
    echo "Expected: $SOURCE_BASE"
    echo ""
    echo "Please ensure:"
    echo "1. pCloud is running and mounted"
    echo "2. Files were synced from Windows (deploy_testing.bat)"
    keep_terminal_open
    exit 1
fi

# Check sudo availability
if [ "$AUTO_DEPLOY" == "1" ]; then
    if ! require_noninteractive_sudo_access; then
        echo "ERROR: Static auto-deployment cannot publish without sudo access"
        exit 1
    fi
else
    echo ""
    echo "This script requires sudo privileges for:"
    echo "  - Copying files to $WEB_ROOT"
    echo "  - Configuring Nginx"
    echo ""
    echo "Testing sudo access..."
    if ! sudo -v; then
        echo "ERROR: Cannot obtain sudo privileges"
        keep_terminal_open
        exit 1
    fi
    echo "Sudo access confirmed."
fi

# Verify required files exist
echo ""
echo "Verifying source files..."
REQUIRED_FILES=("index.html" "assets" "papers" "LICENSE")
MISSING_FILES=0

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$SOURCE_BASE/$file" ] && [ ! -d "$SOURCE_BASE/$file" ]; then
        echo "  Missing: $file"
        MISSING_FILES=1
    else
        echo "  Found: $file"
    fi
done

# These Markdown papers are public website assets, not repository-only
# documentation. Refuse an incomplete archive instead of reporting a
# successful publication with missing or stale research pages.
PUBLIC_MARKDOWN_FILES=(
    "papers/zkprivacy/decisions/decentralisation-operability-security-budget-decision.md"
    "papers/zkprivacy/decisions/t305-prior-art-decision.md"
    "papers/zkprivacy/quantum-private-transaction-feasibility.md"
    "papers/zkprivacy/templates/README.md"
    "papers/zkprivacy/templates/ghostdag-private-state-template.md"
    "papers/zkprivacy/templates/network-origin-anonymity-template.md"
    "papers/zkprivacy/templates/private-note-discovery-template.md"
    "papers/zkprivacy/zkprivacy-quantum-spec-v1.md"
    "papers/zkprivacy/zkprivacy-verification-guide.md"
)
for markdown_file in "${PUBLIC_MARKDOWN_FILES[@]}"; do
    if [ -f "$SOURCE_BASE/$markdown_file" ]; then
        echo "  Found: $markdown_file"
    else
        echo "  Missing: $markdown_file"
        MISSING_FILES=1
    fi
done

if [ $MISSING_FILES -eq 1 ]; then
    echo ""
    echo "ERROR: Required files missing from source directory"
    echo "Please sync files from Windows first (deploy_testing.bat)"
    keep_terminal_open
    exit 1
fi

echo ""
echo "=== Deployment Configuration ==="
echo "Source: $SOURCE_BASE"
echo "Target Project: $TARGET_DIR"
echo "Shared Libraries payload: not applicable (Phexora Aegis is a static non-consumer)"
echo "Web Root: $WEB_ROOT"
echo "Domain: $DOMAIN"
echo ""

# Final confirmation
if [ "$AUTO_DEPLOY" == "1" ]; then
    CONFIRM="y"
    echo "[AUTO_DEPLOY] Confirmation: auto-confirmed"
else
    echo "Ready to deploy. Continue? (y/n)"
    read CONFIRM

    if [ "$CONFIRM" != "y" ]; then
        echo "Deployment cancelled."
        keep_terminal_open
        exit 0
    fi
fi

echo ""

# === Create directories if needed ===
echo "[1/5] Setting up directories..."
mkdir -p "$TARGET_DIR" 2>/dev/null || true
sudo mkdir -p "$WEB_ROOT"
echo "  Directories ready (including web root)"

# === Deploy Phexora Aegis using shared script ===
echo ""
echo "=== Deploying Phexora Aegis ==="
AEGIS_OUTPUT_FILE="$(mktemp)"
register_deploy_temp_file "$AEGIS_OUTPUT_FILE"
bash "$SHARED_DEPLOY_SCRIPT" \
    "PhexoraAegis" \
    "$SOURCE_BASE" \
    "$TARGET_DIR" \
    "$DEPLOY_TARGET" \
    "n" 2>&1 | tee "$AEGIS_OUTPUT_FILE"
AEGIS_OUTPUT=$(<"$AEGIS_OUTPUT_FILE")
rm -f "$AEGIS_OUTPUT_FILE"
unregister_deploy_temp_file "$AEGIS_OUTPUT_FILE"
AEGIS_OUTPUT_FILE=""

echo "  Verifying deployed site files..."
for required_path in "index.html" "assets" "papers" "LICENSE"; do
    if [ ! -e "$TARGET_DIR/$required_path" ]; then
        echo "ERROR: Required deployment output missing: $TARGET_DIR/$required_path"
        exit 1
    fi
done
for markdown_file in "${PUBLIC_MARKDOWN_FILES[@]}"; do
    if [ ! -f "$TARGET_DIR/$markdown_file" ]; then
        echo "ERROR: Required public paper missing from deployment output: $TARGET_DIR/$markdown_file"
        exit 1
    fi
done

# === Copy to web root (Phexora Aegis-specific: static website served by nginx) ===
echo ""
echo "[2/5] Deploying to web root..."
echo "  Deploying to web root: $WEB_ROOT"
# Copy to temp directory first (pCloud FUSE doesn't allow root access)
TEMP_DIR=$(mktemp -d)
cp "$TARGET_DIR/index.html" "$TEMP_DIR/"
cp "$TARGET_DIR/LICENSE" "$TEMP_DIR/"
cp -r "$TARGET_DIR/assets" "$TEMP_DIR/"
cp -r "$TARGET_DIR/papers" "$TEMP_DIR/"

# Remove existing files/directories to allow clean replacement
sudo rm -f "$WEB_ROOT/index.html"
sudo rm -f "$WEB_ROOT/LICENSE"
sudo rm -rf "$WEB_ROOT/assets"
sudo rm -rf "$WEB_ROOT/papers"

# Move from temp to web root with sudo
sudo mv "$TEMP_DIR/index.html" "$WEB_ROOT/"
sudo mv "$TEMP_DIR/LICENSE" "$WEB_ROOT/"
sudo mv "$TEMP_DIR/assets" "$WEB_ROOT/"
sudo mv "$TEMP_DIR/papers" "$WEB_ROOT/"
rmdir "$TEMP_DIR"

verify_published_path "$TARGET_DIR/index.html" "$WEB_ROOT/index.html"
verify_published_path "$TARGET_DIR/LICENSE" "$WEB_ROOT/LICENSE"
verify_published_path "$TARGET_DIR/assets" "$WEB_ROOT/assets"
verify_published_path "$TARGET_DIR/papers" "$WEB_ROOT/papers"
for markdown_file in "${PUBLIC_MARKDOWN_FILES[@]}"; do
    verify_published_path \
        "$TARGET_DIR/$markdown_file" \
        "$WEB_ROOT/$markdown_file"
done
echo "  ✓ Web root deployment complete"

# Validate sync manifest
MANIFEST_FILE="$TARGET_DIR/deployment_sync_manifest.json"
validate_sync_manifest "$MANIFEST_FILE"

read -r AEGIS_ITEMS AEGIS_FILES <<< "$(parse_deployment_counts "$AEGIS_OUTPUT")"
display_app_only_deployment_summary \
    "Phexora Aegis" \
    "$AEGIS_OUTPUT" \
    "$AEGIS_ITEMS" \
    "$AEGIS_FILES"

# Cleanup source manifests
if should_cleanup_source_manifests; then
    cleanup_source_manifests "$SOURCE_BASE" ""
fi

# === Set permissions ===
echo "[3/5] Setting permissions..."
sudo chown -R www-data:www-data "$WEB_ROOT"
sudo chmod -R 755 "$WEB_ROOT"
sudo chmod 644 "$WEB_ROOT/index.html"
sudo chmod 644 "$WEB_ROOT/LICENSE"
echo "  Web root permissions set"

# Set permissions on home directory files
chmod 644 "$TARGET_DIR/index.html" 2>/dev/null || true
chmod 644 "$TARGET_DIR/LICENSE" 2>/dev/null || true
chmod -R 755 "$TARGET_DIR/assets" 2>/dev/null || true
chmod -R 755 "$TARGET_DIR/papers" 2>/dev/null || true
echo "  Home directory permissions set"

# === Count deployed files ===
echo "[4/5] Verifying deployment..."
HOME_FILE_COUNT=$(find "$TARGET_DIR" -type f 2>/dev/null | wc -l)
echo "  Deployed $HOME_FILE_COUNT files to $TARGET_DIR"

WEB_FILE_COUNT=$(find "$WEB_ROOT" -type f 2>/dev/null | wc -l)
echo "  Deployed $WEB_FILE_COUNT files to $WEB_ROOT"

# === Run startup script for nginx/SSL setup ===
echo "[5/5] Running startup script for nginx configuration..."
STARTUP_SCRIPT="$TARGET_DIR/tools/Scripts/Startup/run_phexora_aegis.sh"
if [ ! -f "$STARTUP_SCRIPT" ]; then
    echo "ERROR: Required startup script not found: $STARTUP_SCRIPT"
    exit 1
fi
chmod +x "$STARTUP_SCRIPT"
sed -i 's/\r$//' "$STARTUP_SCRIPT" 2>/dev/null || true

if [ "$AUTO_DEPLOY" == "1" ]; then
    AUTO_DEPLOY=1 DEPLOY_TARGET="$DEPLOY_TARGET" HAS_PASSWORDLESS_SUDO=1 "$STARTUP_SCRIPT"
else
    "$STARTUP_SCRIPT"
fi

# === Deployment complete ===
echo ""
echo "================================================"
echo "  Deployment COMPLETE"
echo "================================================"
echo ""
echo "Files deployed to home: $TARGET_DIR ($HOME_FILE_COUNT files)"
echo "Files deployed to web root: $WEB_ROOT ($WEB_FILE_COUNT files)"
echo ""
if [ "$DEPLOY_TARGET" == "test" ]; then
    echo "Test site: http://$DOMAIN (or https:// if SSL configured)"
else
    echo "Production site: https://$DOMAIN"
fi

echo ""
echo "NEXT STEPS:"
echo "=============="
if [ "$DEPLOY_TARGET" == "test" ]; then
    echo "1. Verify test site at http://$DOMAIN"
    echo "2. Check nginx logs: sudo tail -20 /var/log/nginx/aegis_error.log"
else
    echo "1. Verify site at https://$DOMAIN"
    echo "2. Check all papers load correctly"
fi

# Cleanup prompts
prompt_source_cleanup "$SOURCE_BASE" ""

echo ""
echo "For nginx/SSL updates without redeploying files:"
echo "  $STARTUP_SCRIPT"

# Display manifest summary
echo ""
display_manifest_summary "$MANIFEST_VALIDATION_RESULT"

echo ""
echo "Deployment completed successfully."

# Only keep terminal open in interactive mode
if [ "$AUTO_DEPLOY" != "1" ]; then
    keep_terminal_open
fi

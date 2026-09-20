#!/bin/bash

#
# Phexora Aegis - Startup Script
# Sets up nginx, maintenance page, and SSL for static documentation website
# Uses shared common_functions.sh library
#

# ============================================================================
# PROJECT CONFIGURATION
# ============================================================================
PROJECT_NAME="Phexora Aegis"

# Resolve paths dynamically from script location
# Use readlink -f to properly resolve symlinks (e.g., when run from ~/Desktop/Run scripts/)
SCRIPT_PATH="${BASH_SOURCE[0]}"
if [ -L "$SCRIPT_PATH" ]; then
    SCRIPT_DIR="$(dirname "$(readlink -f "$SCRIPT_PATH")")"
else
    SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
fi
# Script is in tools/Scripts/Startup/, so project root is 3 levels up
PROJECT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
if [ -n "${LOCAL_DEPLOY_SCRIPTS_DIR:-}" ]; then
    SHARED_SCRIPTS_DIR="$LOCAL_DEPLOY_SCRIPTS_DIR"
else
    SHARED_SCRIPTS_DIR="$HOME/AppManager/Libraries/Scripts"
fi

# Determine deployment target from environment or default to main
DEPLOY_TARGET="${DEPLOY_TARGET:-main}"
PRODUCTION_DOMAIN="aegis.phexora.ai"
TEST_WEB_ROOT="/var/www/phexora-aegis-test"

if [ "$DEPLOY_TARGET" = "main" ]; then
    DOMAIN="$PRODUCTION_DOMAIN"
    NGINX_CONFIG_NAME="phexora-aegis.conf"
    NGINX_SSL_SESSION_CACHE_NAME="AegisTLS"
    MAINTENANCE_PAGE="/var/www/html/maintenance_aegis.html"
    MAINTENANCE_PAGE_FILENAME="maintenance_aegis.html"
elif [ "$DEPLOY_TARGET" = "test" ]; then
    DOMAIN="test.aegis.phexora.ai"
    NGINX_CONFIG_NAME="phexora-aegis-test.conf"
    NGINX_SSL_SESSION_CACHE_NAME="AegisTestTLS"
    MAINTENANCE_PAGE="/var/www/html/maintenance_aegis_test.html"
    MAINTENANCE_PAGE_FILENAME="maintenance_aegis_test.html"
else
    echo "FATAL: DEPLOY_TARGET must be main or test, got: $DEPLOY_TARGET"
    exit 1
fi

SITEBUILDER_PUBLICATION_ROOT_HELPER="$SHARED_SCRIPTS_DIR/static_sitebuilder_publication_root.sh"
if [ ! -f "$SITEBUILDER_PUBLICATION_ROOT_HELPER" ]; then
    echo "FATAL: shared SiteBuilder publication helper not found at $SITEBUILDER_PUBLICATION_ROOT_HELPER"
    exit 1
fi
sed -i 's/\r$//' "$SITEBUILDER_PUBLICATION_ROOT_HELPER" 2>/dev/null || true
source "$SITEBUILDER_PUBLICATION_ROOT_HELPER"
if ! WEB_ROOT="$(resolve_sitebuilder_static_web_root "$DEPLOY_TARGET" "$PRODUCTION_DOMAIN" "$TEST_WEB_ROOT")"; then
    exit 1
fi

NGINX_SITES_AVAILABLE="/etc/nginx/sites-available"
NGINX_SITES_ENABLED="/etc/nginx/sites-enabled"
SSL_CERT="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"
SSL_KEY="/etc/letsencrypt/live/$DOMAIN/privkey.pem"

# Fix own line endings (handles Windows CRLF -> Unix LF)
sed -i 's/\r$//' "$PROJECT_DIR/tools/Scripts/Startup/$(basename "$0")" 2>/dev/null || true

echo "================================================"
echo "  $PROJECT_NAME - Startup ($DEPLOY_TARGET server)"
echo "================================================"
echo ""
echo "Working from: $PROJECT_DIR"
echo "Web root: $WEB_ROOT"
echo "Domain: $DOMAIN"

# ============================================================================
# LOAD COMMON FUNCTIONS (REQUIRED)
# ============================================================================
COMMON_FUNCTIONS="$SHARED_SCRIPTS_DIR/common_functions.sh"

if [ ! -f "$COMMON_FUNCTIONS" ]; then
    echo "FATAL: common_functions.sh not found at $COMMON_FUNCTIONS"
    exit 1
fi
sed -i 's/\r$//' "$COMMON_FUNCTIONS" 2>/dev/null || true
source "$COMMON_FUNCTIONS"

# ============================================================================
# SET TERMINAL WINDOW TITLE (for Ubuntu window overview hover identification)
# ============================================================================
set_terminal_title "$PROJECT_NAME - $DEPLOY_TARGET Startup"

# ============================================================================
# SUDO AUTHENTICATION
# ============================================================================
setup_sudo_auth
_setup_exit_trap

# ============================================================================
# CLEAR PYTHON BYTECODE CACHE
# ============================================================================
clear_python_cache

# Define sudo wrapper function - uses -A flag with common_functions
run_sudo() {
    sudo -A "$@"
}

# ============================================================================
# VERIFY WEB ROOT EXISTS
# ============================================================================
echo ""
echo "[1/6] Verifying web root..."

if [ ! -d "$WEB_ROOT" ]; then
    echo "  Creating web root directory..."
    run_sudo mkdir -p "$WEB_ROOT"
fi

if [ ! -f "$WEB_ROOT/index.html" ]; then
    echo "  WARNING: index.html not found in $WEB_ROOT"
    echo "  Run the deploy script first to copy website files."
else
    echo "  Web root OK: $WEB_ROOT"
fi

# ============================================================================
# CREATE MAINTENANCE PAGE
# ============================================================================
echo ""
echo "[2/6] Setting up maintenance page..."

if [ ! -f "$MAINTENANCE_PAGE" ]; then
    run_sudo tee "$MAINTENANCE_PAGE" > /dev/null << 'MAINTEOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phexora Aegis - Maintenance</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: #0a0a0f;
            color: #e8e8f0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 2rem;
        }
        .container {
            max-width: 500px;
            background: #1a1a24;
            padding: 3rem;
            border-radius: 12px;
            border: 1px solid #2a2a3a;
        }
        .logo {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border-radius: 12px;
            font-weight: 700;
            font-size: 1.5rem;
            color: white;
            margin-bottom: 1.5rem;
        }
        h1 {
            font-size: 1.5rem;
            letter-spacing: -0.02em;
            margin-bottom: 1rem;
            color: #e8e8f0;
        }
        p {
            font-size: 1rem;
            line-height: 1.6;
            color: #a0a0b0;
            margin-bottom: 1rem;
        }
        .spinner {
            margin: 2rem auto;
            width: 40px;
            height: 40px;
            border: 3px solid #2a2a3a;
            border-top-color: #6366f1;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">A</div>
        <h1>Updating Documentation</h1>
        <p>The site is being updated with new research papers.</p>
        <p>Please check back in a moment.</p>
        <div class="spinner"></div>
    </div>
    <script>setTimeout(function() { location.reload(); }, 10000);</script>
</body>
</html>
MAINTEOF
    run_sudo chmod 644 "$MAINTENANCE_PAGE"
    echo "  Maintenance page created"
else
    echo "  Maintenance page exists"
fi

# ============================================================================
# CHECK SSL CERTIFICATE (using DNS challenge for NoIP)
# ============================================================================
echo ""
echo "[3/6] Rendering shared SSL/nginx configuration..."

SSL_SETUP_SCRIPT="$SHARED_SCRIPTS_DIR/setup_subdomain_ssl.sh"
if [ ! -f "$SSL_SETUP_SCRIPT" ]; then
    echo "FATAL: shared SSL/nginx setup script not found at $SSL_SETUP_SCRIPT"
    exit 1
fi
sed -i 's/\r$//' "$SSL_SETUP_SCRIPT" 2>/dev/null || true
chmod +x "$SSL_SETUP_SCRIPT"

AEGIS_NGINX_EXTRA="$(mktemp)"
cat > "$AEGIS_NGINX_EXTRA" << EOF
    # Static site logging
    root $WEB_ROOT;
    index index.html;
    access_log /var/log/nginx/aegis_access.log;
    error_log /var/log/nginx/aegis_error.log;
    add_header X-XSS-Protection "1; mode=block" always;

    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot|pdf)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Papers (Markdown files) - serve with correct content type
    location /papers/ {
        expires 1d;
        types {
            text/markdown md;
        }
        default_type text/markdown;
    }

    # Deny access to hidden files
    location ~ /\. {
        deny all;
    }
EOF

if ! ALLOW_HTTP_ONLY_NGINX=1 \
    ENABLE_MAINTENANCE_MODE=1 \
    MAINTENANCE_FLAG="${MAINTENANCE_PAGE%.html}_mode" \
    MAINTENANCE_PAGE="$MAINTENANCE_PAGE" \
    NGINX_SITE_NAME="$NGINX_CONFIG_NAME" \
    NGINX_SERVER_NAMES="$DOMAIN" \
    NGINX_SSL_SESSION_CACHE_NAME="$NGINX_SSL_SESSION_CACHE_NAME" \
    NGINX_STATIC_ROOT_TRY_FILES="\$uri \$uri/ =404" \
    NGINX_ENABLE_STANDARD_API=0 \
    NGINX_ENABLE_STANDARD_WS=0 \
    NGINX_ENABLE_HEALTH_LOCATION=0 \
    NGINX_EXTRA_SERVER_CONFIG_FILE="$AEGIS_NGINX_EXTRA" \
    "$SSL_SETUP_SCRIPT" --skip-if-valid "${DOMAIN%%.phexora.ai}" phexora.ai 0 "$WEB_ROOT"; then
    rm -f "$AEGIS_NGINX_EXTRA"
    exit 1
fi
rm -f "$AEGIS_NGINX_EXTRA"

cert_valid=false
cert_status="missing"
if run_sudo test -r "$SSL_CERT"; then
    cert_valid=true
    cert_status="valid"
fi

# ============================================================================
# SSL CERTIFICATE MONITOR
# ============================================================================
echo ""
echo "[6/6] Running SSL certificate monitor..."

echo "Checking SSL certificates for expiration..."

_check_ssl_cert_local() {
    local cert_path="$1"
    local cert_name="$2"

    if [ ! -f "$cert_path" ]; then
        return 1
    fi

    local expiry_date expiry_epoch now_epoch days_left
    expiry_date=$(openssl x509 -enddate -noout -in "$cert_path" 2>/dev/null | cut -d= -f2)
    if [ -z "$expiry_date" ]; then
        return 1
    fi

    expiry_epoch=$(date -d "$expiry_date" +%s 2>/dev/null)
    now_epoch=$(date +%s)
    days_left=$(( (expiry_epoch - now_epoch) / 86400 ))

    if [ "$days_left" -lt 0 ]; then
        echo "  EXPIRED: $cert_name"
    elif [ "$days_left" -lt 7 ]; then
        echo "  CRITICAL: $cert_name - $days_left days"
    elif [ "$days_left" -lt 14 ]; then
        echo "  WARNING: $cert_name - $days_left days"
    elif [ "$days_left" -lt 30 ]; then
        echo "  OK: $cert_name - $days_left days"
    else
        echo "  Valid: $cert_name - $days_left days"
    fi
    return 0
}

cert_found=false
if [ -n "${DOMAIN:-}" ]; then
    if [ -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]; then
        _check_ssl_cert_local "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" "$DOMAIN (Let's Encrypt)"
        cert_found=true
    fi
fi

if [ "$cert_found" = false ]; then
    echo "  No SSL certificates found to check"
fi

# ============================================================================
# VERIFY SITE IS ACCESSIBLE
# ============================================================================
echo ""
echo "Verifying site accessibility..."

sleep 2

if ! verify_static_site_web_root_exactly "$WEB_ROOT" "$DOMAIN" "$cert_valid"; then
    exit 1
fi
SITE_URL="$STATIC_SITE_VERIFIED_URL"
echo "  Served index verified exactly via $SITE_URL"

# ============================================================================
# SUMMARY
# ============================================================================
echo ""
echo "=============================================="
echo "  $PROJECT_NAME Startup Complete ($DEPLOY_TARGET)"
echo "=============================================="
echo ""
echo "Web Root: $WEB_ROOT"
echo "Domain: $DOMAIN"
echo "SSL: $cert_status"

if [ "$cert_valid" = true ]; then
    echo "URL: https://$DOMAIN"
else
    echo "URL: http://$DOMAIN"
    echo ""
    echo "To enable HTTPS, run:"
    echo "  sudo certbot --nginx -d $DOMAIN"
fi

echo ""
echo "Logs:"
echo "  Access: /var/log/nginx/aegis_access.log"
echo "  Errors: /var/log/nginx/aegis_error.log"
echo ""
echo "Troubleshooting:"
echo "  - Test nginx: sudo nginx -t"
echo "  - Check status: sudo systemctl status nginx"
echo "  - View errors: sudo tail -20 /var/log/nginx/aegis_error.log"
echo ""

# Only wait in interactive mode
if [ "$AUTO_DEPLOY" != "1" ] && [ -t 0 ]; then
    echo "Press Enter to exit..."
    read
fi

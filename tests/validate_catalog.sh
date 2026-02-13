#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
#  HomeStack Apps — Catalog Validation Script
#  Validates all app definitions for correctness and consistency.
#
#  Usage:
#    ./tests/validate_catalog.sh              # validate all apps
#    APP=jellyfin ./tests/validate_catalog.sh  # validate one app
# ──────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
APPS_DIR="$REPO_ROOT/apps"

PASS=0
FAIL=0
WARN=0

pass() { PASS=$((PASS + 1)); echo "  ✓ $1"; }
fail() { FAIL=$((FAIL + 1)); echo "  ✗ $1"; }
warn() { WARN=$((WARN + 1)); echo "  ! $1"; }

VALID_CATEGORIES="media cloud automation monitoring security servarr other"
REQUIRED_FILES="app.yaml compose.yaml config.env test.yaml"

validate_app() {
    local app_dir="$1"
    local name
    name="$(basename "$app_dir")"

    echo
    echo "── $name ──"

    # Check required files
    for f in $REQUIRED_FILES; do
        if [ -f "$app_dir/$f" ]; then
            pass "$f exists"
        else
            fail "$f missing"
        fi
    done

    # Parse app.yaml
    if [ ! -f "$app_dir/app.yaml" ]; then
        fail "Cannot validate without app.yaml"
        return
    fi

    # Check name matches directory
    local yaml_name
    yaml_name="$(grep '^name:' "$app_dir/app.yaml" | head -1 | awk '{print $2}' | tr -d '"' | tr -d "'")"
    if [ "$yaml_name" = "$name" ]; then
        pass "name: matches directory"
    else
        fail "name: '$yaml_name' does not match directory '$name'"
    fi

    # Check required fields
    for field in display_name description version category port appdata_dirs; do
        if grep -q "^${field}:" "$app_dir/app.yaml"; then
            pass "$field defined"
        else
            fail "$field missing from app.yaml"
        fi
    done

    # Validate category
    local category
    category="$(grep '^category:' "$app_dir/app.yaml" | head -1 | awk '{print $2}' | tr -d '"' | tr -d "'")"
    if echo "$VALID_CATEGORIES" | grep -qw "$category"; then
        pass "category '$category' is valid"
    else
        fail "category '$category' is not valid (expected: $VALID_CATEGORIES)"
    fi

    # Check version consistency between app.yaml and config.env
    if [ -f "$app_dir/config.env" ]; then
        local yaml_version
        yaml_version="$(grep '^version:' "$app_dir/app.yaml" | head -1 | awk '{print $2}' | tr -d '"' | tr -d "'")"

        if grep -q "$yaml_version" "$app_dir/config.env"; then
            pass "version $yaml_version found in config.env"
        else
            warn "version $yaml_version not found in config.env image tags"
        fi

        # Check no secrets in config.env
        if grep -qiE '(password|secret|token|api_key)=' "$app_dir/config.env"; then
            fail "config.env may contain secrets (found password/secret/token/api_key)"
        else
            pass "config.env has no obvious secrets"
        fi
    fi

    # Check compose.yaml has healthcheck
    if [ -f "$app_dir/compose.yaml" ]; then
        if grep -q "healthcheck:" "$app_dir/compose.yaml"; then
            pass "compose.yaml has healthcheck"
        else
            warn "compose.yaml missing healthcheck"
        fi

        # Check compose.yaml uses restart policy
        if grep -q "restart:" "$app_dir/compose.yaml"; then
            pass "compose.yaml has restart policy"
        else
            warn "compose.yaml missing restart policy"
        fi

        # Check for :latest tags
        if grep -qE 'image:.*:latest' "$app_dir/compose.yaml"; then
            fail "compose.yaml uses :latest tag"
        else
            pass "No :latest tags in compose.yaml"
        fi
    fi

    # Check test.yaml has startup_time and health_checks
    if [ -f "$app_dir/test.yaml" ]; then
        if grep -q "startup_time:" "$app_dir/test.yaml"; then
            pass "test.yaml has startup_time"
        else
            fail "test.yaml missing startup_time"
        fi
        if grep -q "health_checks:" "$app_dir/test.yaml"; then
            pass "test.yaml has health_checks"
        else
            fail "test.yaml missing health_checks"
        fi
    fi

    # Check backup_strategy for apps with database-like services
    if [ -f "$app_dir/compose.yaml" ]; then
        if grep -qiE '(postgres|mariadb|mysql|sqlite|redis|mongo)' "$app_dir/compose.yaml"; then
            if grep -q 'backup_strategy: stop' "$app_dir/app.yaml"; then
                pass "backup_strategy: stop (has database)"
            else
                warn "App appears to use a database but backup_strategy is not 'stop'"
            fi
        fi
    fi
}

# ── Main ──

echo "HomeStack Catalog Validator"
echo "=========================="

if [ -n "${APP:-}" ]; then
    # Validate single app
    if [ -d "$APPS_DIR/$APP" ]; then
        validate_app "$APPS_DIR/$APP"
    else
        echo "App not found: $APP"
        exit 1
    fi
else
    # Validate all apps
    for app_dir in "$APPS_DIR"/*/; do
        [ -d "$app_dir" ] || continue
        validate_app "$app_dir"
    done
fi

echo
echo "=========================="
echo "Results: $PASS passed, $FAIL failed, $WARN warnings"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi

# Contributing to HomeStack Apps

Thank you for contributing! This guide walks you through adding a new app or updating an existing one.

## Quick Start

1. **Fork** this repository
2. **Create a branch** from `main` using the naming convention below
3. **Copy** the template: `cp -r TEMPLATE/ apps/your-app/`
4. **Fill in** the four files (see below)
5. **Test** locally with `homestack install your-app`
6. **Submit** a pull request targeting `main`

## Branch Naming

| Prefix | When to use | Example |
|--------|-------------|--------|
| `app/` | Adding a new app | `app/sonarr`, `app/grafana` |
| `update/` | Bumping an existing app version | `update/immich-2.5.0` |
| `fix/` | Fixing an existing app definition | `fix/nextcloud-healthcheck` |

All branches are based on `main` and merge back into `main` via pull request.

## Directory Layout

```
apps/your-app/
├── app.yaml       # App metadata and secrets
├── compose.yaml   # Docker Compose definition
├── config.env     # Public defaults (image tags, ports)
└── test.yaml      # Health check definitions for automated testing
```

## Step-by-Step Guide

### 1. Choose a Name

- Lowercase, no spaces, no special characters
- Must match the directory name exactly
- Examples: `jellyfin`, `nextcloud`, `vaultwarden`

### 2. Fill in `app.yaml`

```yaml
name: your-app                      # matches directory name
display_name: Your App              # human-readable
description: What this app does     # one line
version: 1.2.3                      # pinned upstream version
category: media                     # see categories below
port: 8080                          # host-side web UI port
url: https://example.com            # project homepage
priority: 50                        # start order (10=first, 70=last)
backup_strategy: stop               # "stop" or "live"

networks: []                        # extra Docker networks
appdata_dirs: [your-app]            # persistent data directories
media_dirs: []                      # shared media mounts

secrets:                            # generated into secrets.env
  - key: DB_PASSWORD
    prompt: "Database password"
    generate: true
    length: 32
```

#### Categories

| Category | Use for |
|----------|---------|
| `media` | Streaming, photos, libraries |
| `cloud` | File sync, office, collaboration |
| `automation` | Workflow, scheduling, bots |
| `monitoring` | Uptime, metrics, dashboards |
| `security` | Passwords, VPN, auth |
| `servarr` | Torrents, indexers, *arr stack |
| `other` | Anything else |

#### Secret Fields

| Field | Required | Description |
|-------|----------|-------------|
| `key` | Yes | Environment variable name |
| `prompt` | Yes | Question shown to user during install |
| `generate` | No | `true` to auto-generate a random password |
| `length` | No | Password length (default: 32, alphanumeric) |
| `default` | No | Pre-filled value (user presses Enter to accept) |

### 3. Write `compose.yaml`

Standard Docker Compose format with variable substitution.

**Available variables** (injected by HomeStack):

| Variable | Source | Example |
|----------|--------|---------|
| `${APPDATA}` | homestack.env | `/home/user/homestack/AppData` |
| `${MEDIA}` | homestack.env | `/home/user/homestack/Media` |
| `${PUID}` | homestack.env | `1000` |
| `${PGID}` | homestack.env | `1000` |
| `${TZ}` | homestack.env | `America/New_York` |
| `${YOUR_IMAGE}` | config.env | `org/image:1.2.3` |
| `${YOUR_PORT}` | config.env | `8080` |
| `${DB_PASSWORD}` | secrets.env | `aB3kLm9...` |

**Best practices:**
- Always include a `healthcheck` — HomeStack uses it for `homestack status`
- Use `restart: unless-stopped`
- Mount persistent data under `${APPDATA}/your-app/`
- Reference secrets via `env_file: secrets.env` or individual `${VAR}` entries
- Set `container_name` to the app name for easy debugging

### 4. Write `config.env`

```env
# Pin to a specific version — NEVER use :latest
YOUR_APP_IMAGE=ghcr.io/org/app:1.2.3
YOUR_APP_PORT=8080
```

**Rules:**
- Pin every image to an exact version tag
- No secrets or passwords (use `secrets` in app.yaml instead)
- One variable per line, `KEY=value` format

### 5. Write `test.yaml`

Every app **must** include a `test.yaml` that defines automated health checks. HomeStack uses these to verify the app works after install.

```yaml
startup_time: 30                         # seconds to wait before checking

health_checks:
  - url: "http://localhost:8080/health"  # HTTP endpoint to check
    method: GET                          # optional, default: GET
    expected_status: 200                 # optional, default: 200
    body_contains: "ok"                  # optional, string in response body
    timeout: 10                          # optional, curl timeout in seconds

exec_checks:                             # optional, for database sidecars
  - container: redis
    command: "redis-cli ping"
    expected_output: "PONG"
```

**Fields:**

| Field | Required | Description |
|-------|----------|-------------|
| `startup_time` | Yes | Seconds to wait for containers to become healthy |
| `health_checks` | Yes | List of HTTP endpoints to validate |
| `exec_checks` | No | Commands to run inside containers |

**Tips:**
- Use the same URL as your Docker healthcheck
- Database-backed apps need longer `startup_time` (45-60s)
- Add `exec_checks` for Redis, PostgreSQL, MariaDB sidecars
- HTTPS endpoints use `--insecure` (self-signed certs are fine)

See `TEMPLATE/test.yaml` for a fully annotated example.

### 6. Test Locally

```bash
# Sync the catalog
homestack catalog update

# Install your app
homestack install your-app

# Verify it's running
homestack status your-app

# Check the web UI at http://localhost:<port>

# Clean up
homestack remove your-app
```

### 7. Submit a Pull Request

Use the [PR template](.github/PULL_REQUEST_TEMPLATE.md) and check off all items.

## Updating an Existing App

1. Update `version:` in `app.yaml`
2. Update the image tag in `config.env`
3. Test with `homestack update your-app`
4. Submit a PR with the version bump

## Guidelines

- **One app per PR** — keeps reviews focused
- **Pin versions** — never use `:latest` tags
- **Include healthchecks** — required for status monitoring
- **Document secrets** — use clear `prompt` text
- **Test before submitting** — verify install, status, backup, remove all work
- **Keep it minimal** — only include what's needed for the app to run

## Code of Conduct

Be respectful, helpful, and constructive. We're all building this together.

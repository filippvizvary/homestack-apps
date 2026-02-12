# AGENTS.md — HomeStack Apps Catalog

> Comprehensive context file for AI coding agents working on this repository.

## Project Overview

**homestack-apps** is the community app catalog for [HomeStack](https://github.com/filippvizvary/homestack). It contains self-hosted Docker application definitions that the HomeStack CLI consumes to install, configure, and manage apps.

- **Format:** YAML + Docker Compose + env files (no executable code)
- **License:** MIT (Copyright 2026 Filip Vizvary)
- **Companion repo:** `homestack` — the CLI tool that consumes these definitions
- **10 apps currently defined**

## How HomeStack Consumes This Repo

1. HomeStack clones this repo to `~/.cache/homestack-apps/` via `registry_sync()`
2. On `homestack install <app>`, it reads `apps/<app>/app.yaml` for metadata
3. Copies `compose.yaml` and `config.env` to `installed/<app>/`
4. Generates `secrets.env` based on the `secrets:` block in `app.yaml`
5. Runs `docker compose` with env-file stacking: `homestack.env` → `config.env` → `secrets.env`
6. On `homestack update`, pulls latest catalog, merges config changes, preserves user edits

## Directory Structure

```
homestack-apps/
├── apps/
│   ├── immich/            # Each app has exactly 3 files
│   │   ├── app.yaml       # App manifest (metadata + secrets)
│   │   ├── compose.yaml   # Docker Compose definition
│   │   └── config.env     # Default image tags + config vars
│   ├── jellyfin/
│   ├── jellyseerr/
│   ├── n8n/
│   ├── nextcloud/
│   ├── prowlarr/
│   ├── qbittorrent/
│   ├── radarr/
│   ├── uptimekuma/
│   └── vaultwarden/
├── TEMPLATE/              # Annotated blueprint for new apps
│   ├── app.yaml           # 74 lines, every field documented
│   ├── compose.yaml       # 59 lines, with best-practice comments
│   ├── config.env         # 11 lines, variable naming examples
│   └── test.yaml          # Health check definitions, fully annotated
├── .github/
│   └── PULL_REQUEST_TEMPLATE.md
├── CONTRIBUTING.md
├── README.md
└── LICENSE
```

## The Four-File App Format

Every app consists of exactly four files in `apps/<appname>/`:

### 1. app.yaml — App Manifest

Metadata that HomeStack reads to manage the app lifecycle.

**Complete field reference:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Directory name, lowercase alphanumeric. Must match the folder name. |
| `display_name` | string | Yes | Human-readable name for UI display. |
| `description` | string | Yes | One-line description. |
| `version` | string | Yes | Pinned version tag (must match image tag in config.env). |
| `category` | string | Yes | One of: `media`, `cloud`, `automation`, `monitoring`, `security`, `servarr`, `other` |
| `port` | integer | Yes | Primary host port. HomeStack checks for conflicts before install. |
| `url` | string | No | Project homepage URL. |
| `priority` | integer | No | Start order (lower = starts first). Ranges: 10-20 databases, 30-50 core apps, 60-80 secondary. Default: 50. |
| `networks` | list | No | Docker networks to create/join (e.g., `media-net`). Created as external networks. |
| `appdata_dirs` | list | Yes | Subdirectories to create under `$APPDATA/`. Usually `[appname]`. |
| `media_dirs` | list | No | Subdirectories to create under `$MEDIA/` (e.g., `Movies`, `Downloads`). |
| `backup_strategy` | string | No | `stop` (stop containers before backup) or `live` (default, backup while running). Use `stop` for apps with databases. |
| `secrets` | list | No | Secret variables to generate. See below. |

**Secrets block format:**

```yaml
secrets:
  - key: DB_PASSWORD
    prompt: "Database password"
    generate: true          # Auto-generate random password
    length: 32              # Password length (default: 32)
  - key: DB_USERNAME
    prompt: "Database username"
    default: "myapp"        # Use static default (no generation)
```

Each secret becomes a line in `secrets.env`. Keys with `generate: true` get random alphanumeric passwords. Keys with `default:` get that static value. secrets.env is `chmod 600` and `.gitignored`.

### 2. compose.yaml — Docker Compose Definition

Standard Docker Compose v2 file with HomeStack variable conventions.

**Available variables** (injected via `--env-file`):

| Variable | Source | Description |
|----------|--------|-------------|
| `${APPDATA}` | homestack.env | Path to AppData directory |
| `${MEDIA}` | homestack.env | Path to Media directory |
| `${TZ}` | homestack.env | Timezone |
| `${PUID}` | homestack.env | User ID for file permissions |
| `${PGID}` | homestack.env | Group ID for file permissions |
| `${DOCKER_USER}` | homestack.env | `PUID:PGID` for `user:` directive |
| `${APP_IMAGE}` | config.env | Image reference with pinned tag |
| `${SECRET_KEY}` | secrets.env | Any secret defined in app.yaml |

**Compose conventions:**
- Image references use variables from `config.env` (e.g., `image: ${JELLYFIN_SERVER}`)
- Volumes mount under `${APPDATA}/<appname>/`
- Every service should have a `healthcheck`
- Use `env_file: secrets.env` if the app needs secrets injected
- External networks are declared with `external: true`
- File permissions via `user: ${DOCKER_USER}` or `PUID`/`PGID` environment variables
- Pin all image tags — never use `latest`

### 3. config.env — Default Configuration

Simple `KEY=VALUE` file with image tags and app-specific defaults.

**Conventions:**
- Image variable naming: `APPNAME_SERVER=registry/image:version` (e.g., `JELLYFIN_SERVER=jellyfin/jellyfin:10.11.5`)
- Multi-image apps have one variable per image (e.g., `IMMICH_SERVER`, `IMMICH_ML`, `IMMICH_REDIS`, `IMMICH_POSTGRES`)
- Version tag MUST match the `version:` field in `app.yaml`
- Never put secrets here — those go in the `secrets:` block of `app.yaml`
- Users may edit this file after installation; HomeStack tracks which keys they've changed

### 4. test.yaml — Health Check Definition

Defines automated health checks that HomeStack runs after installing the app.

**Fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `startup_time` | integer | Yes | Seconds to wait for containers to become healthy before checks |
| `health_checks` | list | Yes | HTTP endpoints to validate |
| `exec_checks` | list | No | Commands to run inside containers (for database sidecars) |

**health_checks entry:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `url` | string | Yes | — | Full URL to check (e.g., `http://localhost:8096/health`) |
| `method` | string | No | `GET` | HTTP method |
| `expected_status` | integer | No | `200` | Expected HTTP status code |
| `body_contains` | string | No | — | String to find in response body |
| `timeout` | integer | No | `10` | Curl timeout in seconds |

**exec_checks entry:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `container` | string | Yes | Service name from compose.yaml |
| `command` | string | Yes | Shell command to execute |
| `expected_output` | string | No | String to find in command output |

**Example:**

```yaml
startup_time: 60
health_checks:
  - url: "http://localhost:2283/api/server/ping"
    expected_status: 200
    timeout: 15
exec_checks:
  - container: redis
    command: "redis-cli ping"
    expected_output: "PONG"
  - container: database
    command: "pg_isready -U immich"
    expected_output: "accepting connections"
```

## All 10 Apps — Quick Reference

| App | Version | Category | Port | Priority | Services | Networks | Secrets | Backup Strategy |
|-----|---------|----------|------|----------|----------|----------|---------|-----------------|
| immich | 2.4.1 | media | 2283 | 40 | 4 (server, ml, redis, postgres) | — | 3 (DB creds) | stop |
| jellyfin | 10.11.5 | media | 8096 | 50 | 1 | — | — | live |
| jellyseerr | 2.7.3 | servarr | 5055 | 70 | 1 | media-net | — | live |
| n8n | 2.1.4 | automation | 5678 | 60 | 1 | — | — | stop |
| nextcloud | 32.0.6 | cloud | 4432 | 30 | 2 (app, mariadb) | — | 4 (DB creds) | stop |
| prowlarr | 2.3.0 | servarr | 9696 | 65 | 1 | media-net | — | live |
| qbittorrent | 5.1.4 | servarr | 8080 | 65 | 1 | media-net | — | live |
| radarr | 6.0.4 | servarr | 7878 | 65 | 1 | media-net | — | live |
| uptimekuma | 2.0.2 | monitoring | 3001 | 80 | 1 | — | — | live |
| vaultwarden | 1.35.3 | security | 8000 | 80 | 1 | — | 1 (domain) | live |

## App Details

### immich
- **4 services:** `immich-server`, `immich-machine-learning`, `redis`, `database` (PostgreSQL with pgvectors)
- **Images:** 4 separate image variables in config.env (server, ml, valkey/redis, postgres)
- **Secrets:** `DB_USERNAME` (default: immich), `DB_PASSWORD` (generated, 32 chars), `DB_DATABASE_NAME` (default: immich)
- **Healthchecks:** Redis (`redis-cli ping`), Postgres (`pg_isready`), server/ml use image defaults
- **env_file:** `secrets.env` on server and ml services
- **Notes:** `shm_size: 128mb` on database, services use `user: ${DOCKER_USER}`, depends_on with health conditions

### jellyfin
- **1 service:** `jellyfin`
- **Volumes:** config, cache, and `${MEDIA}:/Media` (full media library access)
- **Healthcheck:** `curl -f http://localhost:8096/health`
- **Ports:** `8096:8096/tcp`, `7359:7359/udp` (discovery)
- **Notes:** Uses `user: ${DOCKER_USER}`

### jellyseerr
- **1 service:** `jellyseerr`
- **Healthcheck:** `wget --spider http://localhost:5055/api/v1/status`
- **Network:** `media-net` (external) — connects to Jellyfin/Radarr/etc.
- **Notes:** `init: true` set

### n8n
- **1 service:** `n8n`
- **Volumes:** data dir + files dir
- **Config vars:** `N8N_DOMAIN`, `N8N_SUBDOMAIN` in config.env
- **Healthcheck:** `wget --spider http://localhost:5678/healthz`
- **Notes:** Uses `user: ${DOCKER_USER}`, references subdomain/domain for webhook URLs

### nextcloud
- **2 services:** `nextcloud-db` (MariaDB), `nextcloud` (LinuxServer image)
- **Secrets:** `MARIADB_ROOT_PASSWORD` (generated, 32), `MARIADB_DATABASE` (default: nextcloud), `MARIADB_USER` (default: nextcloud), `MARIADB_PASSWORD` (generated, 24)
- **Healthchecks:** DB (`healthcheck.sh --connect --innodb_initialized`), App (`curl -f https://localhost:443 --insecure`)
- **env_file:** `secrets.env` on nextcloud service
- **Ports:** `4432:443` (HTTPS)
- **Notes:** depends_on with health condition, uses `PUID`/`PGID`

### prowlarr
- **1 service:** `prowlarr` (LinuxServer image)
- **Healthcheck:** `curl -f http://localhost:9696/ping`
- **Network:** `media-net` (external)
- **Notes:** Uses `PUID`/`PGID`

### qbittorrent
- **1 service:** `qbittorrent` (LinuxServer image)
- **Volumes:** config + `${MEDIA}/Downloads:/downloads`
- **Ports:** `8080:8080` (web UI), `6881:6881` tcp+udp (torrenting)
- **Healthcheck:** `curl -f http://localhost:8080`
- **Network:** `media-net` (external)
- **Notes:** Extra env vars `WEBUI_PORT`, `TORRENTING_PORT`

### radarr
- **1 service:** `radarr` (LinuxServer image)
- **Volumes:** config + `${MEDIA}/Movies:/movies` + `${MEDIA}/Downloads:/downloads`
- **Healthcheck:** `curl -f http://localhost:7878/ping`
- **Network:** `media-net` (external)
- **Notes:** Uses `PUID`/`PGID`

### uptimekuma
- **1 service:** `uptime-kuma`
- **Healthcheck:** `wget --spider http://localhost:3001`
- **Notes:** No user directive, no networks, simple single-container app

### vaultwarden
- **1 service:** `vaultwarden`
- **Secret:** `VAULTWARDEN_DOMAIN` (not generated — user provides the public URL)
- **Ports:** `8000:80` (internal port 80 mapped to host 8000)
- **Healthcheck:** `curl -f http://localhost:80/alive`
- **Notes:** `SIGNUPS_ALLOWED=false` set in compose, domain injected via env var

## TEMPLATE Directory

The `TEMPLATE/` directory is a heavily annotated blueprint for contributors adding new apps:

- **app.yaml** (74 lines): Every field documented with `(required)`/`(optional)` annotations, valid category values, priority ranges, backup_strategy options, and example secrets showing both `generate: true` and `default:` patterns
- **compose.yaml** (59 lines): Annotated Compose skeleton with main service + commented-out database sidecar, healthcheck example, resource limits (commented), best-practice comments
- **config.env** (11 lines): Shows image variable naming convention and port variables

## Contribution Workflow

Documented in `CONTRIBUTING.md`:

1. Fork the repo
2. Copy `TEMPLATE/` to `apps/<appname>/`
3. Fill in all three files following the field reference
4. Test locally with HomeStack (`homestack install <app>`, check status, backup, remove)
5. Submit PR using the template in `.github/PULL_REQUEST_TEMPLATE.md`

**PR Checklist (required):**
- Directory name matches `name:` field
- Version pinned in both `app.yaml` and `config.env`
- Healthcheck present
- No secrets in `config.env`
- Secrets declared with clear prompts

## Known Issues & Inconsistencies

1. **Category naming:** Jellyseerr, Prowlarr, qBittorrent, Radarr use `servarr` in app.yaml, but CONTRIBUTING.md lists `download` as a category option — these should be aligned
2. **Version mismatch:** README table may lag behind app.yaml versions (e.g., Uptime Kuma listed as 1.23.16 vs actual 2.0.2 in app.yaml)
3. **Variable naming:** Apps use `${APPDATA}` and `${MEDIA}` while TEMPLATE references `${APPDATA_DIR}` and `${MEDIA_DIR}` — the actual working variables are `APPDATA` and `MEDIA`
4. **User permissions inconsistency:** Some apps use `user: ${DOCKER_USER}`, others use `PUID`/`PGID` env vars, others use neither — depends on the image's convention
5. **Jellyfin media_dirs:** compose.yaml mounts `${MEDIA}:/Media` but app.yaml declares `media_dirs: []` — should list the Media mount
6. **Vaultwarden backup_strategy:** Uses a SQLite database but doesn't set `backup_strategy: stop`, risking backup corruption
7. **qbittorrent version suffix:** app.yaml says `5.1.4` but config.env image tag is `5.1.4-r2`

## Common Development Tasks

### Adding a new app
1. Copy `TEMPLATE/` to `apps/<appname>/`
2. Fill in `app.yaml` — all required fields (name, display_name, description, version, category, port, appdata_dirs)
3. Write `compose.yaml` — use image variables, add healthcheck, map volumes under `${APPDATA}/<appname>/`
4. Write `config.env` — pin image tags with `APPNAME_SERVER=registry/image:tag`
5. Write `test.yaml` — define startup_time, health_checks (URL matching the Docker healthcheck), and exec_checks for any database sidecars
6. If the app has a database, add secrets to `app.yaml` and set `backup_strategy: stop`
7. Test with `homestack install <appname>` locally, then run `APP=<appname> ./tests/run_tests.sh apps`

### Updating an app version
1. Update `version:` in `app.yaml`
2. Update image tag(s) in `config.env`
3. Verify the compose.yaml still works with the new version (check for breaking changes)
4. Both version fields MUST match

### Adding a new category
1. Add the category string to CONTRIBUTING.md's category table
2. Use it in the new app's `app.yaml`
3. Update README.md's app table if needed

### Testing an app locally
```bash
# Quick test with HomeStack (from the homestack repo)
homestack install <appname>
homestack status <appname>
homestack backup <appname>
homestack restore <appname>
homestack remove <appname>

# Or test catalog changes directly
# Edit files in ~/.cache/homestack-apps/apps/<appname>/ (will be overwritten on sync)
```

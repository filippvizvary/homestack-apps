# HomeStack Apps

Community-maintained application catalog for [HomeStack](https://github.com/filippvizvary/homestack).

Each directory under `apps/` is a self-contained app definition that HomeStack can install, update, back up, and remove with a single command.

## Available Apps

| App | Category | Version | Description |
|-----|----------|---------|-------------|
| [Immich](apps/immich) | media | 2.4.1 | Self-hosted photo and video management |
| [Jellyfin](apps/jellyfin) | media | 10.11.5 | Free software media system for streaming |
| [Jellyseerr](apps/jellyseerr) | servarr | 2.7.3 | Media request management for Jellyfin |
| [n8n](apps/n8n) | automation | 2.1.4 | Workflow automation tool |
| [Nextcloud](apps/nextcloud) | cloud | 32.0.6 | Self-hosted productivity and file sync |
| [Prowlarr](apps/prowlarr) | servarr | 2.3.0 | Indexer manager for *arr apps |
| [qBittorrent](apps/qbittorrent) | servarr | 5.1.4 | BitTorrent client with web UI |
| [Radarr](apps/radarr) | servarr | 6.0.4 | Movie collection manager |
| [Uptime Kuma](apps/uptimekuma) | monitoring | 2.0.2 | Self-hosted uptime monitoring tool |
| [Vaultwarden](apps/vaultwarden) | security | 1.35.3 | Bitwarden-compatible password manager |

## App Structure

Every app directory contains exactly three files:

```
apps/myapp/
├── app.yaml       # Metadata, version, ports, secrets, storage
├── compose.yaml   # Docker Compose definition (uses ${VAR} substitution)
└── config.env     # Public defaults — image tags, ports (no secrets!)
```

### app.yaml

Declares everything HomeStack needs to know about the app — name, version, ports, storage paths, networks, backup strategy, and secrets to generate at install time.

### compose.yaml

Standard Docker Compose file. Variables like `${APPDATA}`, `${MEDIA}`, `${PUID}`, `${PGID}`, and `${TZ}` are substituted from the user's global config. App-specific variables come from `config.env` and `secrets.env`.

### config.env

Public configuration defaults committed to git. Contains image tags (pinned to specific versions) and port mappings. **Never put passwords or API keys here** — those go in `secrets` within `app.yaml` and are generated into `secrets.env` at install time.

## Adding a New App

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide, or quick-start:

1. Copy the [`TEMPLATE/`](TEMPLATE/) directory to `apps/your-app/`
2. Fill in all three files
3. Test locally with `homestack install your-app`
4. Submit a pull request

## Branching Strategy

All contributions use short-lived branches off `main`:

| Branch | Purpose |
|--------|---------|
| `main` | Stable catalog. All apps tested and working. |
| `app/*` | New app definitions (e.g., `app/sonarr`, `app/grafana`) |
| `update/*` | Version bumps for existing apps (e.g., `update/immich-2.5.0`) |
| `fix/*` | Fixes to existing app definitions (e.g., `fix/nextcloud-healthcheck`) |

Since each app is self-contained, branches merge directly into `main` via pull request. No integration branch is needed.

## License

MIT — see [LICENSE](LICENSE).

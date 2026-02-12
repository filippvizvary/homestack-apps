# HomeStack Apps

Community-maintained application catalog for [HomeStack](https://github.com/filippvizvary/homestack).

Each directory under `apps/` is a self-contained app definition that HomeStack can install, update, back up, and remove with a single command.

## Available Apps

| App | Category | Version | Description |
|-----|----------|---------|-------------|
| [Immich](apps/immich) | media | 2.4.1 | Self-hosted photo and video management |
| [Jellyfin](apps/jellyfin) | media | 10.11.5 | Free software media system for streaming |
| [Jellyseerr](apps/jellyseerr) | media | 2.7.3 | Media request management for Jellyfin |
| [n8n](apps/n8n) | automation | 2.1.4 | Workflow automation tool |
| [Nextcloud](apps/nextcloud) | cloud | 32.0.6 | Self-hosted productivity and file sync |
| [Prowlarr](apps/prowlarr) | download | 2.3.0 | Indexer manager for *arr apps |
| [qBittorrent](apps/qbittorrent) | download | 5.1.4 | BitTorrent client with web UI |
| [Radarr](apps/radarr) | download | 6.0.4 | Movie collection manager |
| [Uptime Kuma](apps/uptimekuma) | monitoring | 1.23.16 | Self-hosted monitoring tool |
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

Standard Docker Compose file. Variables like `${APPDATA_DIR}`, `${MEDIA_DIR}`, `${PUID}`, `${PGID}`, and `${TZ}` are substituted from the user's global config. App-specific variables come from `config.env` and `secrets.env`.

### config.env

Public configuration defaults committed to git. Contains image tags (pinned to specific versions) and port mappings. **Never put passwords or API keys here** — those go in `secrets` within `app.yaml` and are generated into `secrets.env` at install time.

## Adding a New App

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide, or quick-start:

1. Copy the [`TEMPLATE/`](TEMPLATE/) directory to `apps/your-app/`
2. Fill in all three files
3. Test locally with `homestack install your-app`
4. Submit a pull request

## License

MIT — see [LICENSE](LICENSE).

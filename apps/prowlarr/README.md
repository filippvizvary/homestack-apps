# Prowlarr

Indexer manager and proxy for the Servarr stack — manages indexers for Radarr, Sonarr, Lidarr, etc.

- **Official Documentation:** <https://wiki.servarr.com/prowlarr>
- **Website:** <https://prowlarr.com>
- **Port:** `9696` (Web UI)

## After Installation

1. Open `http://<your-server-ip>:9696` in your browser
2. Set up authentication under **Settings → General → Authentication**
3. Add indexers under **Indexers → Add Indexer**
4. Connect to Radarr/Sonarr under **Settings → Apps**

## Services

| Service | Container | Description |
|---------|-----------|-------------|
| `prowlarr` | `prowlarr` | Indexer manager (LinuxServer.io image) |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| `9696` | TCP | Web UI and API |

## Volumes

| Host Path | Container Path | Description |
|-----------|----------------|-------------|
| `${APPDATA}/prowlarr` | `/config` | Configuration, database, logs |

## Environment Variables

### In `config.env`

| Variable | Default | Description |
|----------|---------|-------------|
| `PROWLARR_SERVER` | `lscr.io/linuxserver/prowlarr:2.3.0` | Image tag |

### In `compose.yaml`

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | From `homestack.env` | User ID for file ownership |
| `PGID` | From `homestack.env` | Group ID for file ownership |
| `TZ` | From `homestack.env` | Timezone |

## Networks

- **`media-net`** — External Docker network shared with Radarr, qBittorrent, and Jellyseerr

## Customization

### Adding Custom Volumes

```yaml
services:
  prowlarr:
    volumes:
      - ${APPDATA}/prowlarr:/config
      - /path/to/custom:/custom  # Additional mount
```

## Data & Backup

- **Backup strategy:** `live` (backup while running — uses SQLite)
- **Data location:** `AppData/prowlarr/`
- **Database:** SQLite in config directory

## Tips

- Connect Prowlarr to Radarr/Sonarr — it automatically syncs indexers to all connected apps
- Set up Flaresolverr if your indexers require Cloudflare bypass
- Prowlarr manages all indexers centrally — no need to configure them individually in each *arr app

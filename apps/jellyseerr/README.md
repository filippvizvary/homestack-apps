# Jellyseerr

Media request management and discovery tool for Jellyfin.

- **Official Documentation:** <https://docs.jellyseerr.dev>
- **GitHub:** <https://github.com/Fallenbagel/jellyseerr>
- **Port:** `5055` (Web UI)

## After Installation

1. Open `http://<your-server-ip>:5055` in your browser
2. Sign in with your Jellyfin account (select "Use your Jellyfin account")
3. Enter your Jellyfin server URL (e.g., `http://<server-ip>:8096`)
4. Configure Radarr/Sonarr connections under **Settings → Services**
5. Scan your existing Jellyfin libraries under **Settings → Jellyfin**

## Services

| Service | Container | Description |
|---------|-----------|-------------|
| `jellyseerr` | `jellyseerr` | Request management web app |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| `5055` | TCP | Web UI |

## Volumes

| Host Path | Container Path | Description |
|-----------|----------------|-------------|
| `${APPDATA}/jellyseerr/config` | `/app/config` | Configuration and database |

## Environment Variables

### In `config.env`

| Variable | Default | Description |
|----------|---------|-------------|
| `JELLYSEERR_SERVER` | `ghcr.io/fallenbagel/jellyseerr:2.7.3` | Image tag |

### In `compose.yaml`

| Variable | Default | Description |
|----------|---------|-------------|
| `LOG_LEVEL` | `info` | Logging level (`debug`, `info`, `warn`, `error`) |
| `PORT` | `5055` | Internal port |
| `TZ` | From `homestack.env` | Timezone |

## Networks

- **`media-net`** — External Docker network shared with Jellyfin, Radarr, Prowlarr, and qBittorrent

## Customization

### Adding Additional Volume Mounts

Edit `installed/jellyseerr/compose.yaml`:

```yaml
services:
  jellyseerr:
    volumes:
      - ${APPDATA}/jellyseerr/config:/app/config
      - /path/to/custom/data:/custom  # Additional mount
```

## Data & Backup

- **Backup strategy:** `live` (backup while running)
- **Data location:** `AppData/jellyseerr/config/`
- **Database:** SQLite in config directory

## Tips

- Jellyseerr needs network access to Jellyfin — both are on the `media-net` Docker network
- Configure Radarr and Sonarr first, then connect them to Jellyseerr for automatic request fulfillment
- Users can request movies/TV shows and track download progress

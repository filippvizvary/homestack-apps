# qBittorrent

BitTorrent client with a web UI for remote management.

- **Official Documentation:** <https://github.com/qbittorrent/qBittorrent/wiki>
- **Website:** <https://www.qbittorrent.org>
- **Port:** `8080` (Web UI)

## After Installation

1. Open `http://<your-server-ip>:8080` in your browser
2. Check container logs for the temporary admin password: `homestack logs qbittorrent`
3. Log in with username `admin` and the temporary password from the logs
4. Change the admin password under **Tools → Options → Web UI**
5. Configure download paths and connection settings

## Services

| Service | Container | Description |
|---------|-----------|-------------|
| `qbittorrent` | `qbittorrent` | BitTorrent client (LinuxServer.io image) |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| `8080` | TCP | Web UI |
| `6881` | TCP | BitTorrent incoming connections |
| `6881` | UDP | BitTorrent DHT |

## Volumes

| Host Path | Container Path | Description |
|-----------|----------------|-------------|
| `${APPDATA}/qbittorrent` | `/config` | Configuration and session data |
| `${MEDIA}/Downloads` | `/downloads` | Download directory |

## Environment Variables

### In `config.env`

| Variable | Default | Description |
|----------|---------|-------------|
| `QBITTORRENT_SERVER` | `lscr.io/linuxserver/qbittorrent:5.1.4` | Image tag |

### In `compose.yaml`

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | From `homestack.env` | User ID for file ownership |
| `PGID` | From `homestack.env` | Group ID for file ownership |
| `TZ` | From `homestack.env` | Timezone |
| `WEBUI_PORT` | `8080` | Web UI port (internal) |
| `TORRENTING_PORT` | `6881` | BitTorrent port (internal) |

## Networks

- **`media-net`** — External Docker network shared with Radarr, Prowlarr, and Jellyseerr

## Customization

### Adding NAS Download Paths

Edit `installed/qbittorrent/compose.yaml`:

```yaml
services:
  qbittorrent:
    volumes:
      - ${APPDATA}/qbittorrent:/config
      - ${MEDIA}/Downloads:/downloads
      - /mnt/nas/downloads:/mnt/nas-downloads  # NAS download path
      - /mnt/nas/movies:/mnt/nas-movies        # NAS for completed movies
```

### Changing Ports

```yaml
ports:
  - 9090:8080     # Web UI on port 9090 instead
  - 51413:6881    # Different torrent port
  - 51413:6881/udp
environment:
  - TORRENTING_PORT=6881  # Keep internal port matching
```

**Important:** If you change the torrent port, also update it in qBittorrent's settings under **Tools → Options → Connection**.

### VPN Integration

For privacy, you can route traffic through a VPN container:

```yaml
services:
  qbittorrent:
    network_mode: "container:vpn-container-name"
    # Remove the ports: section when using network_mode
```

## Data & Backup

- **Backup strategy:** `live` (backup while running)
- **Config:** `AppData/qbittorrent/`
- **Downloads:** `Media/Downloads/` — not backed up by HomeStack

## Tips

- The initial admin password is printed in the container logs on first start
- Configure **Tools → Options → Downloads → Default Save Path** to `/downloads`
- Enable the "Bypass authentication for clients on localhost" option for easier local access
- Connect Radarr/Sonarr to qBittorrent's API at `http://qbittorrent:8080` (via `media-net`)

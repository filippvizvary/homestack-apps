# qBittorrent

BitTorrent client with a web UI for managing downloads.

**Website:** <https://www.qbittorrent.org>

## Access

Open `http://<your-server-ip>:8080` in your browser.

## First-Time Setup

1. On first start, qBittorrent generates a **temporary admin password**. To find it:
   ```bash
   docker logs qbittorrent 2>&1 | grep "temporary password"
   ```
2. Log in with username `admin` and the temporary password.
3. Go to **Tools > Options > Web UI** and change the admin password immediately.
4. Configure your download settings:
   - **Default Save Path:** The container maps `Media/Downloads/` as `/downloads`
   - Go to **Tools > Options > Downloads** to set your preferred paths and behavior

## Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 8080 | TCP | Web UI |
| 6881 | TCP/UDP | BitTorrent traffic (incoming connections) |

## Network

qBittorrent joins the `media-net` Docker network, allowing Radarr, Sonarr, and other Servarr apps to communicate with it directly.

## Media Directories

| Host Path | Container Path | Purpose |
|-----------|----------------|---------|
| `Media/Downloads/` | `/downloads` | Download directory |

## Configuration

Edit `installed/qbittorrent/config.env` to change the image version:
- `QBITTORRENT_SERVER` — qBittorrent Docker image tag (LinuxServer image)

## Data Storage

- **Config files:** `AppData/qbittorrent/config/`

## Tips

- When adding qBittorrent as a download client in Radarr/Sonarr, use host `qbittorrent` and port `8080` (internal Docker network).
- If your ISP blocks port 6881, you can change the torrent port in `config.env` and the compose file.
- Consider using a VPN for privacy — this can be configured by modifying the compose file to route traffic through a VPN container.
- The LinuxServer image uses `PUID`/`PGID` for file permissions, configured via HomeStack's global settings.

# Radarr

Movie collection manager — automates downloading, renaming, and organizing movies.

- **Official Documentation:** <https://wiki.servarr.com/radarr>
- **Website:** <https://radarr.video>
- **Port:** `7878` (Web UI)

## After Installation

1. Open `http://<your-server-ip>:7878` in your browser
2. Set up authentication under **Settings → General → Authentication**
3. Add a download client under **Settings → Download Clients** (e.g., qBittorrent at `http://qbittorrent:8080`)
4. Add indexers under **Settings → Indexers** (or let Prowlarr sync them automatically)
5. Configure root folders under **Settings → Media Management**
6. Start adding movies!

## Services

| Service | Container | Description |
|---------|-----------|-------------|
| `radarr` | `radarr` | Movie manager (LinuxServer.io image) |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| `7878` | TCP | Web UI and API |

## Volumes

| Host Path | Container Path | Description |
|-----------|----------------|-------------|
| `${APPDATA}/radarr` | `/config` | Configuration, database, logs |
| `${MEDIA}/Movies` | `/movies` | Movie library (organized files) |
| `${MEDIA}/Downloads` | `/downloads` | Download directory (shared with qBittorrent) |

## Environment Variables

### In `config.env`

| Variable | Default | Description |
|----------|---------|-------------|
| `RADARR_SERVER` | `lscr.io/linuxserver/radarr:6.0.4` | Image tag |

### In `compose.yaml`

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | From `homestack.env` | User ID for file ownership |
| `PGID` | From `homestack.env` | Group ID for file ownership |
| `TZ` | From `homestack.env` | Timezone |

## Networks

- **`media-net`** — External Docker network shared with qBittorrent, Prowlarr, and Jellyseerr

## Customization

### Adding NAS Paths

Edit `installed/radarr/compose.yaml`:

```yaml
services:
  radarr:
    volumes:
      - ${APPDATA}/radarr:/config
      - ${MEDIA}/Movies:/movies
      - ${MEDIA}/Downloads:/downloads
      - /mnt/nas/movies:/mnt/nas-movies    # NAS movie library
      - /mnt/nas/downloads:/mnt/nas-dl     # NAS downloads
```

Then add the NAS path as a root folder in Radarr's **Settings → Media Management → Root Folders**.

### Hardlink Support

For hardlinks to work (instant moves, no disk space duplication), the download and movie directories must be on the **same filesystem**. The default setup supports this since both `/downloads` and `/movies` are under `${MEDIA}`.

## Data & Backup

- **Backup strategy:** `live` (backup while running — uses SQLite)
- **Config:** `AppData/radarr/`
- **Movies:** `Media/Movies/` — not backed up by HomeStack

## Tips

- Use Prowlarr to manage indexers centrally instead of adding them individually
- Set up **Custom Formats** for quality preferences (e.g., prefer x265, HDR)
- Enable **Recycling Bin** under **Settings → Media Management** to prevent accidental deletions
- Radarr communicates with qBittorrent via the `media-net` Docker network

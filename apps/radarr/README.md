# Radarr

Movie collection manager — automatically searches, downloads, and organizes movies.

**Website:** <https://radarr.video>

## Access

Open `http://<your-server-ip>:7878` in your browser.

## First-Time Setup

1. On first visit, Radarr will ask you to set up **authentication**. Create a username and password.
2. Add a **root folder** for your movie library:
   - Go to **Settings > Media Management > Root Folders**
   - Add `/movies` (maps to `Media/Movies/` on the host)
3. Add a **download client**:
   - Go to **Settings > Download Clients**
   - Add **qBittorrent** with host `qbittorrent`, port `8080` (if on the same `media-net` network)
4. Add **indexers** — if using Prowlarr, they will sync automatically. Otherwise, add them manually under **Settings > Indexers**.
5. Add movies by searching from the **Add New** page.

## Network

Radarr joins the `media-net` Docker network, allowing direct communication with Prowlarr, qBittorrent, Jellyfin, and other Servarr stack apps by container name.

## Media Directories

| Host Path | Container Path | Purpose |
|-----------|----------------|---------|
| `Media/Movies/` | `/movies` | Movie library |
| `Media/Downloads/` | `/downloads` | Completed downloads (shared with qBittorrent) |

## Configuration

Edit `installed/radarr/config.env` to change the image version:
- `RADARR_SERVER` — Radarr Docker image tag (LinuxServer image)

## Data Storage

- **Config data:** `AppData/radarr/config/`

## Tips

- Radarr's API key can be found under **Settings > General** — you'll need it to connect Prowlarr and Jellyseerr.
- Set up **quality profiles** under Settings to control what quality/resolution of movies to download.
- Enable **Completed Download Handling** to automatically import files from qBittorrent after download.
- The LinuxServer image uses `PUID`/`PGID` for file permissions, configured via HomeStack's global settings.

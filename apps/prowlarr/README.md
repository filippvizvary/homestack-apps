# Prowlarr

Indexer manager and proxy for the Servarr stack — manages indexers for Radarr, Sonarr, and other apps.

**Website:** <https://prowlarr.com>

## Access

Open `http://<your-server-ip>:9696` in your browser.

## First-Time Setup

1. On first visit, Prowlarr will ask you to set up **authentication**. Create a username and password.
2. Go to **Settings > Indexers** to add your preferred indexer sites (Torznab, Newznab, etc.).
3. Go to **Settings > Apps** to connect your Servarr apps:
   - Add **Radarr** with URL `http://radarr:7878` (if on the same `media-net` network)
   - Add **Sonarr** if installed
   - You'll need each app's API key (found in their Settings > General page)
4. Once connected, Prowlarr will automatically sync your indexers to all linked apps.

## Network

Prowlarr joins the `media-net` Docker network, allowing direct communication with Radarr, Sonarr, qBittorrent, and other Servarr stack apps by container name.

## Configuration

Edit `installed/prowlarr/config.env` to change the image version:
- `PROWLARR_SERVER` — Prowlarr Docker image tag (LinuxServer image)

## Data Storage

- **Config data:** `AppData/prowlarr/config/`

## Tips

- Prowlarr is the central place to manage all your indexers — add them once here and they sync everywhere.
- Use the built-in search to test indexers before connecting them to other apps.
- Enable **FlareSolverr** integration if you need to bypass Cloudflare-protected indexers.

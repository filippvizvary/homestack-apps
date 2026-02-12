# Jellyseerr

Media request management and discovery tool for Jellyfin — lets users request movies and TV shows.

**Website:** <https://github.com/Fallenbagel/jellyseerr>

## Access

Open `http://<your-server-ip>:5055` in your browser.

## First-Time Setup

1. On first visit, select **Jellyfin** as your media server.
2. Enter your Jellyfin server URL (e.g., `http://<your-server-ip>:8096`).
3. Sign in with your Jellyfin admin credentials.
4. Sync your Jellyfin libraries so Jellyseerr knows what media you already have.
5. Optionally configure Radarr and Sonarr connections to enable automatic downloading of requested media:
   - Go to **Settings > Services** to add your Radarr/Sonarr instances.
   - Use their internal Docker network address if on the same `media-net` network (e.g., `http://radarr:7878`).

## Network

Jellyseerr joins the `media-net` Docker network, allowing it to communicate directly with other Servarr stack apps (Radarr, Prowlarr, qBittorrent) by container name.

## Configuration

Edit `installed/jellyseerr/config.env` to change the image version:
- `JELLYSEERR_SERVER` — Jellyseerr Docker image tag

## Data Storage

- **Config data:** `AppData/jellyseerr/config/`

## Tips

- Users can sign in with their Jellyfin accounts to make requests.
- Set up notification agents (Discord, email, etc.) under **Settings > Notifications**.
- Request limits can be configured per user under **Settings > Users**.

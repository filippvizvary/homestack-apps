# Jellyfin

Free software media system for streaming movies, TV shows, music, and more.

**Website:** <https://jellyfin.org>

## Access

Open `http://<your-server-ip>:8096` in your browser.

## First-Time Setup

1. On first visit, the **Setup Wizard** will guide you through initial configuration.
2. Choose your preferred language.
3. Create an admin username and password.
4. Add media libraries by pointing them to the appropriate paths:
   - **Movies:** `/Media/Movies`
   - **TV Shows:** `/Media/TV`
   - **Music:** `/Media/Music`
5. Configure metadata language and remote access settings.
6. Complete the wizard and log in.

## Media Directories

Place your media files in the following directories on the host:

| Type | Host Path | Container Path |
|------|-----------|----------------|
| Movies | `Media/Movies/` | `/Media/Movies` |
| TV Shows | `Media/TV/` | `/Media/TV` |
| Music | `Media/Music/` | `/Media/Music` |

## Configuration

Edit `installed/jellyfin/config.env` to change the image version:
- `JELLYFIN_SERVER` — Jellyfin Docker image tag

## Data Storage

- **Config & metadata:** `AppData/jellyfin/config/`
- **Cache (transcoding):** `AppData/jellyfin/cache/`

## Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 8096 | TCP | Web UI and API |
| 7359 | UDP | Auto-discovery on local network |

## Client Apps

- **Web:** Built-in at port 8096
- **Mobile:** [Jellyfin for Android](https://play.google.com/store/apps/details?id=org.jellyfin.mobile) / [Jellyfin for iOS](https://apps.apple.com/app/jellyfin-mobile/id1480732557)
- **Desktop:** [Jellyfin Media Player](https://github.com/jellyfin/jellyfin-media-player/releases)
- **TV:** Apps available for Roku, Fire TV, Android TV, and more

## Tips

- Hardware transcoding (VAAPI/QSV/NVENC) can be configured by modifying the compose file — see [Jellyfin docs](https://jellyfin.org/docs/general/administration/hardware-acceleration/).
- Enable DLNA in settings if you want to cast to smart TVs on your network.

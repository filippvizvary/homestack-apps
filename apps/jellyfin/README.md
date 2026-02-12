# Jellyfin

Free software media system for streaming movies, TV shows, and music.

- **Official Documentation:** <https://jellyfin.org/docs>
- **GitHub:** <https://github.com/jellyfin/jellyfin>
- **Port:** `8096` (Web UI)

## After Installation

1. Open `http://<your-server-ip>:8096` in your browser
2. Follow the setup wizard to create an admin account
3. Add media libraries pointing to `/Media/Movies`, `/Media/TV`, `/Media/Music`
4. Download Jellyfin client apps for your devices

## Services

| Service | Container | Description |
|---------|-----------|-------------|
| `jellyfin` | `jellyfin` | Media server |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| `8096` | TCP | Web UI and API |
| `7359` | UDP | Client auto-discovery (LAN) |

## Volumes

| Host Path | Container Path | Description |
|-----------|----------------|-------------|
| `${APPDATA}/jellyfin/config` | `/config` | Configuration, databases, metadata |
| `${APPDATA}/jellyfin/cache` | `/cache` | Transcoding cache and image cache |
| `${MEDIA}` | `/Media` | Full media library (read-only recommended) |

## Environment Variables

### In `config.env`

| Variable | Default | Description |
|----------|---------|-------------|
| `JELLYFIN_SERVER` | `jellyfin/jellyfin:10.11.5` | Jellyfin image tag |

### Global (from `homestack.env`)

| Variable | Description |
|----------|-------------|
| `DOCKER_USER` | `PUID:PGID` — sets file ownership for config/cache |
| `TZ` | Timezone for display |

## Customization

### Adding NAS Storage

Edit `installed/jellyfin/compose.yaml` to add additional media paths:

```yaml
services:
  jellyfin:
    volumes:
      - ${APPDATA}/jellyfin/config:/config
      - ${APPDATA}/jellyfin/cache:/cache
      - ${MEDIA}:/Media
      - /mnt/nas/movies:/mnt/movies:ro    # NAS movie share
      - /mnt/nas/tv:/mnt/tv:ro            # NAS TV share
      - /mnt/nas/music:/mnt/music:ro      # NAS music share
```

Then add these paths as libraries in Jellyfin's web UI under **Dashboard → Libraries**.

### Hardware Transcoding

For Intel Quick Sync (most common):

```yaml
services:
  jellyfin:
    devices:
      - /dev/dri/renderD128:/dev/dri/renderD128
    group_add:
      - "105"  # render group GID (check with: getent group render)
```

For NVIDIA GPU:

```yaml
services:
  jellyfin:
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: [gpu]
```

Enable hardware transcoding in **Dashboard → Playback → Transcoding**.

### Custom Ports

Edit `installed/jellyfin/compose.yaml`:

```yaml
ports:
  - 9096:8096/tcp   # Changed from 8096
  - 7359:7359/udp
```

## Data & Backup

- **Backup strategy:** `live` (backup while running)
- **Config:** `AppData/jellyfin/config/` (metadata, databases, user preferences)
- **Cache:** `AppData/jellyfin/cache/` (transcoding cache, can be rebuilt)
- **Media:** Stored in `Media/` — not backed up by HomeStack (manage separately)

## Tips

- Use hardware transcoding to reduce CPU load during streaming
- The `:ro` (read-only) flag on media mounts prevents accidental deletion
- Jellyfin Mobile and Jellyfin Media Player are the best client apps
- Consider scheduling library scans during off-peak hours for large libraries

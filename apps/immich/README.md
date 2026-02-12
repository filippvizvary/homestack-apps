# Immich

Self-hosted photo and video management solution — a Google Photos alternative.

**Website:** <https://immich.app>

## Access

Open `http://<your-server-ip>:2283` in your browser.

## First-Time Setup

1. On first visit, you will see the **Welcome** screen. Create an admin account by entering your name, email, and password.
2. After logging in, configure your settings under **Administration > Settings**.
3. Install the Immich mobile app ([iOS](https://apps.apple.com/app/immich/id1613945686) / [Android](https://play.google.com/store/apps/details?id=app.alextran.immich)) and connect it to your server URL.
4. Enable **Auto Backup** in the mobile app to start uploading your photos.

## Services

Immich runs 4 containers:

| Service | Description |
|---------|-------------|
| `immich-server` | Main application server (API + web UI) |
| `immich-machine-learning` | AI/ML for facial recognition, smart search, and OCR |
| `redis` | Cache layer (Valkey) |
| `database` | PostgreSQL with vector extensions for ML embeddings |

## Configuration

Edit `installed/immich/config.env` to change image versions.

Key secrets (auto-generated in `secrets.env`):
- `DB_USERNAME` — PostgreSQL username (default: `immich`)
- `DB_PASSWORD` — PostgreSQL password (auto-generated)
- `DB_DATABASE_NAME` — Database name (default: `immich`)

## Data Storage

- **Library data:** `AppData/immich/library/`
- **ML model cache:** `AppData/immich/ml/`
- **PostgreSQL data:** `AppData/immich/postgres/`
- **Redis data:** `AppData/immich/redis/`

## Backup

Uses `stop` strategy — containers are stopped before backup to ensure database consistency.

```bash
homestack backup immich
```

## Tips

- Hardware transcoding can be enabled by modifying the compose file — see [Immich docs](https://docs.immich.app/features/hardware-transcoding).
- The ML service downloads AI models on first startup, which may take a few minutes.
- For external access, set up a reverse proxy (e.g., Nginx, Caddy, Traefik) with HTTPS.

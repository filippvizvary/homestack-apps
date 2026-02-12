# Uptime Kuma

Self-hosted uptime monitoring tool — track the availability of your websites and services.

**Website:** <https://uptime.kuma.pet>

## Access

Open `http://<your-server-ip>:3001` in your browser.

## First-Time Setup

1. On first visit, create an **admin account** with your username and password.
2. Click **Add New Monitor** to start monitoring a service:
   - **HTTP(s):** Monitor any website or API endpoint
   - **TCP Port:** Check if a specific port is open
   - **Ping:** Simple ICMP ping check
   - **Docker Container:** Monitor container status (requires Docker socket access)
3. Configure notification channels under **Settings > Notifications** (supports email, Discord, Slack, Telegram, and many more).

## Configuration

Edit `installed/uptimekuma/config.env` to change the image version:
- `UPTIMEKUMA_SERVER` — Uptime Kuma Docker image tag

## Data Storage

- **Database & config:** `AppData/uptimekuma/data/`

## Backup

Uses `stop` strategy — containers are stopped before backup to protect the SQLite database.

```bash
homestack backup uptimekuma
```

## Tips

- Set up **status pages** to share service availability with users — accessible via a public URL.
- Use the **maintenance** feature to schedule downtime windows and suppress alerts.
- Monitor your other HomeStack apps by adding HTTP monitors pointing to their health check endpoints (e.g., `http://<server-ip>:8096/health` for Jellyfin).
- Supports two-factor authentication (2FA) for extra security.

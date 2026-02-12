# Nextcloud

Self-hosted productivity and file sync platform — a Google Drive/Dropbox alternative.

**Website:** <https://nextcloud.com>

## Access

Open `https://<your-server-ip>:4432` in your browser.

> **Note:** Nextcloud uses HTTPS (port 4432). Your browser will show a certificate warning for the self-signed certificate — this is normal. Accept the warning to proceed.

## First-Time Setup

1. On first visit, create an **admin account** with your desired username and password.
2. Wait for the initial setup to complete (may take a minute as apps are installed).
3. Once logged in, explore the dashboard and configure your instance under **Administration Settings** (top-right menu > Administration settings).

## Services

| Service | Description |
|---------|-------------|
| `nextcloud` | Main application (LinuxServer image) |
| `nextcloud-db` | MariaDB database |

## Configuration

Edit `installed/nextcloud/config.env` to change image versions:
- `NEXTCLOUD_SERVER` — Nextcloud Docker image tag
- `MARIADB_SERVER` — MariaDB Docker image tag

Key secrets (auto-generated in `secrets.env`):
- `MARIADB_ROOT_PASSWORD` — MariaDB root password
- `MARIADB_DATABASE` — Database name (default: `nextcloud`)
- `MARIADB_USER` — Database user (default: `nextcloud`)
- `MARIADB_PASSWORD` — Database user password

## Data Storage

- **Nextcloud data & config:** `AppData/nextcloud/`

## Backup

Uses `stop` strategy — containers are stopped before backup to ensure database consistency.

```bash
homestack backup nextcloud
```

## Client Apps

- **Desktop sync:** [Nextcloud Desktop Client](https://nextcloud.com/install/#install-clients) (Windows, macOS, Linux)
- **Mobile:** [Nextcloud for Android](https://play.google.com/store/apps/details?id=com.nextcloud.client) / [Nextcloud for iOS](https://apps.apple.com/app/nextcloud/id1125420102)

## Tips

- Install additional apps from the Nextcloud App Store (built into the web UI under Apps).
- For external access, set up a reverse proxy with a valid SSL certificate.
- Set your trusted domains in the Nextcloud config if accessing from multiple URLs.
- The LinuxServer image uses `PUID`/`PGID` for file permissions, configured via HomeStack's global settings.

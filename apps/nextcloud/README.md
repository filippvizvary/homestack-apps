# Nextcloud

Self-hosted productivity platform — file sync, calendar, contacts, office suite, and more.

- **Official Documentation:** <https://docs.nextcloud.com>
- **Website:** <https://nextcloud.com>
- **Port:** `4432` (HTTPS)

## After Installation

1. Open `https://<your-server-ip>:4432` in your browser (accept the self-signed certificate warning)
2. Create your admin account
3. Install recommended apps (Calendar, Contacts, Notes, etc.)
4. Download Nextcloud desktop/mobile sync clients from <https://nextcloud.com/install/#install-clients>

## Services

| Service | Container | Description |
|---------|-----------|-------------|
| `nextcloud-db` | `nextcloud_mariadb` | MariaDB database |
| `nextcloud` | `nextcloud` | Nextcloud app (LinuxServer.io image, Apache + PHP) |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| `4432` | TCP (HTTPS) | Web UI — maps host 4432 to container 443 |

## Volumes

| Host Path | Container Path | Description |
|-----------|----------------|-------------|
| `${APPDATA}/nextcloud/db` | `/var/lib/mysql` | MariaDB database files |
| `${APPDATA}/nextcloud/config` | `/config` | Nextcloud configuration (Apache, PHP, app config) |
| `${APPDATA}/nextcloud/data` | `/data` | User files and data |

## Environment Variables

### In `config.env`

| Variable | Default | Description |
|----------|---------|-------------|
| `NEXTCLOUD_SERVER` | `lscr.io/linuxserver/nextcloud:32.0.6` | Nextcloud image tag |
| `MARIADB_SERVER` | `mariadb:11.7` | MariaDB image tag |

### In `secrets.env` (auto-generated)

| Variable | Description |
|----------|-------------|
| `MARIADB_ROOT_PASSWORD` | MariaDB root password (auto-generated, 32 chars) |
| `MARIADB_DATABASE` | Database name (default: `nextcloud`) |
| `MARIADB_USER` | Database username (default: `nextcloud`) |
| `MARIADB_PASSWORD` | Database user password (auto-generated, 24 chars) |

### In `compose.yaml`

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | From `homestack.env` | User ID for file ownership |
| `PGID` | From `homestack.env` | Group ID for file ownership |
| `TZ` | From `homestack.env` | Timezone |
| `MYSQL_HOST` | `nextcloud-db` | Database hostname (internal Docker network) |

## Customization

### Adding External Storage (NAS)

Edit `installed/nextcloud/compose.yaml`:

```yaml
services:
  nextcloud:
    volumes:
      - ${APPDATA}/nextcloud/config:/config
      - ${APPDATA}/nextcloud/data:/data
      - /mnt/nas/nextcloud-files:/mnt/nas:rw  # NAS storage
```

Then enable the **External Storage** app in Nextcloud and configure the mount.

### Custom Domain / Trusted Domains

After installation, add your domain to trusted domains:

```bash
homestack exec nextcloud -- php /config/www/nextcloud/occ config:system:set trusted_domains 1 --value="cloud.yourdomain.com"
```

### Increasing Upload Limits

The LinuxServer image includes Apache/PHP config at `AppData/nextcloud/config/php/php-local.ini`:

```ini
upload_max_filesize = 16G
post_max_size = 16G
memory_limit = 1G
```

### Using a Reverse Proxy

When behind a reverse proxy (Nginx, Caddy, Traefik), set:

```bash
homestack exec nextcloud -- php /config/www/nextcloud/occ config:system:set overwriteprotocol --value="https"
homestack exec nextcloud -- php /config/www/nextcloud/occ config:system:set overwrite.cli.url --value="https://cloud.yourdomain.com"
```

## Data & Backup

- **Backup strategy:** `stop` (containers stop for MariaDB consistency)
- **Database:** `AppData/nextcloud/db/`
- **User files:** `AppData/nextcloud/data/`
- **Config:** `AppData/nextcloud/config/`

## Tips

- The HTTPS certificate is self-signed — use a reverse proxy for trusted HTTPS
- First startup takes 1–2 minutes while the database initializes
- Background jobs should use **Cron** — configure in **Administration Settings → Basic Settings**
- Install the **Nextcloud Office** app for collaborative document editing

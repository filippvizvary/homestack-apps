# n8n

Workflow automation tool — connect APIs, services, and apps with visual workflows.

- **Official Documentation:** <https://docs.n8n.io>
- **Website:** <https://n8n.io>
- **Port:** `5678` (Web UI)

## After Installation

1. Open `http://<your-server-ip>:5678` in your browser
2. Create your owner account
3. Start building workflows using the visual editor
4. Browse community workflows at <https://n8n.io/workflows>

## Services

| Service | Container | Description |
|---------|-----------|-------------|
| `n8n` | `n8n` | Workflow automation engine + web editor |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| `5678` | TCP | Web UI and webhook endpoint |

## Volumes

| Host Path | Container Path | Description |
|-----------|----------------|-------------|
| `${APPDATA}/n8n/data` | `/home/node/.n8n` | Workflows, credentials, SQLite database |
| `${APPDATA}/n8n/files` | `/files` | Uploaded and processed files |

## Environment Variables

### In `config.env`

| Variable | Default | Description |
|----------|---------|-------------|
| `N8N_SERVER` | `n8nio/n8n:2.1.4` | n8n image tag |
| `N8N_DOMAIN` | `example.com` | Your domain (edit after install) |
| `N8N_SUBDOMAIN` | `n8n` | Subdomain for webhook URLs |

### In `compose.yaml`

| Variable | Default | Description |
|----------|---------|-------------|
| `N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS` | `true` | Enforce strict file permissions |
| `N8N_HOST` | `${N8N_SUBDOMAIN}.${N8N_DOMAIN}` | Full hostname |
| `N8N_PORT` | `5678` | Internal port |
| `N8N_PROTOCOL` | `http` | Protocol for generated URLs |
| `N8N_RUNNERS_ENABLED` | `true` | Enable workflow runners |
| `NODE_ENV` | `production` | Node.js environment |
| `WEBHOOK_URL` | `https://${N8N_SUBDOMAIN}.${N8N_DOMAIN}/` | Public webhook URL |
| `GENERIC_TIMEZONE` | `${TZ}` | Timezone for scheduled workflows |
| `N8N_SECURE_COOKIE` | `true` | Require secure cookies |

## Customization

### Configuring Domain

After installation, edit `installed/n8n/config.env`:

```env
N8N_DOMAIN=yourdomain.com
N8N_SUBDOMAIN=n8n
```

Then restart: `homestack restart n8n`

### Adding External Database (PostgreSQL)

For production use with PostgreSQL instead of SQLite, add env vars:

```yaml
services:
  n8n:
    environment:
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=your-postgres-host
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=n8n
      - DB_POSTGRESDB_USER=n8n
      - DB_POSTGRESDB_PASSWORD=yourpassword
```

### Adding Volume for File Processing

```yaml
services:
  n8n:
    volumes:
      - ${APPDATA}/n8n/data:/home/node/.n8n
      - ${APPDATA}/n8n/files:/files
      - /mnt/nas/shared:/mnt/shared  # NAS for file processing
```

## Data & Backup

- **Backup strategy:** `stop` (containers stop for database consistency)
- **Data location:** `AppData/n8n/`
- **Workflows and credentials:** Stored in SQLite at `AppData/n8n/data/database.sqlite`

## Tips

- Edit `config.env` to set your actual domain before using webhooks
- Set `N8N_SECURE_COOKIE=false` if accessing over plain HTTP (no reverse proxy)
- n8n uses an internal SQLite database — `backup_strategy: stop` ensures consistent backups
- Community nodes can be installed via **Settings → Community Nodes**

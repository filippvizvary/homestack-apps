# Uptime Kuma

Self-hosted uptime monitoring tool — monitor websites, APIs, and services.

- **Official Documentation:** <https://github.com/louislam/uptime-kuma/wiki>
- **GitHub:** <https://github.com/louislam/uptime-kuma>
- **Port:** `3001` (Web UI)

## After Installation

1. Open `http://<your-server-ip>:3001` in your browser
2. Create your admin account
3. Add monitors for your services (HTTP, TCP, ping, DNS, etc.)
4. Configure notifications (email, Slack, Discord, Telegram, etc.)

## Services

| Service | Container | Description |
|---------|-----------|-------------|
| `uptime-kuma` | `uptimekuma` | Monitoring server |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| `3001` | TCP | Web UI and API |

## Volumes

| Host Path | Container Path | Description |
|-----------|----------------|-------------|
| `${APPDATA}/uptimekuma` | `/app/data` | Configuration and SQLite database |

## Environment Variables

### In `config.env`

| Variable | Default | Description |
|----------|---------|-------------|
| `UPTIMEKUMA_SERVER` | `louislam/uptime-kuma:2.0.2` | Image tag |

## Customization

### Adding Custom Volumes

```yaml
services:
  uptime-kuma:
    volumes:
      - ${APPDATA}/uptimekuma:/app/data
      - /path/to/ssl-certs:/certs:ro  # Custom SSL certificates for monitoring
```

### Changing the Port

```yaml
ports:
  - 8443:3001  # Access on port 8443 instead
```

## Data & Backup

- **Backup strategy:** `stop` (containers stop for SQLite consistency)
- **Data location:** `AppData/uptimekuma/`
- **Database:** SQLite in `AppData/uptimekuma/`

## Tips

- Add monitors for all your HomeStack apps to track uptime
- Use **Status Pages** to create a public status dashboard
- Configure notification channels before adding monitors
- Uptime Kuma supports 20+ notification providers (Discord, Slack, Telegram, email, etc.)

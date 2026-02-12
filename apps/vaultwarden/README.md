# Vaultwarden

Lightweight Bitwarden-compatible password manager server.

- **Official Documentation:** <https://github.com/dani-garcia/vaultwarden/wiki>
- **GitHub:** <https://github.com/dani-garcia/vaultwarden>
- **Port:** `8000` (Web UI)

## After Installation

1. Open `http://<your-server-ip>:8000` in your browser
2. Create your account (note: signups are disabled by default after the first account)
3. Download Bitwarden client apps from <https://bitwarden.com/download/>
4. In the Bitwarden client, set the server URL to `http://<your-server-ip>:8000` before logging in

## Services

| Service | Container | Description |
|---------|-----------|-------------|
| `vaultwarden` | `vaultwarden` | Password manager server |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| `8000` | TCP | Web vault UI and API (maps to container port 80) |

## Volumes

| Host Path | Container Path | Description |
|-----------|----------------|-------------|
| `${APPDATA}/vaultwarden` | `/data` | Database, attachments, configuration, RSA keys |

## Environment Variables

### In `config.env`

| Variable | Default | Description |
|----------|---------|-------------|
| `VAULTWARDEN_SERVER` | `vaultwarden/server:1.35.3` | Image tag |

### In `secrets.env` (configured during install)

| Variable | Default | Description |
|----------|---------|-------------|
| `VAULTWARDEN_DOMAIN` | `https://warden.example.com` | Public URL for your Vaultwarden instance |

### In `compose.yaml`

| Variable | Default | Description |
|----------|---------|-------------|
| `DOMAIN` | `${VAULTWARDEN_DOMAIN}` | Public domain (from secrets.env) |
| `SIGNUPS_ALLOWED` | `false` | Whether new signups are allowed |

## Customization

### Enabling Signups

To temporarily allow signups, edit `installed/vaultwarden/compose.yaml`:

```yaml
environment:
  - SIGNUPS_ALLOWED=true
```

Then restart: `homestack restart vaultwarden`. Disable again after creating accounts.

### Enabling Admin Panel

Add the admin token environment variable:

```yaml
environment:
  - DOMAIN=${VAULTWARDEN_DOMAIN}
  - SIGNUPS_ALLOWED=false
  - ADMIN_TOKEN=your-secure-admin-token
```

Access the admin panel at `http://<server-ip>:8000/admin`.

### Setting Up HTTPS

Vaultwarden requires HTTPS for browser extensions and mobile apps. Use a reverse proxy (Caddy/Nginx/Traefik) or set the domain in `secrets.env`:

```env
VAULTWARDEN_DOMAIN=https://warden.yourdomain.com
```

### WebSocket Support

For live sync notifications, enable WebSocket in your reverse proxy configuration. Vaultwarden serves WebSocket on the same port.

### Adding Custom Volumes

```yaml
services:
  vaultwarden:
    volumes:
      - ${APPDATA}/vaultwarden:/data
      - /path/to/ssl-certs:/ssl:ro  # Custom SSL certificates
```

## Data & Backup

- **Backup strategy:** `stop` (containers stop for SQLite consistency)
- **Data location:** `AppData/vaultwarden/`
- **Database:** SQLite at `AppData/vaultwarden/db.sqlite3`
- **RSA keys:** Stored in `AppData/vaultwarden/rsa_key*`

## Tips

- Use a reverse proxy with HTTPS — Bitwarden clients require HTTPS for full functionality
- Set `SIGNUPS_ALLOWED=false` after creating your accounts
- Back up regularly — the database contains all your passwords
- Bitwarden browser extensions, desktop apps, and mobile apps all work with Vaultwarden
- Consider enabling 2FA (TOTP) for your Vaultwarden account

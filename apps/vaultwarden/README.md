# Vaultwarden

Lightweight Bitwarden-compatible password manager server.

**Website:** <https://github.com/dani-garcia/vaultwarden>

## Access

Open `http://<your-server-ip>:8000` in your browser.

## First-Time Setup

1. **Before installing**, decide on your public domain/URL. During installation, you will be prompted for `VAULTWARDEN_DOMAIN` — enter your public HTTPS URL (e.g., `https://vault.yourdomain.com`).
2. After the app starts, open the web UI and click **Create Account** to register your first user.
3. **Important:** New account registration is **disabled by default** (`SIGNUPS_ALLOWED=false` in the compose file). To allow signups:
   - Temporarily edit `installed/vaultwarden/compose.yaml` and set `SIGNUPS_ALLOWED=true`
   - Restart: `homestack restart vaultwarden`
   - Create your account(s)
   - Set it back to `false` and restart again
4. Set up a reverse proxy with HTTPS — Vaultwarden and Bitwarden clients require a secure connection for most features.

## Configuration

The `VAULTWARDEN_DOMAIN` secret in `installed/vaultwarden/secrets.env` must be set to your public URL (e.g., `https://vault.yourdomain.com`).

Edit `installed/vaultwarden/config.env` to change the image version:
- `VAULTWARDEN_SERVER` — Vaultwarden Docker image tag

## Ports

| Host Port | Container Port | Purpose |
|-----------|----------------|---------|
| 8000 | 80 | Web UI and API |

## Data Storage

- **Data & database:** `AppData/vaultwarden/data/`

## Backup

Uses `stop` strategy — containers are stopped before backup to protect the SQLite database.

```bash
homestack backup vaultwarden
```

## Client Apps

Vaultwarden is compatible with all official Bitwarden clients:

- **Browser extensions:** [Chrome](https://chrome.google.com/webstore/detail/bitwarden/nngceckbapebfimnlniiiahkandclblb) / [Firefox](https://addons.mozilla.org/firefox/addon/bitwarden-password-manager/) / [Edge](https://microsoftedge.microsoft.com/addons/detail/bitwarden/jbkfoedolllcefarcelnjpcfdgdjdj)
- **Desktop:** [Bitwarden Desktop](https://bitwarden.com/download/)
- **Mobile:** [Android](https://play.google.com/store/apps/details?id=com.x8bit.bitwarden) / [iOS](https://apps.apple.com/app/bitwarden-password-manager/id1137397744)

When setting up clients, use your custom server URL (e.g., `https://vault.yourdomain.com`) instead of the default Bitwarden cloud.

## Tips

- **HTTPS is required** for browser extensions and mobile apps to work properly. Set up a reverse proxy (Nginx, Caddy, Traefik) with a valid SSL certificate.
- Enable the **admin panel** by setting the `ADMIN_TOKEN` environment variable in the compose file — see [Vaultwarden wiki](https://github.com/dani-garcia/vaultwarden/wiki/Enabling-admin-page).
- Regular backups are critical — this stores all your passwords.

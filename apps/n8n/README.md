# n8n

Workflow automation tool — connect apps and automate tasks with a visual editor.

**Website:** <https://n8n.io>

## Access

Open `http://<your-server-ip>:5678` in your browser.

## First-Time Setup

1. On first visit, create an **owner account** with your email and password.
2. You'll be taken to the workflow editor where you can start building automations.
3. **Important:** Edit `installed/n8n/config.env` and update the following variables to match your domain:
   ```
   N8N_DOMAIN=yourdomain.com
   N8N_SUBDOMAIN=n8n
   ```
   These are used to construct webhook URLs. Restart after changing: `homestack restart n8n`

## Configuration

Edit `installed/n8n/config.env`:

| Variable | Default | Description |
|----------|---------|-------------|
| `N8N_DOMAIN` | `example.com` | Your domain for webhook URLs |
| `N8N_SUBDOMAIN` | `n8n` | Subdomain prefix for webhook URLs |
| `N8N_SERVER` | `n8nio/n8n:2.1.4` | Docker image tag |

## Data Storage

- **Workflow data:** `AppData/n8n/data/`
- **User files:** `AppData/n8n/files/`

## Backup

Uses `stop` strategy — containers are stopped before backup to protect the SQLite database.

```bash
homestack backup n8n
```

## Tips

- Browse the [n8n community nodes](https://n8n.io/integrations/) for hundreds of pre-built integrations.
- For webhooks to work externally, set up a reverse proxy pointing to port 5678 and update the domain config.
- n8n stores workflows in a SQLite database — regular backups are recommended.
- Import community workflow templates from <https://n8n.io/workflows/>.

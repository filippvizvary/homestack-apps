# Immich

Self-hosted photo and video management solution.

- **Official Documentation:** <https://immich.app/docs>
- **GitHub:** <https://github.com/immich-app/immich>
- **Port:** `2283` (Web UI)

## After Installation

1. Open `http://<your-server-ip>:2283` in your browser
2. Create your first admin account
3. Upload photos through the web UI or use the Immich mobile app (iOS/Android)
4. Configure external libraries under **Administration → Libraries**

## Services

| Service | Container | Description |
|---------|-----------|-------------|
| `immich-server` | `immich_server` | Main Immich application + API |
| `immich-machine-learning` | `immich_machine_learning` | AI/ML for face detection, search, tagging |
| `redis` | `immich_redis` | Cache and job queue |
| `database` | `immich_postgres` | PostgreSQL with pgvectors for AI search |

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| `2283` | TCP | Web UI and API |

## Volumes

| Host Path | Container Path | Description |
|-----------|----------------|-------------|
| `${APPDATA}/immich/library` | `/data` | Photo and video library storage |
| `${APPDATA}/immich/ml` | `/cache` | Machine learning model cache |
| `${APPDATA}/immich/redis` | `/data` | Redis persistent data |
| `${APPDATA}/immich/postgres` | `/var/lib/postgresql/data` | PostgreSQL database |

## Environment Variables

### In `config.env`

| Variable | Default | Description |
|----------|---------|-------------|
| `IMMICH_SERVER` | `ghcr.io/immich-app/immich-server:v2.4.1` | Server image tag |
| `IMMICH_ML` | `ghcr.io/immich-app/immich-machine-learning:v2.4.1` | ML image tag |
| `IMMICH_REDIS` | `docker.io/valkey/valkey:9@sha256:...` | Redis/Valkey image (pinned by digest) |
| `IMMICH_POSTGRES` | `ghcr.io/immich-app/postgres:14-...` | PostgreSQL image (pinned by digest) |

### In `secrets.env` (auto-generated)

| Variable | Description |
|----------|-------------|
| `DB_USERNAME` | PostgreSQL username (default: `immich`) |
| `DB_PASSWORD` | PostgreSQL password (auto-generated, 32 chars) |
| `DB_DATABASE_NAME` | PostgreSQL database name (default: `immich`) |

## Customization

### Adding External Photo Storage (NAS Mount)

Edit `installed/immich/compose.yaml` and add a volume to the `immich-server` service:

```yaml
services:
  immich-server:
    volumes:
      - ${APPDATA}/immich/library:/data
      - /mnt/nas/photos:/mnt/photos  # Add your NAS mount
```

Then configure the external library in Immich's web UI under **Administration → External Libraries**.

### Hardware Acceleration

For hardware-accelerated video transcoding, add device mappings:

```yaml
services:
  immich-server:
    devices:
      - /dev/dri:/dev/dri  # Intel Quick Sync / AMD VAAPI
```

### Changing Machine Learning Model

Add environment variable to the ML service:

```yaml
services:
  immich-machine-learning:
    environment:
      - MACHINE_LEARNING_MODEL_NAME=ViT-B-16__openai
```

## Data & Backup

- **Backup strategy:** `stop` (containers stop during backup for database consistency)
- **Data location:** `AppData/immich/`
- **Database:** PostgreSQL data in `AppData/immich/postgres/`

## Tips

- Use the Immich mobile app for automatic photo backup from your phone
- GPU acceleration significantly speeds up face detection and smart search
- The ML model cache (`AppData/immich/ml/`) can be 1–3 GB
- Initial indexing of a large library can take hours

## Description

<!-- What app is this adding/updating? Link to the upstream project. -->

## Type of Change

- [ ] New app
- [ ] Version update
- [ ] Bug fix
- [ ] Other (describe below)

## Checklist

### Required

- [ ] App directory matches the `name` field in `app.yaml`
- [ ] Version is pinned in both `app.yaml` and `config.env` (no `:latest`)
- [ ] `compose.yaml` includes a `healthcheck`
- [ ] `config.env` contains no secrets or passwords
- [ ] All secrets are declared in `app.yaml` with clear `prompt` text

### Tested

- [ ] `homestack install <app>` — installs cleanly
- [ ] `homestack status <app>` — shows healthy
- [ ] `homestack backup <app>` — completes without error
- [ ] `homestack remove <app>` — removes cleanly
- [ ] Web UI is accessible on the declared port

### Optional

- [ ] `backup_strategy` is set appropriately (`stop` for databases)
- [ ] `priority` is set if the app depends on other services
- [ ] Resource limits are configured in `compose.yaml`

# Docker development helper repository

This repository contains several docker-compose configurations and helper scripts to support local development for projects that use Redis, MongoDB, and PostgreSQL. It also includes a helper shell script to start a Rails development environment inside a container.

## Repository layout

- `docker-compose.yml` - top-level compose file (general purpose).
- `docker-dev-start-web.sh` - helper script to prepare and start a Rails development server inside a container.
- `mongodb/docker-compose.yml` - docker-compose for MongoDB.
- `postgresql/docker-compose.yml` - docker-compose for PostgreSQL.
- `postgresql/README.md` - notes about the PostgreSQL compose (if present).
- `redis/docker-compose.yml` - docker-compose for Redis.

There may be other files and folders in this repository used for local development.

## Usage

These examples assume you have Docker and Docker Compose installed on your machine.

### Start a service with docker-compose

From the folder containing the compose file, run:

```bash
docker compose up -d
```

Examples:

- Start MongoDB:

```bash
cd mongodb
docker compose up -d
```

- Start PostgreSQL:

```bash
cd postgresql
docker compose up -d
```

- Start Redis:

```bash
cd redis
docker compose up -d
```

To stop and remove containers, networks and volumes created by the compose file:

```bash
docker compose down -v
```

### Rails helper script: `docker-dev-start-web.sh`

This repository includes a helper script `docker-dev-start-web.sh` intended to run inside a Rails application container to prepare the app for development and start the local dev server. The script performs the following actions:

- Runs RuboCop (auto-correct) and Brakeman (security scanner). Failures are ignored to avoid blocking startup.
- Removes a stale `tmp/pids/server.pid` if present.
- Ensures ownership and permissions for `/app/db` are set to `appuser:appuser` with `775` permissions.
- Runs `bundle` to install Ruby gems.
- If the environment variable `FORCE_DB_CREATE=true` is set, it drops and recreates the Rails databases (including cache, cable, queue).
- Removes `db/schema.rb` and runs `bin/rails db:migrate`.
- If `FORCE_DB_SEED=true` is set, it runs `bin/rails db:seed`.
- Finally it executes `./bin/dev` to start the application (this is commonly the Foreman/Procfile runner used in dev).

Usage example (from inside the Rails container or a service defined in `docker-compose.yml`):

```bash
# Make the script executable (if not already)
chmod +x docker-dev-start-web.sh

# Run normally
./docker-dev-start-web.sh

# Force DB recreate and seed (use carefully — destructive)
FORCE_DB_CREATE=true FORCE_DB_SEED=true ./docker-dev-start-web.sh
```

Note: This script expects to be run in the Rails app directory and assumes the app uses standard Rails binstubs (`bin/rails`, `bin/dev`). Adjust paths or commands if your setup differs.

## Environment and secrets

When running services that need credentials or API keys, do not commit secrets to the repository. Prefer using environment variables, Docker Compose `.env` files (excluded from source control), or Docker secrets where appropriate.

Example `.env` usage with docker compose:

```env
# .env (do not commit)
POSTGRES_PASSWORD=supersecret
POSTGRES_USER=app
POSTGRES_DB=app_development
```

Then `docker compose` will automatically pick up variables from `.env` in the same directory as the compose file.

## Tips

- If you run into permission issues for mounted volumes, ensure the container user and host user are compatible or adjust ownership inside the container as the script does for `/app/db`.
- Use `docker compose logs -f <service>` to follow logs while developing.
- If you need to run a one-off Rails command:

```bash
docker compose run --rm web bin/rails console
```

## Contributing

If you add or change compose files or helper scripts, please update this README with notes about how to use them and any required environment variables.

---

If you'd like, I can also:

- Add a short example `docker-compose.yml` to orchestrate the Rails app with PostgreSQL/Redis.
- Add a small `Makefile` with common commands (up, down, logs, console).
- Translate or expand any section to Portuguese.

Tell me which of those you'd like next.

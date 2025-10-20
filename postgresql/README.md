# Docker PostgreSQL Setup

This project provides a simple Docker setup for running PostgreSQL database in a containerized environment.

## Prerequisites

- Docker
- Docker Compose

## Configuration

The project uses environment variables for configuration. Create a `.env` file with the following variables:

```env
POSTGRES_USER=your_user
POSTGRES_PASSWORD=your_password
POSTGRES_DB=your_database
```

## Usage

To start the PostgreSQL container:

```bash
docker-compose up -d
```

To stop the container:

```bash
docker-compose down
```

## Connection Details

- **Host**: localhost
- **Port**: 5432 (default PostgreSQL port)
- **Database**: As specified in POSTGRES_DB
- **Username**: As specified in POSTGRES_USER
- **Password**: As specified in POSTGRES_PASSWORD

## License

MIT

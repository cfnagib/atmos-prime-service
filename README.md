# Atmos Prime Service

FastAPI microservice for prime number generation and PostgreSQL logging.

## Quick Start
Run the entire stack using Docker Compose:
```bash
docker-compose up --build
```
- API: http://localhost:8000
- Docs: http://localhost:8000/docs

## API Endpoints
- **POST /primes**: Generate primes in a range.
- **GET /history**: Get all computation logs.

## Tech Stack
- Python 3.13 (FastAPI)
- PostgreSQL 16
- Docker & Docker Compose

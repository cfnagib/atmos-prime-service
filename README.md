# Atmos Prime Service

FastAPI microservice for prime number generation and PostgreSQL logging.

## Quick Start
Run the entire stack using Docker Compose:
```bash
docker-compose up --build
```
API will be available at: `http://localhost:8000`
Interactive docs: `http://localhost:8000/docs`

## API Endpoints
- **POST /primes**: Generate primes in a range.
  - Body: `{"start": 1, "end": 100}`
- **GET /history**: Get all computation logs.

## Tech Stack
- Python 3.13 (FastAPI)
- PostgreSQL 16
- SQLAlchemy (ORM)
- Docker & Docker Compose

## Implementation
- **Algorithm**: Sieve of Eratosthenes for efficient range calculation.
- **Database**: Automatic execution logging for audit purposes.

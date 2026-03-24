# Atmos Prime Service

A microservice built with FastAPI to generate prime numbers within a given range and log each execution to a PostgreSQL database.

## Quick Start (Docker Compose)
The easiest way to run the entire stack is via Docker Compose:
```bash
docker-compose up --build
```

## Manual Setup (Optional)
1. Install dependencies: `pip install -r requirements.txt`
2. Configure environment:
   Create a .env file in the root directory with the following content:
   DATABASE_URL=postgresql+psycopg://atmos:atmospass@localhost:5432/primesdb
3. Run the application: `uvicorn app.main:app --reload`

## API Endpoints
- **POST /primes**: Calculates primes in a given range.
  - Body: `{"start": 1, "end": 100}`
- **GET /history**: Retrieves all computation logs from the database.

## Technical Stack
- Python 3.13 (FastAPI)
- PostgreSQL 16
- SQLAlchemy (ORM)
- Docker & Docker Compose

# Atmos Prime Service

A microservice that generates prime numbers within a given range and logs each execution to a PostgreSQL database.

## Features

- REST API to generate prime numbers for a given range
- Stores every request in a PostgreSQL database
- Execution history available via API

## Tech Stack

- Python 3.14
- FastAPI
- PostgreSQL 16
- SQLAlchemy
- Docker

## Project Structure

```
atmos-prime-service/
├── app/
│   ├── main.py        # API endpoints
│   ├── prime.py       # Prime number generator (Sieve of Eratosthenes)
│   ├── models.py      # Database models
│   └── database.py    # Database connection and config
├── requirements.txt
├── .env
└── README.md
```

## Getting Started

### Prerequisites

- Python 3.14+
- Docker

### 1. Start the PostgreSQL container

```bash
docker run --name atmos-postgres \
  -e POSTGRES_USER=atmos \
  -e POSTGRES_PASSWORD=atmospass \
  -e POSTGRES_DB=primesdb \
  -p 5432:5432 \
  -d postgres:16
```

### 2. Create and activate a virtual environment

```bash
python3 -m venv venv
source venv/bin/activate
```


### 3. Install dependencies
```bash
pip install -r requirements.txt
```

### 4. Configure environment
```markdown
Create a .env file in the project root:

DATABASE_URL=postgresql://atmos:atmospass@localhost:5432/primesdb
```


### 5. Run the service
```bash
uvicorn app.main:app --reload
```
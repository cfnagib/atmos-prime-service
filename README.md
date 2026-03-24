cat <<EOF > README.md
# Atmos Prime Service

A microservice built with FastAPI to generate prime numbers and log executions to a PostgreSQL database.

## Features
- **Efficient Prime Generation**: Uses the Sieve of Eratosthenes.
- **Data Persistence**: Stores every range request and result count in PostgreSQL.
- **RESTful API**: Clean endpoints for calculation and history.

## Tech Stack
- Python 3.13 (FastAPI)
- PostgreSQL 16
- SQLAlchemy & Pydantic

## Getting Started
### Running with Docker Compose
\`\`\`bash
docker-compose up --build
\`\`\`

## API Endpoints
- **POST \`/primes\`**: Input range (e.g., \`{"start": 1, "end": 10}\`).
- **GET \`/history\`**: Fetch all previous records.
- **GET \`/docs\`**: Interactive Swagger documentation.
EOF
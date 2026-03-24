cat <<EOF > README.md
# Atmos Prime Service

This microservice provides an endpoint to generate prime numbers within a specific range and maintains an execution log in PostgreSQL. It was built as part of the Atmos Space Cargo technical assessment.

## Project Logic & Design
- **Algorithm**: I chose the **Sieve of Eratosthenes** for prime generation. Given the nature of range-based queries, it offers the best balance between complexity and speed ($O(n \log \log n)$).
- **Architecture**: The project follows a standard FastAPI structure, separating the database session management from the core logic to ensure maintainability.

## Quick Start (Docker Compose)
The easiest way to get the stack running is via Docker:
\`\`\`bash
docker-compose up --build
\`\`\`
The API will be available at \`http://localhost:8000\`.

## API Usage

### 1. Generate Primes
- **Endpoint**: \`POST /primes\`
- **Request Body**:
  \`\`\`json
  {
    "start": 1,
    "end": 20
  }
  \`\`\`
- **Response**: \`{"primes": [2, 3, 5, 7, 11, 13, 17, 19], "count": 8}\`

### 2. Check History
- **Endpoint**: \`GET /history\`
- **Description**: Returns a JSON list of all previous calculations stored in the database.

## Technical Stack
- Python 3.13 (FastAPI)
- PostgreSQL 16
- SQLAlchemy (ORM)
- Docker & Docker Compose

## Repository Layout
\`\`\`text
.
├── app/
│   ├── main.py        # Entry point & Routes
│   ├── prime.py       # Sieve algorithm implementation
│   ├── models.py      # SQLAlchemy schemas
│   └── database.py    # Session & Engine config
├── Dockerfile         # App containerization
├── docker-compose.yml # Orchestration (App + DB)
├── requirements.txt
└── README.md
\`\`\`

## Local Development (Without Docker)
1. Install dependencies: \`pip install -r requirements.txt\`
2. Set up a \`.env\` file with your \`DATABASE_URL\`.
3. Run the server: \`uvicorn app.main:app --reload\`
EOF
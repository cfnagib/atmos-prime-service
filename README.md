cat <<EOF > README.md
# Atmos Prime Service

A robust microservice designed to generate prime numbers within a user-defined range and persist execution logs in a PostgreSQL database.

## Features
- **Efficient Generation**: Uses the Sieve of Eratosthenes algorithm for optimal performance (\$O(n \log \log n)\$).
- **Persistence**: Every execution is logged in a PostgreSQL database for audit and history.
- **API Access**: Fully documented RESTful API built with FastAPI.
- **Containerized**: Production-ready configuration using Docker and Docker Compose.

## Tech Stack
- **Language**: Python 3.13
- **Framework**: FastAPI
- **Database**: PostgreSQL 16
- **ORM**: SQLAlchemy
- **Infrastructure**: Docker & Docker Compose

## API Documentation
Once the service is running, you can access the interactive Swagger UI at \`http://localhost:8000/docs\`.

### Endpoints:
- **POST \`/primes\`**: Generates prime numbers in a given range.
  - **Payload**: \`{"start": 1, "end": 10}\`
  - **Response**: \`{"primes": [2, 3, 5, 7], "count": 4, "timestamp": "2026-03-24T..."}\`
- **GET \`/history\`**: Returns the list of all previous execution logs from the database.

## Project Structure
\`\`\`text
atmos-prime-service/
├── app/
│   ├── main.py        # API endpoints and application logic
│   ├── prime.py       # Optimized Prime number generator
│   ├── models.py      # SQLAlchemy database models
│   └── database.py    # Database connection and session management
├── Dockerfile         # Docker image configuration
├── docker-compose.yml # Orchestration for the App and Database
├── requirements.txt   # Project dependencies
├── .env               # Environment variables (DB credentials)
└── README.md          # Project documentation
\`\`\`

## Getting Started

### Option 1: Using Docker Compose (Recommended)
1. **Clone the repository.**
2. **Run the entire stack:**
   \`\`\`bash
   docker-compose up --build
   \`\`\`
*This will automatically provision the PostgreSQL database and start the FastAPI service.*

### Option 2: Manual Setup (Development)
1. **Prerequisites**: Python 3.13 and a running PostgreSQL 16 instance.
2. **Virtual Environment**:
   \`\`\`bash
   python3 -m venv venv
   source venv/bin/activate
   \`\`\`
3. **Install Dependencies**:
   \`\`\`bash
   pip install -r requirements.txt
   \`\`\`
4. **Environment Configuration**: Create a \`.env\` file with your \`DATABASE_URL\`.
5. **Run the Service**:
   \`\`\`bash
   uvicorn app.main:app --reload
   \`\`\`
EOF

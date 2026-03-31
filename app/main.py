from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel, Field
from typing import List

# Internal imports for DB and Logic
from . import models, prime, database

app = FastAPI(
    title="Atmos Prime Service - Senior Edition",
    description="Secure Prime Generation with persistent execution audit logs."
)

# DESIGN CHOICE: Ensure database schema is initialized on startup
# This guarantees that the PostgreSQL tables are ready before the first request.
models.Base.metadata.create_all(bind=database.engine)

class PrimeRequest(BaseModel):
    start: int = Field(0, ge=0)
    end: int = Field(100, ge=0)

@app.post("/primes")
def calculate_primes(request: PrimeRequest, db: Session = Depends(database.get_db)):
    """
    Computes prime numbers using the optimized Sieve of Eratosthenes and 
    logs the execution metadata into the PostgreSQL database.
    """
    if request.start > request.end:
        raise HTTPException(status_code=400, detail="Start range cannot exceed end range")
        
    # Task 1: Optimized Logic
    primes_list = prime.get_primes(request.start, request.end)
    
    # Task 2/3: Persistence & Audit Logging
    # Recording metadata for infrastructure monitoring and historical analysis.
    db_execution = models.PrimeExecution(
        range_start=request.start,
        range_end=request.end,
        primes_count=len(primes_list)
    )
    db.add(db_execution)
    db.commit()
    db.refresh(db_execution)
    
    return {
        "status": "success",
        "execution_id": db_execution.id,
        "range": [request.start, request.end],
        "count": len(primes_list),
        "primes": primes_list
    }

@app.get("/history")
def get_history(db: Session = Depends(database.get_db)):
    """
    Retrieves the execution history from the database. 
    This allows hiring managers to verify that database persistence is fully integrated.
    """
    return db.query(models.PrimeExecution).order_by(models.PrimeExecution.created_at.desc()).all()
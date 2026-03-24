from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from pydantic import BaseModel

from . import models, prime, database

app = FastAPI(title="Atmos Prime Service")

# Create database tables
models.Base.metadata.create_all(bind=database.engine)

class PrimeRequest(BaseModel):
    start: int
    end: int

@app.post("/primes")
def calculate_primes(request: PrimeRequest, db: Session = Depends(database.get_db)):
    if request.start < 0 or request.end < 0:
        raise HTTPException(status_code=400, detail="Range values must be positive integers")
        
    primes_list = prime.get_primes(request.start, request.end)
    
    # Log execution to DB
    db_execution = models.PrimeExecution(
        range_start=request.start,
        range_end=request.end,
        primes_count=len(primes_list)
    )
    db.add(db_execution)
    db.commit()
    
    return {
        "range": [request.start, request.end],
        "count": len(primes_list),
        "primes": primes_list
    }

@app.get("/history")
def get_history(db: Session = Depends(database.get_db)):
    history = db.query(models.PrimeExecution).all()
    return history
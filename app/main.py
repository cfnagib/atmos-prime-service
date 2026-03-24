from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import Base, engine, get_db
from app.models import ExecutionLog
from app.prime import get_primes

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Atmos Prime Service")


@app.get("/primes")
def primes(start: int, end: int, db: Session = Depends(get_db)):
    if start < 0 or end < 0:
        raise HTTPException(status_code=400, detail="Range values must be non-negative")
    if start > end:
        raise HTTPException(status_code=400, detail="start must be less than or equal to end")

    result = get_primes(start, end)

    log = ExecutionLog(
        start=start,
        end=end,
        result=",".join(map(str, result))
    )
    db.add(log)
    db.commit()

    return {"start": start, "end": end, "primes": result, "count": len(result)}


@app.get("/history")
def history(db: Session = Depends(get_db)):
    logs = db.query(ExecutionLog).order_by(ExecutionLog.executed_at.desc()).all()
    return [
        {
            "id": log.id,
            "start": log.start,
            "end": log.end,
            "primes": log.result,
            "executed_at": log.executed_at
        }
        for log in logs
    ]

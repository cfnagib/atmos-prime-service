from sqlalchemy import Column, Integer, DateTime
from datetime import datetime, timezone
from .database import Base

class PrimeExecution(Base):
    __tablename__ = "prime_executions"

    id = Column(Integer, primary_key=True, index=True)
    range_start = Column(Integer)
    range_end = Column(Integer)
    primes_count = Column(Integer)
    # Using timezone-aware UTC datetime (Best practice for Python 3.12+)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
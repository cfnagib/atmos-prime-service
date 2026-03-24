from sqlalchemy import Column, Integer, String, DateTime
from datetime import datetime, timezone
from app.database import Base


class ExecutionLog(Base):
    __tablename__ = "execution_logs"

    id = Column(Integer, primary_key=True, index=True)
    start = Column(Integer, nullable=False)
    end = Column(Integer, nullable=False)
    result = Column(String, nullable=False)
    executed_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

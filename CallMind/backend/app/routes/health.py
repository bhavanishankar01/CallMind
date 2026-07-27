from fastapi import APIRouter
from datetime import datetime
from ..config import settings
from ..models.schemas import HealthResponse

router = APIRouter()

@router.get("/health", response_model=HealthResponse)
async def health_check():
    return HealthResponse(
        status="healthy",
        timestamp=datetime.utcnow(),
        provider=settings.CALL_PROVIDER,
        environment=settings.APP_ENV,
    )

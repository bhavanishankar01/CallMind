import logging
from fastapi import APIRouter, Request
from typing import Dict, Any
from ..providers.factory import get_call_provider

logger = logging.getLogger("callmind.webhooks")
router = APIRouter(prefix="/webhooks", tags=["Webhooks"])

@router.post("/calls")
async def handle_call_webhook(request: Request):
    """Callback endpoint receiving status updates from Twilio/Exotel telephony providers."""
    try:
        payload = await request.form()
        data = dict(payload)
    except Exception:
        data = await request.json()

    logger.info(f"Received Call Telephony Webhook Payload: {data}")
    provider = get_call_provider()
    result = await provider.handle_webhook(data)
    return {"status": "success", "result": result}

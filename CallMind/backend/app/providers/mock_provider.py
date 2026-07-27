import logging
import uuid
from datetime import datetime
from typing import Dict, Any, Optional
from .base import CallProvider

logger = logging.getLogger("callmind.providers.mock")

def mask_phone_number(phone: str) -> str:
    """Masks phone number for privacy compliance in logs (e.g. +14****2671)."""
    if len(phone) <= 6:
        return "****"
    return f"{phone[:3]}****{phone[-4:]}"

class MockCallProvider(CallProvider):
    def __init__(self):
        self._active_calls = {}

    async def make_call(
        self,
        to_phone: str,
        message: str,
        language: str = "English",
        callback_url: Optional[str] = None,
    ) -> Dict[str, Any]:
        call_id = f"mock_call_{uuid.uuid4().hex[:10]}"
        masked_phone = mask_phone_number(to_phone)

        logger.info("==================================================")
        logger.info("[MOCK CALL PROVIDER] Automated Voice Call Initiated")
        logger.info(f"  Call ID:   {call_id}")
        logger.info(f"  Recipient: {masked_phone}")
        logger.info(f"  Language:  {language}")
        logger.info(f"  Message:   \"{message}\"")
        logger.info("==================================================")

        call_record = {
            "provider_call_id": call_id,
            "to_phone_masked": masked_phone,
            "status": "answered",  # Mock auto-answers for testing
            "started_at": datetime.utcnow().isoformat(),
            "ended_at": datetime.utcnow().isoformat(),
            "message": message,
            "provider": "mock",
        }
        self._active_calls[call_id] = call_record

        return {
            "status": "initiated",
            "provider_call_id": call_id,
            "provider": "mock",
            "masked_phone": masked_phone,
        }

    async def get_call_status(self, provider_call_id: str) -> Dict[str, Any]:
        return self._active_calls.get(
            provider_call_id,
            {"provider_call_id": provider_call_id, "status": "completed", "provider": "mock"},
        )

    async def handle_webhook(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        return {"status": "success", "provider": "mock", "message": "Mock webhook processed"}

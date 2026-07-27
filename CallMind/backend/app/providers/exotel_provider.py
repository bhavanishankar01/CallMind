import logging
from typing import Dict, Any, Optional
from .base import CallProvider
from ..config import settings

logger = logging.getLogger("callmind.providers.exotel")

try:
    import httpx
    _httpx_available = True
except ImportError:
    _httpx_available = False

class ExotelCallProvider(CallProvider):
    def __init__(self):
        self.account_sid = settings.EXOTEL_ACCOUNT_SID
        self.api_key = settings.EXOTEL_API_KEY
        self.api_token = settings.EXOTEL_API_TOKEN
        self.from_phone = settings.EXOTEL_PHONE_NUMBER

    async def make_call(
        self,
        to_phone: str,
        message: str,
        language: str = "English",
        callback_url: Optional[str] = None,
    ) -> Dict[str, Any]:
        if not _httpx_available:
            raise RuntimeError("httpx package is required for Exotel provider integration.")
            
        if not self.account_sid or not self.api_key or not self.api_token:
            raise RuntimeError("Exotel credentials not configured in environment.")

        url = f"https://{self.api_key}:{self.api_token}@api.exotel.com/v1/Accounts/{self.account_sid}/Calls/connect.json"
        
        data = {
            "From": self.from_phone,
            "To": to_phone,
            "CallerId": self.from_phone,
            "Url": callback_url or "http://my.exotel.in/exoml/start_voice",
            "CallType": "trans",
        }

        async with httpx.AsyncClient() as client:
            res = await client.post(url, data=data)
            if res.status_code not in (200, 201):
                logger.error(f"Exotel API Call Error: {res.text}")
                raise RuntimeError(f"Exotel call failure: {res.status_code}")

            body = res.json()
            call_sid = body.get("Call", {}).get("Sid", "")
            return {
                "status": "initiated",
                "provider_call_id": call_sid,
                "provider": "exotel",
            }

    async def get_call_status(self, provider_call_id: str) -> Dict[str, Any]:
        return {"provider_call_id": provider_call_id, "status": "completed", "provider": "exotel"}

    async def handle_webhook(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        return {"status": "processed", "provider": "exotel"}

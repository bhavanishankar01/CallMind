import logging
import urllib.parse
from typing import Dict, Any, Optional
from .base import CallProvider
from ..config import settings

logger = logging.getLogger("callmind.providers.twilio")

try:
    from twilio.rest import Client
    _twilio_available = True
except ImportError:
    _twilio_available = False

class TwilioCallProvider(CallProvider):
    def __init__(self):
        if not _twilio_available:
            logger.warning("Twilio SDK not installed. Ensure twilio package is installed.")
            self.client = None
            return

        if settings.TWILIO_ACCOUNT_SID and settings.TWILIO_AUTH_TOKEN:
            self.client = Client(settings.TWILIO_ACCOUNT_SID, settings.TWILIO_AUTH_TOKEN)
            self.from_phone = settings.TWILIO_PHONE_NUMBER
        else:
            self.client = None
            logger.warning("Twilio credentials not configured in environment.")

    async def make_call(
        self,
        to_phone: str,
        message: str,
        language: str = "English",
        callback_url: Optional[str] = None,
    ) -> Dict[str, Any]:
        if not self.client or not self.from_phone:
            raise RuntimeError("Twilio client is not configured with credentials.")

        # Construct TwiML Voice payload
        encoded_msg = urllib.parse.quote(message)
        twiml_url = f"http://twimlets.com/message?Message%5B0%5D={encoded_msg}"

        call = self.client.calls.create(
            to=to_phone,
            from_=self.from_phone,
            url=twiml_url,
            status_callback=callback_url,
            status_callback_event=['initiated', 'ringing', 'answered', 'completed'],
        )

        return {
            "status": "initiated",
            "provider_call_id": call.sid,
            "provider": "twilio",
        }

    async def get_call_status(self, provider_call_id: str) -> Dict[str, Any]:
        if not self.client:
            return {"provider_call_id": provider_call_id, "status": "unknown"}

        call = self.client.calls(provider_call_id).fetch()
        return {
            "provider_call_id": call.sid,
            "status": call.status,
            "duration": call.duration,
            "price": call.price,
        }

    async def handle_webhook(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        call_sid = payload.get("CallSid")
        call_status = payload.get("CallStatus")
        logger.info(f"Twilio Webhook Received: Sid={call_sid}, Status={call_status}")
        return {"status": "processed", "call_sid": call_sid, "call_status": call_status}

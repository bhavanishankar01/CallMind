import logging
from .base import CallProvider
from .mock_provider import MockCallProvider
from .twilio_provider import TwilioCallProvider
from .exotel_provider import ExotelCallProvider
from ..config import settings

logger = logging.getLogger("callmind.providers.factory")

def get_call_provider() -> CallProvider:
    provider_name = settings.CALL_PROVIDER.lower().strip()
    
    if provider_name == "twilio":
        logger.info("Initializing TwilioCallProvider")
        return TwilioCallProvider()
    elif provider_name == "exotel":
        logger.info("Initializing ExotelCallProvider")
        return ExotelCallProvider()
    else:
        logger.info("Initializing MockCallProvider (Development Mode)")
        return MockCallProvider()

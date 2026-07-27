from abc import ABC, abstractmethod
from typing import Dict, Any, Optional

class CallProvider(ABC):
    @abstractmethod
    async def make_call(
        self,
        to_phone: str,
        message: str,
        language: str = "English",
        callback_url: Optional[str] = None,
    ) -> Dict[str, Any]:
        """Initiates an automated voice phone call to recipient."""
        pass

    @abstractmethod
    async def get_call_status(self, provider_call_id: str) -> Dict[str, Any]:
        """Retrieves status of call from provider."""
        pass

    @abstractmethod
    async def handle_webhook(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        """Processes incoming provider callback webhooks."""
        pass

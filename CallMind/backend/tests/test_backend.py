import unittest
import asyncio
from datetime import datetime, timedelta

from app.services.voice_service import VoiceService
from app.providers.mock_provider import MockCallProvider
from app.providers.factory import get_call_provider
from app.config import settings

class TestCallMindBackend(unittest.TestCase):

    def test_voice_service_multilingual(self):
        script_en = VoiceService.generate_reminder_script("Alex", "Submit report", "English")
        self.assertIn("Alex", script_en)
        self.assertIn("Submit report", script_en)

        script_ta = VoiceService.generate_reminder_script("Alex", "மருந்து சாப்பிடு", "Tamil")
        self.assertIn("நினைவூட்டல்", script_ta)

        script_hi = VoiceService.generate_reminder_script("Alex", "रिपोर्ट सबमिट करें", "Hindi")
        self.assertIn("रिमाइंडर", script_hi)

    def test_mock_call_provider(self):
        provider = MockCallProvider()
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
        res = loop.run_until_complete(
            provider.make_call("+14155552671", "Test reminder message", "English")
        )
        self.assertEqual(res["status"], "initiated")
        self.assertEqual(res["provider"], "mock")
        self.assertIn("****2671", res["masked_phone"])

    def test_provider_factory(self):
        provider = get_call_provider()
        self.assertIsInstance(provider, MockCallProvider)

if __name__ == "__main__":
    unittest.main()

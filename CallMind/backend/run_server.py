import asyncio
import logging
from datetime import datetime
from app.scheduler.reminder_scheduler import scheduler_instance
from app.providers.factory import get_call_provider
from app.services.voice_service import VoiceService

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("callmind.standalone")

async def run_standalone_demo():
    logger.info("==================================================")
    logger.info("  Starting CallMind AI Voice Reminder Server Demo  ")
    logger.info("==================================================")

    # 1. Start Server Scheduler
    scheduler_instance.start()

    logger.info("Scheduler worker active. Checking for due reminders...")
    await asyncio.sleep(2)

    # 2. Trigger test voice call
    logger.info("Dispatching test voice call for reminder: 'Drink water'")
    provider = get_call_provider()
    script = VoiceService.generate_reminder_script(
        user_name="Alex Morgan",
        reminder_title="Drink water",
        language="English",
    )

    result = await provider.make_call(
        to_phone="+14155552671",
        message=script,
        language="English",
    )

    logger.info(f"Test Call Dispatch Result: {result}")
    
    # Let scheduler run for 5 seconds to demonstrate loop execution
    await asyncio.sleep(5)

    scheduler_instance.stop()
    logger.info("Standalone demo complete.")

if __name__ == "__main__":
    asyncio.run(run_standalone_demo())

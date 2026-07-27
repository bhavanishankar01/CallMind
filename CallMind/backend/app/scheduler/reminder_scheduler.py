import asyncio
import logging
from datetime import datetime, timedelta
from typing import List, Dict, Any

from ..providers.factory import get_call_provider
from ..services.voice_service import VoiceService

logger = logging.getLogger("callmind.scheduler")

# In-memory storage resilient lock map to prevent duplicate execution across async threads
_processing_lock_ids = set()

# In-memory mock database store for standalone backend testing
mock_reminders_db: List[Dict[str, Any]] = [
    {
        "id": "rem_test_due_01",
        "userId": "mock_user_123",
        "title": "Drink water",
        "notes": "Take a 500ml glass of water.",
        "scheduledAt": (datetime.utcnow() - timedelta(minutes=1)).isoformat() + "Z",
        "timezone": "Asia/Kolkata",
        "reminderType": "aiCall",
        "repeatType": "Never",
        "language": "English",
        "status": "scheduled",
        "retryEnabled": True,
        "retryDelayMinutes": 5,
        "retryCount": 0,
        "maxRetries": 2,
        "createdAt": datetime.utcnow().isoformat() + "Z",
        "updatedAt": datetime.utcnow().isoformat() + "Z",
        "userPhone": "+14155552671",
        "userName": "Alex Morgan",
    }
]

class ReminderScheduler:
    def __init__(self, interval_seconds: int = 15):
        self.interval_seconds = interval_seconds
        self.provider = get_call_provider()
        self._is_running = False
        self._task = None

    def start(self):
        if not self._is_running:
            self._is_running = True
            self._task = asyncio.create_task(self._scheduler_loop())
            logger.info("ReminderScheduler background worker started.")

    def stop(self):
        self._is_running = False
        if self._task:
            self._task.cancel()
            logger.info("ReminderScheduler background worker stopped.")

    async def _scheduler_loop(self):
        while self._is_running:
            try:
                await self.check_and_trigger_due_reminders()
            except Exception as e:
                logger.error(f"Scheduler execution loop error: {e}", exc_info=True)
            await asyncio.sleep(self.interval_seconds)

    async def check_and_trigger_due_reminders(self):
        now_utc = datetime.utcnow()
        
        for reminder in mock_reminders_db:
            reminder_id = reminder["id"]
            status = reminder["status"]
            scheduled_str = reminder["scheduledAt"].replace("Z", "")
            scheduled_dt = datetime.fromisoformat(scheduled_str)

            # Condition: Due and Scheduled
            if scheduled_dt <= now_utc and status == "scheduled":
                
                # Atomic Claim Lock: Prevent duplicate call execution
                if reminder_id in _processing_lock_ids:
                    logger.debug(f"Reminder {reminder_id} is already locked by another process. Skipping.")
                    continue

                _processing_lock_ids.add(reminder_id)
                reminder["status"] = "processing"
                reminder["updatedAt"] = now_utc.isoformat() + "Z"
                
                logger.info(f"⚡ Claimed reminder {reminder_id} for processing. Title: \"{reminder['title']}\"")

                # Trigger Call Pipeline
                try:
                    await self._process_single_reminder_call(reminder)
                finally:
                    _processing_lock_ids.remove(reminder_id)

    async def _process_single_reminder_call(self, reminder: Dict[str, Any]):
        user_name = reminder.get("userName", "Alex")
        user_phone = reminder.get("userPhone", "+14155552671")
        title = reminder["title"]
        language = reminder.get("language", "English")

        # 1. Generate Voice Script
        speech_text = VoiceService.generate_reminder_script(
            user_name=user_name,
            reminder_title=title,
            language=language,
        )

        # 2. Dispatch Call to Provider
        reminder["status"] = "calling"
        reminder["lastCallAt"] = datetime.utcnow().isoformat() + "Z"

        try:
            result = await self.provider.make_call(
                to_phone=user_phone,
                message=speech_text,
                language=language,
            )
            
            logger.info(f"✅ Voice Call Dispatched Successfully: {result}")
            
            # 3. Update Status to Completed (or handle retry if unanswered)
            reminder["status"] = "completed"
            reminder["completedAt"] = datetime.utcnow().isoformat() + "Z"
            reminder["updatedAt"] = datetime.utcnow().isoformat() + "Z"

        except Exception as e:
            logger.error(f"❌ Call dispatch failed for reminder {reminder['id']}: {e}")
            
            # Handle Retry Logic (Phase 7)
            retry_count = reminder.get("retryCount", 0)
            max_retries = reminder.get("maxRetries", 2)
            retry_enabled = reminder.get("retryEnabled", True)
            retry_delay = reminder.get("retryDelayMinutes", 10)

            if retry_enabled and retry_count < max_retries:
                reminder["retryCount"] = retry_count + 1
                next_call = datetime.utcnow() + timedelta(minutes=retry_delay)
                reminder["scheduledAt"] = next_call.isoformat() + "Z"
                reminder["status"] = "scheduled"
                reminder["updatedAt"] = datetime.utcnow().isoformat() + "Z"
                logger.info(f"🔄 Rescheduled retry attempt {retry_count + 1}/{max_retries} for {next_call.isoformat()}Z")
            else:
                reminder["status"] = "failed"
                reminder["updatedAt"] = datetime.utcnow().isoformat() + "Z"

scheduler_instance = ReminderScheduler()

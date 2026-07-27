import uuid
from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, status
from typing import List, Dict, Any

from ..models.schemas import ReminderCreate, ReminderUpdate, ReminderResponse
from ..utils.auth import verify_firebase_token
from ..scheduler.reminder_scheduler import mock_reminders_db
from ..providers.factory import get_call_provider
from ..services.voice_service import VoiceService

router = APIRouter(prefix="/reminders", tags=["Reminders"])

@router.get("", response_model=List[ReminderResponse])
async def list_reminders(user_context: Dict[str, Any] = Depends(verify_firebase_token)):
    user_id = user_context.get("uid", "mock_user_123")
    user_reminders = [r for r in mock_reminders_db if r["userId"] == user_id]
    return user_reminders

@router.post("", response_model=ReminderResponse, status_code=status.HTTP_201_CREATED)
async def create_reminder(
    payload: ReminderCreate,
    user_context: Dict[str, Any] = Depends(verify_firebase_token),
):
    user_id = user_context.get("uid", "mock_user_123")
    now_str = datetime.utcnow().isoformat() + "Z"

    reminder_dict = {
        "id": f"rem_{uuid.uuid4().hex[:8]}",
        "userId": user_id,
        "title": payload.title,
        "notes": payload.notes,
        "scheduledAt": payload.scheduledAt.isoformat() + "Z",
        "timezone": payload.timezone,
        "reminderType": payload.reminderType,
        "repeatType": payload.repeatType,
        "language": payload.language,
        "status": "scheduled",
        "retryEnabled": payload.retryEnabled,
        "retryDelayMinutes": payload.retryDelayMinutes,
        "retryCount": 0,
        "maxRetries": 2,
        "createdAt": now_str,
        "updatedAt": now_str,
        "userPhone": user_context.get("phone", "+14155552671"),
        "userName": user_context.get("name", "Alex Morgan"),
    }

    mock_reminders_db.insert(0, reminder_dict)
    return reminder_dict

@router.get("/{reminder_id}", response_model=ReminderResponse)
async def get_reminder(
    reminder_id: str,
    user_context: Dict[str, Any] = Depends(verify_firebase_token),
):
    for r in mock_reminders_db:
        if r["id"] == reminder_id:
            return r
    raise HTTPException(status_code=404, detail="Reminder not found")

@router.put("/{reminder_id}", response_model=ReminderResponse)
async def update_reminder(
    reminder_id: str,
    payload: ReminderUpdate,
    user_context: Dict[str, Any] = Depends(verify_firebase_token),
):
    for r in mock_reminders_db:
        if r["id"] == reminder_id:
            update_data = payload.dict(exclude_unset=True)
            for k, v in update_data.items():
                if k == "scheduledAt" and v:
                    r[k] = v.isoformat() + "Z"
                elif v is not None:
                    r[k] = v
            r["updatedAt"] = datetime.utcnow().isoformat() + "Z"
            return r
    raise HTTPException(status_code=404, detail="Reminder not found")

@router.delete("/{reminder_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_reminder(
    reminder_id: str,
    user_context: Dict[str, Any] = Depends(verify_firebase_token),
):
    global mock_reminders_db
    before_count = len(mock_reminders_db)
    mock_reminders_db = [r for r in mock_reminders_db if r["id"] != reminder_id]
    if len(mock_reminders_db) == before_count:
        raise HTTPException(status_code=404, detail="Reminder not found")
    return None

@router.post("/{reminder_id}/cancel", response_model=ReminderResponse)
async def cancel_reminder(
    reminder_id: str,
    user_context: Dict[str, Any] = Depends(verify_firebase_token),
):
    for r in mock_reminders_db:
        if r["id"] == reminder_id:
            r["status"] = "cancelled"
            r["updatedAt"] = datetime.utcnow().isoformat() + "Z"
            return r
    raise HTTPException(status_code=404, detail="Reminder not found")

@router.post("/{reminder_id}/trigger", response_model=Dict[str, Any])
async def trigger_test_reminder_call(
    reminder_id: str,
    user_context: Dict[str, Any] = Depends(verify_firebase_token),
):
    """Internal test endpoint to force dispatch a voice call immediately."""
    target_reminder = None
    for r in mock_reminders_db:
        if r["id"] == reminder_id:
            target_reminder = r
            break

    if not target_reminder:
        raise HTTPException(status_code=404, detail="Reminder not found")

    provider = get_call_provider()
    script = VoiceService.generate_reminder_script(
        user_name=target_reminder.get("userName", "Alex"),
        reminder_title=target_reminder["title"],
        language=target_reminder.get("language", "English"),
    )

    result = await provider.make_call(
        to_phone=target_reminder.get("userPhone", "+14155552671"),
        message=script,
        language=target_reminder.get("language", "English"),
    )

    target_reminder["status"] = "calling"
    target_reminder["lastCallAt"] = datetime.utcnow().isoformat() + "Z"
    target_reminder["updatedAt"] = datetime.utcnow().isoformat() + "Z"

    return {
        "message": "Instant test call dispatched successfully",
        "reminder_id": reminder_id,
        "call_result": result,
    }

from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class ReminderBase(BaseModel):
    title: str = Field(..., example="Submit project report")
    notes: Optional[str] = Field(default="", example="Submit final PDF to guide")
    scheduledAt: datetime = Field(..., description="UTC timestamp ISO-8601")
    timezone: str = Field(default="Asia/Kolkata", example="Asia/Kolkata")
    reminderType: str = Field(default="aiCall", example="aiCall")
    repeatType: str = Field(default="Never", example="Never")
    language: str = Field(default="English", example="English")
    retryEnabled: bool = Field(default=True)
    retryDelayMinutes: int = Field(default=10)

class ReminderCreate(ReminderBase):
    pass

class ReminderUpdate(BaseModel):
    title: Optional[str] = None
    notes: Optional[str] = None
    scheduledAt: Optional[datetime] = None
    reminderType: Optional[str] = None
    repeatType: Optional[str] = None
    language: Optional[str] = None
    status: Optional[str] = None
    retryEnabled: Optional[bool] = None
    retryDelayMinutes: Optional[int] = None

class ReminderResponse(ReminderBase):
    id: str
    userId: str
    status: str  # scheduled | processing | calling | completed | missed | failed | cancelled
    retryCount: int = 0
    maxRetries: int = 2
    createdAt: datetime
    updatedAt: datetime
    completedAt: Optional[datetime] = None
    lastCallAt: Optional[datetime] = None
    nextCallAt: Optional[datetime] = None

class CallWebhookPayload(BaseModel):
    CallSid: Optional[str] = None
    CallStatus: Optional[str] = None
    ReminderId: Optional[str] = None
    From: Optional[str] = None
    To: Optional[str] = None

class HealthResponse(BaseModel):
    status: str
    timestamp: datetime
    provider: str
    environment: str

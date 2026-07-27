# CallMind – System Architecture & Data Model

## 1. High-Level Technical Architecture

```
                               ┌─────────────────────────┐
                               │  Flutter Mobile Client  │
                               │  (Dart, Riverpod, M3)   │
                               └────────────┬────────────┘
                                            │
                                            ▼
                               ┌─────────────────────────┐
                               │ Firebase Authentication │
                               └────────────┬────────────┘
                                            │ Token Verification
                                            ▼
┌─────────────────────────┐    ┌─────────────────────────┐
│     Cloud Firestore     │◄───┤  FastAPI Python Backend  │
│ (Users, Reminders, Logs)│    │  (REST API + Scheduler) │
└─────────────────────────┘    └────────────┬────────────┘
                                            │
                                            ▼
                               ┌─────────────────────────┐
                               │  CallProvider Abstraction│
                               ├────────────┬────────────┤
                               │ Mock       │ Twilio     │ Exotel
                               └────────────┼────────────┘
                                            │
                                            ▼
                               ┌─────────────────────────┐
                               │ TTS / Voice Generation  │
                               └────────────┬────────────┘
                                            │
                                            ▼
                               ┌─────────────────────────┐
                               │ User's Phone (PSTN Call)│
                               └─────────────────────────┘
```

---

## 2. Firestore Data Model Specification

### 2.1 `users` Collection
Document ID: `uid` (Matches Firebase Auth UID)

```json
{
  "uid": "string (Primary Key)",
  "name": "string",
  "email": "string",
  "phone": "string (E.164 format, e.g. +14155552671)",
  "timezone": "string (e.g. America/New_York, Asia/Kolkata)",
  "preferredLanguage": "string (en, ta, te, hi)",
  "createdAt": "timestamp (UTC)",
  "updatedAt": "timestamp (UTC)"
}
```

### 2.2 `reminders` Collection
Document ID: `reminderId` (Auto-generated UUID or Firestore ID)

```json
{
  "id": "string",
  "userId": "string (Foreign Key -> users.uid)",
  "title": "string",
  "notes": "string (optional)",
  "scheduledAt": "timestamp (UTC ISO-8601)",
  "timezone": "string (User local timezone ID)",
  "reminderType": "string (ai_call | notification)",
  "repeatType": "string (never | daily | weekly | custom)",
  "language": "string (en | ta | te | hi)",
  "status": "string (scheduled | processing | calling | completed | missed | failed | cancelled)",
  "retryEnabled": "boolean",
  "retryDelayMinutes": "number (0, 5, 10, 30)",
  "retryCount": "number (current retry attempt count)",
  "maxRetries": "number (max allowed retries, e.g., 2)",
  "createdAt": "timestamp (UTC)",
  "updatedAt": "timestamp (UTC)",
  "completedAt": "timestamp (UTC | null)",
  "lastCallAt": "timestamp (UTC | null)",
  "nextCallAt": "timestamp (UTC | null)"
}
```

### 2.3 `call_logs` Collection
Document ID: `logId`

```json
{
  "id": "string",
  "reminderId": "string (Foreign Key -> reminders.id)",
  "userId": "string (Foreign Key -> users.uid)",
  "provider": "string (mock | twilio | exotel)",
  "providerCallId": "string",
  "phoneCalled": "string (E.164 masked)",
  "startedAt": "timestamp (UTC)",
  "answeredAt": "timestamp (UTC | null)",
  "endedAt": "timestamp (UTC | null)",
  "status": "string (initiated | answered | no_answer | failed)",
  "errorMessage": "string (null if success)"
}
```

---

## 3. Telephony Provider Abstraction Interface

In Python (`backend/app/providers/base.py`):

```python
from abc import ABC, abstractmethod
from typing import Dict, Any, Optional

class CallProvider(ABC):
    @abstractmethod
    async def make_call(
        self, 
        to_phone: str, 
        message: str, 
        language: str, 
        callback_url: str
    ) -> Dict[str, Any]:
        """Initiates an automated voice call."""
        pass

    @abstractmethod
    async def get_call_status(self, provider_call_id: str) -> Dict[str, Any]:
        """Queries the status of an ongoing or completed call."""
        pass

    @abstractmethod
    async def handle_webhook(self, payload: Dict[str, Any]) -> Dict[str, Any]:
        """Processes status callbacks from telephony provider."""
        pass
```

Implementations:
- `MockCallProvider`: Logs call details without sending actual PSTN traffic.
- `TwilioCallProvider`: Integrates with Twilio Voice API & TwiML.
- `ExotelCallProvider`: Integrates with Exotel Voice API.

---

## 4. Flutter Client Layer Architecture

Feature-driven clean directory structure:

```
lib/
├── main.dart
├── core/
│   ├── constants/       # App strings, keys, default settings Isolation
│   ├── theme/           # Material 3 light/dark themes & color schemes
│   ├── routing/         # GoRouter configuration
│   ├── services/        # Firebase, Notification, Local Storage services
│   └── utils/           # Date formatters, E.164 phone validation helpers
├── models/
│   ├── user_model.dart
│   ├── reminder_model.dart
│   └── call_log_model.dart
├── features/
│   ├── auth/            # Login, Registration, Phone setup
│   ├── onboarding/      # 3 slide intro walk-through
│   ├── home/            # Dashboard, Todays' reminders, FAB
│   ├── reminders/       # Create reminder, Detail view, Edit
│   ├── history/         # Past completed/missed/cancelled reminders
│   ├── profile/         # User details, Voice prefs, Timezone
│   └── settings/        # App theme, default retries, notification switches
└── shared/
    └── widgets/         # Reusable buttons, cards, text fields, loaders, empty states
```

---

## 5. Security & Multi-Tenancy Rules

1. **Firestore Rules:** Enforce `request.auth.uid == resource.data.userId`.
2. **Server Auth Verification:** FastAPI uses `firebase_admin.auth.verify_id_token(token)` header for all private API routes.
3. **Secrets Isolation:** No API keys, account SIDs, or private tokens inside client code.

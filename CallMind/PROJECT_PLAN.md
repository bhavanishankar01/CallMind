# CallMind – AI Voice Call Reminder App
## Project Plan & Strategy

> **Subtitle:** Reminders that actually call you.  
> **Target Platform:** Android-first Flutter Application with Python FastAPI Backend & Firebase Integration.

---

## 1. Executive Summary

CallMind is a modern, high-reliability voice reminder system. Unlike traditional reminder apps that rely solely on system notifications (which can easily be missed or ignored), CallMind initiates an **automated voice phone call** to the user at the exact scheduled time. When answered, an AI speech generator conveys the scheduled reminder clearly.

---

## 2. Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                 Flutter Mobile App                      │
│      (Material 3, Clean Architecture, Riverpod)         │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                 Firebase Authentication                 │
└───────────────────────────┬─────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│               FastAPI Python Backend API                │
└─────────────┬─────────────────────────────┬─────────────┘
              │                             │
              ▼                             ▼
┌───────────────────────────┐ ┌───────────────────────────┐
│     Cloud Firestore       │ │     Server Scheduler      │
│ (Users, Reminders, Logs)  │ │ (UTC Timezone / Locked)   │
└───────────────────────────┘ └─────────────┬─────────────┘
                                            │
                                            ▼
                              ┌───────────────────────────┐
                              │ CallProvider Interface    │
                              │ (Mock / Twilio / Exotel)  │
                              └─────────────┬─────────────┘
                                            │
                                            ▼
                              ┌───────────────────────────┐
                              │   TTS / Voice Engine      │
                              │ (Multilingual Voice Output)│
                              └─────────────┬─────────────┘
                                            │
                                            ▼
                              ┌───────────────────────────┐
                              │  User's Phone (PSTN Call) │
                              └───────────────────────────┘
```

---

## 3. Development Phases Roadmap

### Phase 1: Flutter UI Foundation & Navigation (Current Phase)
- Initialize clean feature-based Flutter app structure.
- Build modern Material 3 design system (light/dark mode, typography, rounded cards).
- Implement screens with mock state:
  - Splash Screen (Auth check routing)
  - Onboarding Flow (3 feature showcase slides)
  - Auth Screens (Email/Password Login & Register, Phone Entry)
  - Home Dashboard (Header, Today's Reminders, Filter Tabs, FAB)
  - Create Reminder Screen (Title, Notes, Date/Time Picker, Type, Repeat, Language, Retry)
  - Reminder Details Screen (Metadata, Status, Action buttons)
  - History Screen (Completed, Missed, Failed, Cancelled filters)
  - Profile & Settings Screen (User info, Voice Preferences, Theme switch)

### Phase 2: Firebase Integration & Client Models
- Set up Firebase Auth (Email/Password + Phone number binding).
- Design and bind Firestore schema (`users/{uid}`, `reminders/{id}`).
- Implement client data repositories, Riverpod providers, offline resilience, and Firestore security rules.

### Phase 3: Python FastAPI Backend Foundation
- Set up FastAPI backend (`backend/` directory).
- Configure environment variables and Firebase Admin SDK token verification middleware.
- Implement REST API endpoints:
  - `GET /health`
  - `POST /reminders`
  - `GET /reminders/{id}`
  - `PUT /reminders/{id}`
  - `DELETE /reminders/{id}`
  - `POST /reminders/{id}/cancel`
  - `POST /reminders/{id}/trigger`
  - `POST /webhooks/calls`

### Phase 4: Reliable Server-Side Scheduler
- Implement robust background scheduler scanning due reminders (`scheduledAt <= now` & `status == 'scheduled'`).
- Enforce atomic locking mechanisms to prevent duplicate call triggers across instances.
- Ensure strict UTC timestamp processing and client local timezone conversions.

### Phase 5: Telephony Provider Abstraction & Mock Provider
- Define `CallProvider` abstract interface (`make_call`, `get_call_status`, `handle_webhook`).
- Implement `MockCallProvider` for development testing without incurring telephony costs.
- Implement `TwilioCallProvider` and `ExotelCallProvider` drivers.

### Phase 6: End-to-End Voice Call Pipeline
- Implement TTS (`VoiceService`) generating audio reminders:  
  *"Hello [Name]. This is your CallMind reminder. You asked me to remind you to [Title]."*
- Wire scheduler -> calling service -> TTS -> provider dispatch -> Firestore status updates.

### Phase 7: Call Retries & Audit Logging
- Implement retry logic for missed/unanswered calls based on user preferences.
- Save detailed call execution logs in `call_logs` collection.

### Phase 8: Notification Fallback Backup
- Integrate local/push notifications as a secondary backup if phone call delivery fails or is unanswered.

### Phase 9: Multilingual Voice Support
- Support voice generation across English, Tamil, Telugu, and Hindi languages.

### Phase 10: Interactive AI Voice Calls (Future Phase)
- Architect OpenAI & STT integration allowing users to speak during calls (e.g., *"Snooze for 30 minutes"*).

---

## 4. Key Engineering Constraints & Best Practices

1. **No Secret Leaks:** All API keys (Twilio, Exotel, OpenAI, Firebase Admin credentials) strictly reside in server `.env`.
2. **UTC Timestamp Integrity:** All dates stored as UTC; user local time zone applied strictly for presentation.
3. **At-Least-Once / Idempotent Execution:** Scheduler uses atomic Firestore transactions to claim due reminders before initiating calls.
4. **Mockable Design:** App supports `CALL_PROVIDER=mock` for testing without paid telephony APIs.

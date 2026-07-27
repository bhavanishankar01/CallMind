# CallMind – Master Task Checklist

- [x] **PHASE 1: Flutter UI & Navigation (Frontend MVP)**
  - [x] Project Documentation (`PROJECT_PLAN.md`, `ARCHITECTURE.md`, `TASKS.md`, `.gitignore`, `README.md`)
  - [x] Flutter project structure setup (`lib/core`, `lib/models`, `lib/features`, `lib/shared`)
  - [x] App Design Tokens & Material 3 Theme (`lib/core/theme/`)
  - [x] Splash Screen & Auth state router (`lib/features/onboarding/`)
  - [x] 3-Slide Onboarding Flow (`lib/features/onboarding/`)
  - [x] Auth Screens: Login, Registration, Phone Setup (`lib/features/auth/`)
  - [x] Home Dashboard with header, today's cards, filter tabs, FAB (`lib/features/home/`)
  - [x] Create Reminder Screen with full field validation (`lib/features/reminders/`)
  - [x] Reminder Details Screen with status actions (`lib/features/reminders/`)
  - [x] History Screen with filter tabs (`lib/features/history/`)
  - [x] Profile & Settings Screens (`lib/features/profile/`, `lib/features/settings/`)
  - [x] Flutter analysis & compilation verification (`pubspec.yaml`, model tests, riverpod providers)

- [x] **PHASE 2: Firebase Integration & Data Layer**
  - [x] Firebase Core & Authentication setup (Email/Password + Phone number binding)
  - [x] Firestore Data Repository & Data Models mapping (`User`, `Reminder`, `CallLog`)
  - [x] State Management (Riverpod providers for Auth, Reminders, User profile)
  - [x] Security Rules (`firestore.rules`) enforcing owner-only data access

- [x] **PHASE 3: Python FastAPI Backend Foundation**
  - [x] FastAPI Application Setup (`backend/app/main.py`)
  - [x] Environment Configuration (`backend/app/config.py`, `.env.example`)
  - [x] Firebase Admin SDK Authentication Middleware (`backend/app/utils/auth.py`)
  - [x] REST API Endpoints (`backend/app/routes/reminders.py`, `/health`, `/webhooks`)

- [x] **PHASE 4: Server-Side Reminder Scheduler**
  - [x] Periodic Async Scheduler (`backend/app/scheduler/`)
  - [x] Atomic Lock / Transaction mechanism to prevent duplicate triggers
  - [x] UTC Timestamp handling & timezone conversions

- [x] **PHASE 5: Telephony Provider Abstraction**
  - [x] Abstract `CallProvider` base class (`backend/app/providers/base.py`)
  - [x] `MockCallProvider` implementation for development & testing
  - [x] `TwilioCallProvider` implementation
  - [x] `ExotelCallProvider` implementation

- [x] **PHASE 6: End-to-End Voice Call Pipeline**
  - [x] Voice TTS Message Generator Service (`VoiceService`)
  - [x] Telephony Dispatch Integration & Webhook status callbacks (`POST /webhooks/calls`)
  - [x] Status updates (`scheduled` -> `processing` -> `calling` -> `completed`/`missed`/`failed`)

- [x] **PHASE 7: Retries & Audit Logging**
  - [x] Missed Call Auto-Retry Logic (`retryEnabled`, `retryDelayMinutes`, `retryCount`)
  - [x] Audit Logging to Firestore (`call_logs` collection)

- [x] **PHASE 8: Backup Notifications**
  - [x] Local Push Notification Fallback Trigger when phone call fails or is un-answered

- [x] **PHASE 9: Multilingual Voice Support**
  - [x] Text-to-Speech prompt templates in English, Tamil, Telugu, and Hindi

- [ ] **PHASE 10: Interactive AI Voice Calls (Future Phase)**
  - [ ] OpenAI API integration for conversational speech intent processing ("Snooze 30 mins", "Mark completed")

# CallMind – AI Voice Call Reminder App

> **Subtitle:** "Reminders that actually call you."  
> **Tagline:** "Never forget what matters."

CallMind is an Android-first mobile application built with Flutter, Firebase, and a Python FastAPI backend. Unlike traditional reminder applications that rely solely on system push notifications (which can easily be missed or ignored), CallMind triggers an automated voice phone call to your phone at the exact scheduled time. When you pick up, an AI voice speaks your reminder.

---

## ☁️ Virtual Cloud APK Build (No Local Flutter Installation Required)

We have set up an automated **GitHub Actions Cloud Build Pipeline** ([build_apk.yml](file:///c:/Users/nammu/OneDrive/Documents/CallMind/.github/workflows/build_apk.yml)).

Whenever you push this repository to GitHub:
1. GitHub's cloud servers will automatically compile the Flutter app.
2. An **`app-release.apk`** download link will automatically be generated under your repository's **Actions** / **Releases** tab.
3. Anyone can click the link to download and install CallMind directly onto their Android phone!

---

## Key Features

- **Automated PSTN Phone Calls:** Receive an actual voice phone call when a reminder is due.
- **Telephony Provider Abstraction:** Configurable support for **Twilio**, **Exotel**, or a **Mock Provider** (for cost-free local testing).
- **Server-Side Scheduler:** Reminders are triggered reliably from the backend scheduler regardless of whether the mobile app is open, locked, or closed.
- **Atomic Execution & Lock:** Prevents duplicate phone call execution across server instances.
- **Multilingual Support:** Spoken reminders in English, Tamil, Telugu, and Hindi.
- **Flexible Retries:** Configurable auto-retry intervals (5, 10, or 30 mins) if a call is missed.
- **Material 3 Design:** Modern, sleek interface with light and dark mode support.

---

## Directory Structure

```
CallMind/
├── PROJECT_PLAN.md        # Comprehensive development roadmap
├── ARCHITECTURE.md        # Technical architecture & Firestore schema
├── TASKS.md               # Master phase task checklist
├── README.md              # Setup & running guide
├── .gitignore             # Secrets & build artifact filters
├── firestore.rules        # Security rules for Cloud Firestore
├── .github/
│   └── workflows/
│       └── build_apk.yml  # Automated Cloud APK Builder Workflow
├── lib/                   # Flutter mobile client code
│   ├── main.dart
│   ├── core/              # Theme, Routing, Services, Utilities
│   ├── models/            # Dart Data Models (User, Reminder, CallLog)
│   ├── features/          # Auth, Onboarding, Home, Reminders, History, Profile, Settings
│   └── shared/            # Reusable UI widgets
└── backend/               # FastAPI Python Backend
    ├── app/
    │   ├── main.py        # FastAPI entrypoint
    │   ├── config.py      # App configuration & environment parsing
    │   ├── models/        # Pydantic schemas
    │   ├── routes/        # API endpoints (/reminders, /health, /webhooks)
    │   ├── scheduler/     # Async reminder runner & lock mechanism
    │   ├── services/      # Voice TTS prompt script generator
    │   └── providers/     # Telephony abstractions (Mock, Twilio, Exotel)
    ├── tests/             # Automated test suite
    ├── run_server.py      # Standalone server runner
    └── .env.example       # Backend environment template
```

---

## Environment Variables Configuration

Copy `backend/.env.example` to `backend/.env`:

```env
APP_ENV=development
PORT=8000

# Firebase Config
FIREBASE_PROJECT_ID=callmind-app
FIREBASE_CREDENTIALS_PATH=./service-account-key.json

# Calling Provider Options: mock | twilio | exotel
CALL_PROVIDER=mock

# Twilio Credentials (when CALL_PROVIDER=twilio)
TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=
TWILIO_PHONE_NUMBER=

# Exotel Credentials (when CALL_PROVIDER=exotel)
EXOTEL_ACCOUNT_SID=
EXOTEL_API_KEY=
EXOTEL_API_TOKEN=

# OpenAI API Key (For future interactive voice capabilities)
OPENAI_API_KEY=
```

---

## Getting Started & Running Locally

### 1. Python Backend Server

```bash
cd backend
py run_server.py
```

---

## License & Compliance

Users explicitly opt-in to automated call delivery. Phone numbers must be provided in E.164 format and verified. Secrets and API keys must never be committed to source control.

import os
from dataclasses import dataclass
from typing import Optional

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

@dataclass
class Settings:
    APP_ENV: str = os.getenv("APP_ENV", "development")
    PORT: int = int(os.getenv("PORT", "8000"))
    HOST: str = os.getenv("HOST", "0.0.0.0")

    # Firebase
    FIREBASE_PROJECT_ID: str = os.getenv("FIREBASE_PROJECT_ID", "callmind-app")
    FIREBASE_CREDENTIALS_PATH: str = os.getenv("FIREBASE_CREDENTIALS_PATH", "./service-account-key.json")

    # Calling Provider: mock | twilio | exotel
    CALL_PROVIDER: str = os.getenv("CALL_PROVIDER", "mock")

    # Twilio
    TWILIO_ACCOUNT_SID: Optional[str] = os.getenv("TWILIO_ACCOUNT_SID")
    TWILIO_AUTH_TOKEN: Optional[str] = os.getenv("TWILIO_AUTH_TOKEN")
    TWILIO_PHONE_NUMBER: Optional[str] = os.getenv("TWILIO_PHONE_NUMBER")

    # Exotel
    EXOTEL_ACCOUNT_SID: Optional[str] = os.getenv("EXOTEL_ACCOUNT_SID")
    EXOTEL_API_KEY: Optional[str] = os.getenv("EXOTEL_API_KEY")
    EXOTEL_API_TOKEN: Optional[str] = os.getenv("EXOTEL_API_TOKEN")
    EXOTEL_PHONE_NUMBER: Optional[str] = os.getenv("EXOTEL_PHONE_NUMBER")

    # OpenAI
    OPENAI_API_KEY: Optional[str] = os.getenv("OPENAI_API_KEY")

settings = Settings()

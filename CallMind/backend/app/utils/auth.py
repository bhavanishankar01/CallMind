import logging
from fastapi import Header, HTTPException, status
from typing import Dict, Any, Optional

logger = logging.getLogger("callmind.auth")

try:
    import firebase_admin
    from firebase_admin import auth, credentials
    _firebase_available = True
except ImportError:
    _firebase_available = False

def init_firebase_admin(credentials_path: str, project_id: str):
    if not _firebase_available:
        logger.warning("firebase_admin package not installed. Auth token verification running in Mock mode.")
        return

    try:
        if not firebase_admin._apps:
            if credentials_path and os.path.exists(credentials_path):
                cred = credentials.Certificate(credentials_path)
                firebase_admin.initialize_app(cred, {'projectId': project_id})
            else:
                firebase_admin.initialize_app(options={'projectId': project_id})
            logger.info("Firebase Admin initialized successfully.")
    except Exception as e:
        logger.warning(f"Firebase Admin initialization note: {e}")

async def verify_firebase_token(authorization: Optional[str] = Header(None)) -> Dict[str, Any]:
    """Verifies Firebase ID token from Authorization header."""
    if not authorization or not authorization.startswith("Bearer "):
        # Dev fallback for testing without live Firebase token
        logger.info("No Bearer token supplied. Defaulting to mock user context.")
        return {"uid": "mock_user_123", "email": "alex.morgan@example.com"}

    token = authorization.split("Bearer ")[1]
    
    if not _firebase_available:
        return {"uid": "mock_user_123", "email": "alex.morgan@example.com"}

    try:
        decoded_token = auth.verify_id_token(token)
        return decoded_token
    except Exception as e:
        logger.error(f"Firebase Token Verification Error: {e}")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired authentication token",
        )

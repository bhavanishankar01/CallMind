import logging
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .config import settings
from .routes import health, reminders, webhooks
from .scheduler.reminder_scheduler import scheduler_instance

# Configure Logging Format
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("callmind.main")

@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info(f"Starting CallMind FastAPI Server (ENV={settings.APP_ENV}, PROVIDER={settings.CALL_PROVIDER})")
    scheduler_instance.start()
    yield
    logger.info("Shutting down CallMind FastAPI Server")
    scheduler_instance.stop()

app = FastAPI(
    title="CallMind API",
    description="AI Voice Call Reminder App Backend Server",
    version="1.0.0",
    lifespan=lifespan,
)

# CORS Middleware Setup
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include API Routers
app.include_router(health.router)
app.include_router(reminders.router)
app.include_router(webhooks.router)

@app.get("/")
async def root():
    return {
        "app": "CallMind",
        "subtitle": "Reminders that actually call you.",
        "status": "online",
        "docs": "/docs",
    }

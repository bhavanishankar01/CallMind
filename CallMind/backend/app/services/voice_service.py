import logging

logger = logging.getLogger("callmind.services.voice")

class VoiceService:
    TEMPLATES = {
        "English": "Hello {name}. This is your CallMind reminder. You asked me to remind you to {title}.",
        "Tamil": "வணக்கம் {name}. இது உங்கள் CallMind நினைவூட்டல். {title} செய்யுமாறு நினைவுபடுத்த கூறினீர்கள்.",
        "Telugu": "నమస్తే {name}. ఇది మీ CallMind గుర్తుచేసే కాల్. మీరు {title} ని గుర్తుచేయమన్నారు.",
        "Hindi": "नमस्ते {name}। यह आपकी CallMind रिमाइंडर कॉल है। आपने मुझे {title} याद दिलाने के लिए कहा था।",
    }

    @classmethod
    def generate_reminder_script(
        cls, 
        user_name: str, 
        reminder_title: str, 
        language: str = "English"
    ) -> str:
        """Generates multilingual spoken text for reminder voice calls."""
        template = cls.TEMPLATES.get(language, cls.TEMPLATES["English"])
        clean_name = user_name.strip() if user_name else "there"
        clean_title = reminder_title.strip()

        message = template.format(name=clean_name, title=clean_title)
        logger.info(f"Generated Voice Script [{language}]: {message}")
        return message

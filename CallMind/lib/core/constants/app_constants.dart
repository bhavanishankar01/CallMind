class AppConstants {
  static const String appName = 'CallMind';
  static const String appSubtitle = 'Reminders that actually call you.';
  static const String splashTagline = 'Never forget what matters.';

  // Storage / State Keys
  static const String defaultTimezone = 'Asia/Kolkata'; // Default fallback
  static const String defaultLanguage = 'English';

  // Supported Languages
  static const List<String> supportedLanguages = [
    'English',
    'Tamil',
    'Telugu',
    'Hindi',
  ];

  // Repeat Options
  static const List<String> repeatOptions = [
    'Never',
    'Daily',
    'Weekly',
    'Custom',
  ];

  // Retry Delay Options (Minutes)
  static const List<int> retryOptionsMinutes = [
    0, // Don't retry
    5,
    10,
    30,
  ];

  static String getRetryLabel(int minutes) {
    if (minutes <= 0) return "Don't retry";
    return 'Retry after $minutes minutes';
  }
}

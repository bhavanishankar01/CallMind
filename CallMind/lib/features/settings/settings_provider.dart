import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final bool callRemindersEnabled;
  final String preferredLanguage;
  final int defaultRetryMinutes;

  SettingsState({
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = true,
    this.callRemindersEnabled = true,
    this.preferredLanguage = 'English',
    this.defaultRetryMinutes = 10,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? callRemindersEnabled,
    String? preferredLanguage,
    int? defaultRetryMinutes,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      callRemindersEnabled: callRemindersEnabled ?? this.callRemindersEnabled,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      defaultRetryMinutes: defaultRetryMinutes ?? this.defaultRetryMinutes,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState());

  void toggleTheme(bool isDark) {
    state = state.copyWith(themeMode: isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleNotifications(bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }

  void toggleCallReminders(bool value) {
    state = state.copyWith(callRemindersEnabled: value);
  }

  void setLanguage(String lang) {
    state = state.copyWith(preferredLanguage: lang);
  }

  void setDefaultRetry(int minutes) {
    state = state.copyWith(defaultRetryMinutes: minutes);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

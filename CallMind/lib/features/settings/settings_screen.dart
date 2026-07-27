import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildSectionHeader(context, 'Appearance'),
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.dark_mode_outlined),
                title: const Text('Dark Theme'),
                subtitle: const Text('Enable dark mode for comfortable night viewing'),
                value: settings.themeMode == ThemeMode.dark,
                onChanged: (val) {
                  ref.read(settingsProvider.notifier).toggleTheme(val);
                },
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(context, 'Reminder Delivery Settings'),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.phone_in_talk_outlined),
                    title: const Text('Automated Call Reminders'),
                    subtitle: const Text('Allow CallMind to call your registered phone'),
                    value: settings.callRemindersEnabled,
                    onChanged: (val) {
                      ref.read(settingsProvider.notifier).toggleCallReminders(val);
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_active_outlined),
                    title: const Text('Backup Push Notifications'),
                    subtitle: const Text('Receive push alerts if a call is missed'),
                    value: settings.notificationsEnabled,
                    onChanged: (val) {
                      ref.read(settingsProvider.notifier).toggleNotifications(val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(context, 'Voice & Localization'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Default Voice Language',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: settings.preferredLanguage,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.translate),
                      ),
                      items: AppConstants.supportedLanguages.map((lang) {
                        return DropdownMenuItem(value: lang, child: Text(lang));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(settingsProvider.notifier).setLanguage(val);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Default Retry Setting',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: settings.defaultRetryMinutes,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.replay),
                      ),
                      items: AppConstants.retryOptionsMinutes.map((mins) {
                        return DropdownMenuItem(
                          value: mins,
                          child: Text(AppConstants.getRetryLabel(mins)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(settingsProvider.notifier).setDefaultRetry(val);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: AppTheme.primaryViolet,
        ),
      ),
    );
  }
}

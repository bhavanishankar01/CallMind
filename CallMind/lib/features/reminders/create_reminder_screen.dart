import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/reminder_model.dart';
import '../../shared/widgets/custom_button.dart';
import '../auth/auth_provider.dart';
import 'reminder_provider.dart';

class CreateReminderScreen extends ConsumerStatefulWidget {
  const CreateReminderScreen({super.key});

  @override
  ConsumerState<CreateReminderScreen> createState() => _CreateReminderScreenState();
}

class _CreateReminderScreenState extends ConsumerState<CreateReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _selectedTime = TimeOfDay.fromDateTime(
    DateTime.now().add(const Duration(hours: 1)),
  );

  ReminderType _reminderType = ReminderType.aiCall;
  String _repeatType = 'Never';
  String _voiceLanguage = AppConstants.defaultLanguage;
  int _retryDelayMinutes = 10;
  bool _isLoading = false;

  DateTime get _combinedScheduledAt {
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    final scheduledDateTime = _combinedScheduledAt;
    if (scheduledDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot schedule a reminder in the past.'),
          backgroundColor: AppTheme.statusMissed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final user = ref.read(authProvider);

    final newReminder = ReminderModel(
      id: 'rem_${const Uuid().v4().substring(0, 8)}',
      userId: user?.uid ?? 'mock_user_123',
      title: _titleController.text.trim(),
      notes: _notesController.text.trim(),
      scheduledAt: scheduledDateTime,
      timezone: user?.timezone ?? AppConstants.defaultTimezone,
      reminderType: _reminderType,
      repeatType: _repeatType,
      language: _voiceLanguage,
      status: ReminderStatus.scheduled,
      retryEnabled: _retryDelayMinutes > 0,
      retryDelayMinutes: _retryDelayMinutes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    ref.read(reminderProvider.notifier).addReminder(newReminder);
    setState(() => _isLoading = false);

    if (!mounted) return;

    // Show Confirmation Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(
          Icons.check_circle_outline_rounded,
          size: 64,
          color: AppTheme.statusCompleted,
        ),
        title: Text(
          'Reminder Scheduled!',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'CallMind will call you on ${DateFormatter.formatDate(scheduledDateTime)} at ${DateFormatter.formatTime(scheduledDateTime)}.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Done',
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/home');
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Reminder'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Field
                Text(
                  'Reminder Title',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Please enter title' : null,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Submit project report',
                    prefixIcon: Icon(Icons.edit_note),
                  ),
                ),
                const SizedBox(height: 20),

                // Optional Notes
                Text(
                  'Optional Notes',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Submit the final PDF to the guide.',
                  ),
                ),
                const SizedBox(height: 20),

                // Date & Time Pickers
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _pickDate,
                            borderRadius: BorderRadius.circular(14),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                DateFormatter.formatDate(_selectedDate),
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _pickTime,
                            borderRadius: BorderRadius.circular(14),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.access_time),
                              ),
                              child: Text(
                                _selectedTime.format(context),
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Reminder Type Toggle
                Text(
                  'Reminder Method',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        avatar: const Icon(Icons.phone_in_talk, size: 16),
                        label: const Text('AI Phone Call'),
                        selected: _reminderType == ReminderType.aiCall,
                        selectedColor: AppTheme.primaryViolet,
                        labelStyle: TextStyle(
                          color: _reminderType == ReminderType.aiCall
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _reminderType = ReminderType.aiCall);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        avatar: const Icon(Icons.notifications_active, size: 16),
                        label: const Text('App Notification'),
                        selected: _reminderType == ReminderType.notification,
                        selectedColor: AppTheme.primaryViolet,
                        labelStyle: TextStyle(
                          color: _reminderType == ReminderType.notification
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _reminderType = ReminderType.notification);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Repeat Selection
                Text(
                  'Repeat',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _repeatType,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.repeat),
                  ),
                  items: AppConstants.repeatOptions.map((opt) {
                    return DropdownMenuItem(value: opt, child: Text(opt));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _repeatType = val);
                  },
                ),
                const SizedBox(height: 20),

                // Voice Language Selection
                Text(
                  'Voice Language',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _voiceLanguage,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.record_voice_over),
                  ),
                  items: AppConstants.supportedLanguages.map((lang) {
                    return DropdownMenuItem(value: lang, child: Text(lang));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _voiceLanguage = val);
                  },
                ),
                const SizedBox(height: 20),

                // Call Retry Settings
                Text(
                  'Call Retry Settings',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: _retryDelayMinutes,
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
                    if (val != null) setState(() => _retryDelayMinutes = val);
                  },
                ),
                const SizedBox(height: 36),

                // Set Reminder Submit Button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Set Reminder',
                    isLoading: _isLoading,
                    onPressed: _handleCreate,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

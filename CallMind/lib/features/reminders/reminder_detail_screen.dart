import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/reminder_model.dart';
import '../../shared/widgets/custom_button.dart';
import 'reminder_provider.dart';

class ReminderDetailScreen extends ConsumerWidget {
  final String reminderId;

  const ReminderDetailScreen({
    super.key,
    required this.reminderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reminders = ref.watch(reminderProvider);

    final reminder = reminders.firstWhere(
      (r) => r.id == reminderId,
      orElse: () => ReminderModel(
        id: '',
        userId: '',
        title: 'Not Found',
        scheduledAt: DateTime.now(),
        timezone: 'UTC',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    if (reminder.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reminder Details')),
        body: const Center(child: Text('Reminder not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card with Status Badge
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryViolet.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryViolet.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormatter.formatTime(reminder.scheduledAt),
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryViolet,
                          ),
                        ),
                        _buildStatusBadge(reminder.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormatter.formatDate(reminder.scheduledAt),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Title & Notes
              Text(
                reminder.title,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (reminder.notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  reminder.notes,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
              const SizedBox(height: 28),

              const Divider(),
              const SizedBox(height: 20),

              // Metadata Tiles
              _buildDetailTile(
                context,
                icon: Icons.phone_in_talk,
                label: 'Reminder Method',
                value: reminder.reminderType == ReminderType.aiCall
                    ? 'AI Voice Phone Call'
                    : 'App Push Notification',
              ),
              _buildDetailTile(
                context,
                icon: Icons.translate,
                label: 'Voice Language',
                value: reminder.language,
              ),
              _buildDetailTile(
                context,
                icon: Icons.repeat,
                label: 'Repeat Pattern',
                value: reminder.repeatType,
              ),
              _buildDetailTile(
                context,
                icon: Icons.replay,
                label: 'Call Retry Setting',
                value: reminder.retryEnabled
                    ? 'Retry after ${reminder.retryDelayMinutes} mins'
                    : 'Disabled',
              ),
              _buildDetailTile(
                context,
                icon: Icons.schedule,
                label: 'Created Date',
                value: DateFormatter.formatDateTime(reminder.createdAt),
              ),
              if (reminder.lastCallAt != null)
                _buildDetailTile(
                  context,
                  icon: Icons.call_made,
                  label: 'Last Call Attempt',
                  value: DateFormatter.formatDateTime(reminder.lastCallAt!),
                ),

              const SizedBox(height: 32),

              // Action Buttons
              if (reminder.status == ReminderStatus.scheduled) ...[
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Mark Completed',
                    icon: Icons.check_circle_outline,
                    onPressed: () {
                      ref
                          .read(reminderProvider.notifier)
                          .updateStatus(reminder.id, ReminderStatus.completed);
                      context.pop();
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Cancel Reminder',
                    isOutlined: true,
                    icon: Icons.cancel_outlined,
                    onPressed: () {
                      ref
                          .read(reminderProvider.notifier)
                          .updateStatus(reminder.id, ReminderStatus.cancelled);
                      context.pop();
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],

              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  icon: const Icon(Icons.delete_outline, color: AppTheme.statusMissed),
                  label: Text(
                    'Delete Reminder',
                    style: GoogleFonts.inter(
                      color: AppTheme.statusMissed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    ref.read(reminderProvider.notifier).deleteReminder(reminder.id);
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ReminderStatus status) {
    Color color = AppTheme.statusScheduled;
    String label = 'Scheduled';

    if (status == ReminderStatus.completed) {
      color = AppTheme.statusCompleted;
      label = 'Completed';
    } else if (status == ReminderStatus.calling) {
      color = AppTheme.statusCalling;
      label = 'Calling';
    } else if (status == ReminderStatus.missed) {
      color = AppTheme.statusMissed;
      label = 'Missed';
    } else if (status == ReminderStatus.cancelled) {
      color = AppTheme.statusCancelled;
      label = 'Cancelled';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDetailTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppTheme.primaryViolet),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

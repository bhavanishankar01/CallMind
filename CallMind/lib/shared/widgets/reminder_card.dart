import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/reminder_model.dart';

class ReminderCard extends StatelessWidget {
  final ReminderModel reminder;
  final VoidCallback onTap;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onTap,
  });

  Color _getStatusColor(ReminderStatus status) {
    switch (status) {
      case ReminderStatus.scheduled:
        return AppTheme.statusScheduled;
      case ReminderStatus.processing:
      case ReminderStatus.calling:
        return AppTheme.statusCalling;
      case ReminderStatus.completed:
        return AppTheme.statusCompleted;
      case ReminderStatus.missed:
        return AppTheme.statusMissed;
      case ReminderStatus.failed:
        return AppTheme.statusFailed;
      case ReminderStatus.cancelled:
        return AppTheme.statusCancelled;
    }
  }

  String _getStatusLabel(ReminderStatus status) {
    switch (status) {
      case ReminderStatus.scheduled:
        return 'Scheduled';
      case ReminderStatus.processing:
        return 'Processing';
      case ReminderStatus.calling:
        return 'Calling Now';
      case ReminderStatus.completed:
        return 'Completed';
      case ReminderStatus.missed:
        return 'Missed';
      case ReminderStatus.failed:
        return 'Failed';
      case ReminderStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(reminder.status);
    final statusLabel = _getStatusLabel(reminder.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Time & Method Icon + Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryViolet.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          reminder.reminderType == ReminderType.aiCall
                              ? Icons.phone_in_talk
                              : Icons.notifications_active,
                          size: 18,
                          color: AppTheme.primaryViolet,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormatter.formatTime(reminder.scheduledAt),
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            DateFormatter.getRelativeDay(reminder.scheduledAt),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Status Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusLabel,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Title & Notes
              Text(
                reminder.title,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (reminder.notes.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  reminder.notes,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 12),
              // Tags Row: AI Call Badge, Language, Repeat
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _buildTag(
                    context,
                    reminder.reminderType == ReminderType.aiCall
                        ? 'AI Voice Call'
                        : 'Notification',
                    Icons.graphic_eq,
                  ),
                  _buildTag(
                    context,
                    reminder.language,
                    Icons.translate,
                  ),
                  if (reminder.repeatType != 'Never')
                    _buildTag(
                      context,
                      'Repeat: ${reminder.repeatType}',
                      Icons.repeat,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text, IconData icon) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: theme.textTheme.bodyMedium?.color),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../models/reminder_model.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/reminder_card.dart';
import '../reminders/reminder_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reminders = ref.watch(reminderProvider);

    final historyReminders = reminders.where((r) {
      return r.status == ReminderStatus.completed ||
          r.status == ReminderStatus.missed ||
          r.status == ReminderStatus.failed ||
          r.status == ReminderStatus.cancelled;
    }).toList();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Reminder History',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: AppTheme.primaryViolet,
            labelColor: AppTheme.primaryViolet,
            unselectedLabelColor: theme.textTheme.bodyMedium?.color,
            tabs: const [
              Tab(text: 'Completed'),
              Tab(text: 'Missed'),
              Tab(text: 'Failed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHistoryList(
              context,
              historyReminders
                  .where((r) => r.status == ReminderStatus.completed)
                  .toList(),
              'Completed',
            ),
            _buildHistoryList(
              context,
              historyReminders
                  .where((r) => r.status == ReminderStatus.missed)
                  .toList(),
              'Missed',
            ),
            _buildHistoryList(
              context,
              historyReminders
                  .where((r) => r.status == ReminderStatus.failed)
                  .toList(),
              'Failed',
            ),
            _buildHistoryList(
              context,
              historyReminders
                  .where((r) => r.status == ReminderStatus.cancelled)
                  .toList(),
              'Cancelled',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    List<ReminderModel> list,
    String category,
  ) {
    if (list.isEmpty) {
      return EmptyStateWidget(
        title: 'No $category Reminders',
        message: 'Past reminders categorized as $category will appear here.',
        icon: Icons.history_toggle_off,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final reminder = list[index];
        return ReminderCard(
          reminder: reminder,
          onTap: () => context.push('/reminder-detail/${reminder.id}'),
        );
      },
    );
  }
}

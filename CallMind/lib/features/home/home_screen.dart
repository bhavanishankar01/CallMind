import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../models/reminder_model.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/reminder_card.dart';
import '../auth/auth_provider.dart';
import '../reminders/reminder_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authProvider);
    final reminders = ref.watch(reminderProvider);
    final selectedFilter = ref.watch(selectedFilterProvider);

    final filteredReminders = reminders.where((r) {
      if (selectedFilter == 'Scheduled') return r.status == ReminderStatus.scheduled;
      if (selectedFilter == 'Calling') return r.status == ReminderStatus.calling || r.status == ReminderStatus.processing;
      if (selectedFilter == 'Completed') return r.status == ReminderStatus.completed;
      if (selectedFilter == 'Missed') return r.status == ReminderStatus.missed;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_getGreeting()}, ${user?.name ?? "User"} 👋',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              'CallMind Voice Reminders',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: ['All', 'Scheduled', 'Calling', 'Completed', 'Missed']
                    .map((filter) {
                  final isSelected = selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      selectedColor: AppTheme.primaryViolet,
                      labelStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          ref.read(selectedFilterProvider.notifier).state = filter;
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            // Reminders List / Empty State
            Expanded(
              child: filteredReminders.isEmpty
                  ? EmptyStateWidget(
                      title: "You're all caught up!",
                      message:
                          "No $selectedFilter reminders found. Schedule an AI voice reminder to get called on time.",
                      buttonText: "Create Reminder",
                      onButtonPressed: () => context.push('/create-reminder'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filteredReminders.length,
                      itemBuilder: (context, index) {
                        final reminder = filteredReminders[index];
                        return ReminderCard(
                          reminder: reminder,
                          onTap: () => context.push('/reminder-detail/${reminder.id}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

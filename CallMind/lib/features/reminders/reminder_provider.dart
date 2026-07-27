import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/reminder_model.dart';
import '../../services/mock_data_service.dart';

class ReminderNotifier extends StateNotifier<List<ReminderModel>> {
  ReminderNotifier() : super(MockDataService.sampleReminders);

  void addReminder(ReminderModel reminder) {
    state = [reminder, ...state];
  }

  void updateReminder(ReminderModel updated) {
    state = [
      for (final r in state)
        if (r.id == updated.id) updated else r
    ];
  }

  void deleteReminder(String id) {
    state = state.where((r) => r.id != id).toList();
  }

  void updateStatus(String id, ReminderStatus newStatus) {
    state = [
      for (final r in state)
        if (r.id == id)
          r.copyWith(
            status: newStatus,
            completedAt: newStatus == ReminderStatus.completed
                ? DateTime.now()
                : r.completedAt,
            updatedAt: DateTime.now(),
          )
        else
          r
    ];
  }
}

final reminderProvider =
    StateNotifierProvider<ReminderNotifier, List<ReminderModel>>((ref) {
  return ReminderNotifier();
});

final selectedFilterProvider = StateProvider<String>((ref) => 'All');

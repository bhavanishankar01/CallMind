import 'package:flutter/foundation.dart';
import '../../models/user_model.dart';
import '../../models/reminder_model.dart';
import '../../services/mock_data_service.dart';

class FirebaseService {
  static final FirebaseService instance = FirebaseService._internal();
  FirebaseService._internal();

  bool _isFirebaseInitialized = false;

  bool get isInitialized => _isFirebaseInitialized;

  void initializeMockMode() {
    _isFirebaseInitialized = false;
    debugPrint('FirebaseService running in Mock/Resilient Mode.');
  }

  // Auth Operations
  Future<UserModel?> getCurrentUser() async {
    return MockDataService.currentUser;
  }

  Future<UserModel> signInWithEmail(String email, String password) async {
    return MockDataService.currentUser.copyWith(email: email);
  }

  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String phone,
    required String language,
  }) async {
    final newUser = UserModel(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      timezone: 'Asia/Kolkata',
      preferredLanguage: language,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    MockDataService.currentUser = newUser;
    return newUser;
  }

  // Firestore Reminder Operations
  Future<List<ReminderModel>> fetchUserReminders(String userId) async {
    return MockDataService.sampleReminders;
  }

  Future<void> saveReminder(ReminderModel reminder) async {
    MockDataService.sampleReminders.removeWhere((r) => r.id == reminder.id);
    MockDataService.sampleReminders.insert(0, reminder);
  }

  Future<void> updateReminderStatus(String reminderId, ReminderStatus status) async {
    final index = MockDataService.sampleReminders.indexWhere((r) => r.id == reminderId);
    if (index != -1) {
      MockDataService.sampleReminders[index] = MockDataService.sampleReminders[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    MockDataService.sampleReminders.removeWhere((r) => r.id == reminderId);
  }
}

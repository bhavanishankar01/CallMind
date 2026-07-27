import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../services/mock_data_service.dart';

class AuthNotifier extends StateNotifier<UserModel?> {
  AuthNotifier() : super(MockDataService.currentUser);

  void login(String email, String password) {
    // Mock login logic for Phase 1
    state = MockDataService.currentUser.copyWith(email: email);
  }

  void register({
    required String name,
    required String email,
    required String phone,
    required String language,
  }) {
    state = UserModel(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      timezone: 'Asia/Kolkata',
      preferredLanguage: language,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  void updateProfile(UserModel updated) {
    state = updated;
  }

  void logout() {
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(authProvider);
  return user != null;
});

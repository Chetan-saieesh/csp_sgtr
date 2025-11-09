import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'supabase_service.dart';

class AuthService {
  static UserModel? _currentUser;

  static UserModel? get currentUser => _currentUser;

  static bool get isAuthenticated => _currentUser != null;

  static bool get isTeacher => _currentUser?.role == 'teacher';
  static bool get isAuthority => _currentUser?.role == 'authority';

  static Future<bool> login(String username, String password) async {
    try {
      final user = await SupabaseService.authenticateUser(username, password);
      if (user != null) {
        _currentUser = user;
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error during login: $e');
      return false;
    }
  }

  static void logout() {
    _currentUser = null;
  }
}


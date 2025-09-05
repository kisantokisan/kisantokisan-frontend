import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Outcome of an auth action.
enum AuthResult { success, wrongPassword, userNotFound, alreadyExists, failure }

/// Local-only authentication repository using shared_preferences.
/// Stores one JSON per user keyed by 'user_v1_<id>'.
class AuthRepository {
  static const String _prefix = 'user_v1_';

  String _keyFor(String id) => '$_prefix$id';

  /// Returns true if a user with this id exists.
  Future<bool> userExists(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyFor(id));
  }

  /// Attempts to sign in with id + password.
  /// - success: credentials match a stored user
  /// - userNotFound: no user for that id
  /// - wrongPassword: user exists but password mismatches
  Future<AuthResult> signIn(String id, String password) async {
    try {
      final user = await _loadUser(id);
      if (user == null) return AuthResult.userNotFound;
      final stored = (user['password'] as String?) ?? '';
      return stored == password ? AuthResult.success : AuthResult.wrongPassword;
    } catch (_) {
      return AuthResult.failure;
    }
  }

  /// Creates a new local user with required fullName and optional email/phone.
  /// - success: user saved
  /// - alreadyExists: id is already in use
  Future<AuthResult> createAccount(
    String id,
    String password, {
    required String fullName,
    String? email,
    String? phone,
  }) async {
    try {
      final exists = await userExists(id);
      if (exists) return AuthResult.alreadyExists;

      final data = <String, dynamic>{
        'id': id,
        'password': password,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'createdAt': DateTime.now().toIso8601String(),
      };
      await _saveUser(data);
      return AuthResult.success;
    } catch (_) {
      return AuthResult.failure;
    }
  }

  /// Loads a user record as a map, or null if missing.
  Future<Map<String, dynamic>?> getUser(String id) => _loadUser(id);

  /// Deletes a user (not used now, handy for testing).
  Future<bool> deleteUser(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_keyFor(id));
  }

  // ------------ internal helpers ------------

  Future<Map<String, dynamic>?> _loadUser(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFor(id));
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> _saveUser(Map<String, dynamic> user) async {
    final id = user['id'] as String?;
    if (id == null || id.trim().isEmpty) {
      throw ArgumentError('User must contain a non-empty "id"');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFor(id), jsonEncode(user));
  }
}

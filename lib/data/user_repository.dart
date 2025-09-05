import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  // We store each user under a unique key
  String _keyFor(String id) => 'user_v1_$id';

  Future<bool> userExists(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyFor(id));
  }

  Future<bool> checkPassword(String id, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFor(id));
    if (raw == null) return false;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return data['password'] == password;
  }

  Future<void> createUser({
    required String id,
    required String password,
    required String fullName,
    String? email,
    String? phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'id': id,
      'password': password,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'createdAt': DateTime.now().toIso8601String(),
    };
    await prefs.setString(_keyFor(id), jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getUser(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFor(id));
    return raw == null ? null : jsonDecode(raw) as Map<String, dynamic>;
  }
}

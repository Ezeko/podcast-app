import 'package:get_storage/get_storage.dart';

class StorageService {
  static final GetStorage _box = GetStorage();
  
  // Keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  
  // Initialize storage
  static Future<void> init() async {
    await GetStorage.init();
  }
  
  // Token management
  static Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
  }
  
  static String? getToken() {
    return _box.read(_tokenKey);
  }
  
  static bool hasToken() {
    return _box.hasData(_tokenKey);
  }
  
  // User data management
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _box.write(_userKey, userData);
  }
  
  static Future<void> saveUser(Map<String, dynamic> userData) async {
    await _box.write(_userKey, userData);
  }
  
  static Map<String, dynamic>? getUserData() {
    return _box.read(_userKey);
  }
  
  static Map<String, dynamic>? getUser() {
    return _box.read(_userKey);
  }
  
  // Onboarding flag
  static const String _onboardingKey = 'onboarding_seen';

  static Future<void> setOnboardingSeen(bool seen) async {
    await _box.write(_onboardingKey, seen);
  }

  static bool hasSeenOnboarding() {
    return _box.read(_onboardingKey) ?? false;
  }

  
  static Future<void> clearToken() async {
    await _box.remove(_tokenKey);
  }
  
  static Future<void> clearUser() async {
    await _box.remove(_userKey);
  }
}

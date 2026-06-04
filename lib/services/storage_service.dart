import 'package:get_storage/get_storage.dart';

class StorageService {
  static final GetStorage _box = GetStorage();
  
  // Keys
  static const String _tokenKey = 'auth_token';
  static const String _phoneKey = 'phone_number';
  static const String _userDataKey = 'user_data';
  
  // Initialize storage
  static Future<void> init() async {
    await GetStorage.init();
  }
  
  // Token operations
  static void saveToken(String token) {
    _box.write(_tokenKey, token);
    print('💾 Token saved to storage');
    print('🔑 Token: ${token.substring(0, 20)}...');
  }
  
  static String? getToken() {
    final token = _box.read(_tokenKey);
    if (token != null) {
      print('📤 Token retrieved from storage');
      print('🔑 Token: ${token.substring(0, 20)}...');
    } else {
      print('⚠️ No token found in storage');
    }
    return token;
  }
  
  static void clearToken() {
    _box.remove(_tokenKey);
    print('🗑️ Token cleared from storage');
  }
  
  // Phone number operations
  static void savePhoneNumber(String phone) {
    _box.write(_phoneKey, phone);
    print('💾 Phone number saved: $phone');
  }
  
  static String? getPhoneNumber() {
    return _box.read(_phoneKey);
  }
  
  // User data operations
  static void saveUserData(Map<String, dynamic> userData) {
    _box.write(_userDataKey, userData);
    print('💾 User data saved');
  }
  
  static Map<String, dynamic>? getUserData() {
    return _box.read(_userDataKey);
  }
  
  // Clear all data
  static void clearAll() {
    _box.erase();
    print('🗑️ All storage cleared');
  }
  
  // Check if user is logged in
  static bool isLoggedIn() {
    return _box.read(_tokenKey) != null;
  }
}

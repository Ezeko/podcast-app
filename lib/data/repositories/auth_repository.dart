import '../models/user_model.dart';
import '../providers/api_provider.dart';
import '../../shared/utils/storage_service.dart';

class AuthRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<LoginResponse?> login(String phone, String password) async {
    try {
      // print('🔵 Attempting login for phone: $phone');
      
      final response = await _apiProvider.post(
        '/api/auth/login',
        data: {
          'phone_number': phone,
          'password': password,
        },
      );
      
      // print('🔵 Raw API Response: ${response.data}');
      
      // Parse the nested response structure from response.data
      final loginResponse = LoginResponse.fromJson(response.data);
      
      // print('🔵 Parsed LoginResponse:');
      // print('   Message: ${loginResponse.message}');
      // print('   Token: ${loginResponse.data?.token}');
      // print('   User: ${loginResponse.data?.user?.fullName}');
      
      // Save the token from data.token
      if (loginResponse.data?.token != null) {
        await StorageService.saveToken(loginResponse.data!.token!);
        // print('✅ Token saved: ${loginResponse.data!.token!.substring(0, 20)}...');
      } else {
        // print('❌ No token found in response!');
      }
      
      // Save user data
      if (loginResponse.data?.user != null) {
        await StorageService.saveUser(loginResponse.data!.user!.toJson());
        // print('✅ User data saved');
      }
      
      return loginResponse;
    } catch (e) {
      // print('❌ Login error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await StorageService.clearToken();
    await StorageService.clearUser();
  }
}

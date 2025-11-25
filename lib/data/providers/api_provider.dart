import 'package:dio/dio.dart';
import '../../shared/utils/storage_service.dart';

class ApiProvider {
  static const String baseUrl = 'https://api.jollypodcast.net';
  
  // Singleton instance
  static final ApiProvider _instance = ApiProvider._internal();
  
  factory ApiProvider() {
    return _instance;
  }
  
  late Dio _dio;
  
  ApiProvider._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // Add interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token if available
        final token = StorageService.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
          // print('🔐 Token added: ${token.substring(0, 20)}...');
        } else {
          // print('⚠️ No token available');
        }
        // print('📤 REQUEST: ${options.method} ${options.uri}');
        // print('Headers: ${options.headers}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // print('📥 RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (error, handler) {
        // print('❌ ERROR: ${error.response?.statusCode} ${error.requestOptions.path}');
        // print('Message: ${error.message}');
        // print('Response: ${error.response?.data}');
        return handler.next(error);
      },
    ));
  }
  
  // GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  
  // POST request
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(path, data: data, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  
  // PUT request
  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  
  // DELETE request
  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}


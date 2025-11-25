import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../app/routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = Get.find();
  
  // Controllers
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Form key
  final formKey = GlobalKey<FormState>();
  
  // Observables
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Pre-fill with test credentials for easier testing
    phoneController.text = '08114227399';
    passwordController.text = 'Development@101';
  }
  
  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
  
  Future<void> login() async {
    // Clear previous error
    errorMessage.value = '';
    
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    try {
      isLoading.value = true;
      
      final phone = phoneController.text.trim();
      final password = passwordController.text.trim();
      
      // print('🔵 LoginController: Attempting login...');
      final response = await _authRepository.login(phone, password);
      
      if (response != null && response.data?.token != null) {
        // print('✅ LoginController: Login successful!');
        
        // Show success message
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );
        
        // Navigate to main on success
        Get.offAllNamed(AppRoutes.main);
      } else {
        // print('❌ LoginController: Login failed - no token');
        errorMessage.value = 'Login failed. Please check your credentials.';
        
        Get.snackbar(
          'Error',
          'Login failed. Please check your credentials.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
        );
      }
      
    } catch (e) {
      // print('❌ LoginController: Exception - $e');
      errorMessage.value = 'An error occurred. Please try again.';
      
      Get.snackbar(
        'Error',
        'An error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }
}

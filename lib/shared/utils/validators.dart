import '../constants/app_strings.dart';

class Validators {
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseEnterPhone;
    }
    // Basic phone validation - at least 10 digits
    if (value.replaceAll(RegExp(r'\D'), '').length < 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseEnterPassword;
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}

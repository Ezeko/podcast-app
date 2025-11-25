import 'package:get/get.dart';
import '../../../shared/utils/storage_service.dart';
import '../../../app/routes/app_routes.dart';

class ProfileController extends GetxController {
  
  final RxString userName = 'User'.obs;
  final RxString userEmail = ''.obs;
  final RxInt following = 3.obs;
  final RxInt playlists = 2.obs;
  final RxDouble minutesListened = 255.89.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    final user = StorageService.getUser();
    if (user != null) {
      final firstName = user['first_name'] ?? '';
      final lastName = user['last_name'] ?? '';
      final fullName = '$firstName $lastName'.trim();
      
      userName.value = fullName.isNotEmpty ? fullName : 'User';
      userEmail.value = user['email'] ?? '';
    }
  }
  
  void goToAccountSettings() {
    Get.snackbar('Account Settings', 'Feature coming soon');
  }
  
  void goToSecuritySettings() {
    Get.snackbar('Security Settings', 'Feature coming soon');
  }
  
  void goToNotifications() {
    Get.snackbar('Notifications', 'Feature coming soon');
  }
  
  void becomePodcastCreator() {
    Get.snackbar('Become a Creator', 'Feature coming soon');
  }
  
  Future<void> logout() async {
    await StorageService.clearToken();
    await StorageService.clearUser();
    Get.offAllNamed(AppRoutes.login);
  }
}

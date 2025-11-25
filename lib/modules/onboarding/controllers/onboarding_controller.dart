import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../shared/utils/storage_service.dart';

class OnboardingController extends GetxController {
  // PageView controller
  final PageController pageController = PageController();
  
  // Form controllers
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final birthdateController = TextEditingController();
  
  // Observables
  final RxInt currentPage = 0.obs;
  final RxList<String> selectedTopics = <String>[].obs;
  final RxString selectedAvatar = ''.obs;
  final RxString selectedPlan = ''.obs;
  final RxString selectedGender = ''.obs;
  final RxString userName = 'Devon'.obs;
  
  // Available topics matching the design
  final List<String> availableTopics = [
    'Business & Career',
    'Movies & Cinema',
    'Tech trends',
    'Mountain climbing',
    'Educational',
    'Religious & Spiritual',
    'Sip & Paint',
    'Fitness',
    'Sports',
    'Kayaking',
    'Clubs & Party',
    'Games',
    'Comedies',
    'Art & Culture',
    'Karaoke',
    'Adventure',
    'Health & Lifestyle',
    'Food & Drinks',
  ];
  
  // Available avatars (using emoji for now, can be replaced with assets)
  final List<Map<String, dynamic>> availableAvatars = [
    {'id': '1', 'emoji': '👨‍💼', 'color': Color(0xFFB4E7CE)},
    {'id': '2', 'emoji': '👨‍🎨', 'color': Color(0xFF9BCDFF)},
    {'id': '3', 'emoji': '👩‍💼', 'color': Color(0xFFFFB4D5)},
    {'id': '4', 'emoji': '👨‍🔬', 'color': Color(0xFFB4E7CE)},
    {'id': '5', 'emoji': '👩‍🎨', 'color': Color(0xFF9BCDFF)},
    {'id': '6', 'emoji': '👨‍🏫', 'color': Color(0xFFFF6B9D)},
    {'id': '7', 'emoji': '👩‍🔬', 'color': Color(0xFFB4E7CE)},
    {'id': '8', 'emoji': '👩‍🏫', 'color': Color(0xFF9BCDFF)},
    {'id': '9', 'emoji': '👨‍💻', 'color': Color(0xFFFFB4D5)},
  ];
  
  // Subscription plans
  final List<Map<String, dynamic>> subscriptionPlans = [
    {
      'id': 'daily',
      'name': 'Daily Jolly Plan',
      'price': '₦100',
      'duration': 'One-time',
      'features': [
        'Enjoy unlimited podcast for 24 hours.',
        'You can cancel at anytime.',
      ],
      'autoRenewal': false,
    },
    {
      'id': 'weekly',
      'name': 'Weekly Jolly Plan',
      'price': '₦200',
      'duration': 'Auto-renewal',
      'features': [
        'Enjoy unlimited podcast for 24 hours.',
        'You can cancel at anytime.',
      ],
      'autoRenewal': true,
    },
    {
      'id': 'monthly',
      'name': 'Monthly Jolly Plan',
      'price': '₦500',
      'duration': 'Auto-renewal',
      'features': [
        'Enjoy unlimited podcast for 24 hours.',
        'You can cancel at anytime.',
      ],
      'autoRenewal': true,
    },
  ];
  
  @override
  void onInit() {
    super.onInit();
    // Pre-select some topics for demo
    selectedTopics.addAll(['Business & Career', 'Movies & Cinema']);
  }
  
  @override
  void onClose() {
    pageController.dispose();
    phoneController.dispose();
    otpController.dispose();
    nameController.dispose();
    usernameController.dispose();
    birthdateController.dispose();
    super.onClose();
  }
  
  void toggleTopic(String topic) {
    if (selectedTopics.contains(topic)) {
      selectedTopics.remove(topic);
    } else {
      selectedTopics.add(topic);
    }
  }
  
  void selectAvatar(String avatarId) {
    selectedAvatar.value = avatarId;
  }
  
  void selectPlan(String planId) {
    selectedPlan.value = planId;
  }
  
  void selectGender(String gender) {
    selectedGender.value = gender;
  }
  
  void nextPage() {
    if (currentPage.value < 6) {
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Complete onboarding
      completeOnboarding();
    }
  }
  
  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  void completeOnboarding() {
    // Mark onboarding as seen
    StorageService.setOnboardingSeen(true);
    
    // Navigate to login (or home if already authenticated)
    Get.offAllNamed(AppRoutes.login);
  }
  
  void skipToLogin() {
    // Mark onboarding as seen
    StorageService.setOnboardingSeen(true);
    
    Get.offAllNamed(AppRoutes.login);
  }
  
  bool canContinue() {
    switch (currentPage.value) {
      case 0: // Splash
        return true;
      case 1: // Login/Signup
        return phoneController.text.length >= 10;
      case 2: // OTP
        return otpController.text.length == 6;
      case 3: // Account setup
        return nameController.text.isNotEmpty && usernameController.text.isNotEmpty;
      case 4: // Topics
        return selectedTopics.isNotEmpty;
      case 5: // Avatar
        return selectedAvatar.value.isNotEmpty;
      case 6: // Complete
        return true;
      default:
        return true;
    }
  }
  
  String getButtonText() {
    if (currentPage.value == 0) return 'Continue';
    if (currentPage.value == 1) return 'Continue';
    if (currentPage.value == 2) return 'Verify';
    if (currentPage.value == 6) return 'Get Started';
    return 'Continue';
  }
}


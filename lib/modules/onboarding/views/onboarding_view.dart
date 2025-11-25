import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/topic_chip.dart';
import '../../../shared/widgets/avatar_selector.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF0F0F1E),
        child: SafeArea(
          child: PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) => controller.currentPage.value = index,
            children: [

              _buildLoginScreen(controller),
              _buildOTPScreen(controller),
              _buildAccountSetupScreen(controller),
              _buildWelcomeScreen(controller),
              _buildAvatarScreen(controller),
              _buildCompleteScreen(controller),
            ],
          ),
        ),
      ),
    );
  }
  
  
  // Screen 2: Login/Signup
  Widget _buildLoginScreen(OnboardingController controller) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0F0F1E),
            ),
            child: Stack(
              children: [
                // Background image at the top
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 350,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/podcast_studio.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF0F0F1E).withValues(alpha: 0.8),
                            const Color(0xFF0F0F1E),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Content - wrapped in SingleChildScrollView for overflow fix
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 310, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Jolly logo image
                        Image.asset(
                          'assets/images/jolly_logo.png',
                          width: 140,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'PODCASTS FOR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'AFRICA, BY AFRICANS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        // Phone number input
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF252541),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.phone_outlined, color: Color(0xFF6E6E82)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: controller.phoneController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: 'Enter phone or email',
                                    hintStyle: TextStyle(color: Color(0xFF6E6E82)),
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                        GestureDetector(
                          onTap: controller.skipToLogin,
                          child: const Text(
                            'BECOME A PODCAST CREATOR',
                            style: TextStyle(
                              color: Color(0xFF00C853),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'By creating an account or logging in, you agree to our\nTerms of Service and Privacy Policy',
                          style: TextStyle(
                            color: Color(0xFF6E6E82),
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Continue button
        Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(() => CustomButton(
            text: controller.getButtonText(),
            onPressed: controller.canContinue()
                ? controller.nextPage
                : null,
          )),
        ),
      ],
    );
  }
  
  // Screen 3: OTP Verification
  Widget _buildOTPScreen(OnboardingController controller) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F0F1E), Color(0xFF1A1A2E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Jolly logo image
                  Image.asset(
                    'assets/images/jolly_logo.png',
                    width: 120,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Enter the 6 digit code sent to your\nphone number: (+234)1234567',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // 6-digit OTP input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 50,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF252541),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF00C853),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            index < controller.otpController.text.length
                                ? controller.otpController.text[index]
                                : '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Resend code',
                    style: TextStyle(
                      color: Color(0xFF00C853),
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Continue button
        Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(() => CustomButton(
            text: controller.getButtonText(),
            onPressed: controller.canContinue()
                ? controller.nextPage
                : null,
          )),
        ),
      ],
    );
  }
  
  // Screen 4: Complete Account Setup
  Widget _buildAccountSetupScreen(OnboardingController controller) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00C853), Color(0xFF00E676)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Complete account setup',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Kindly fill in the form to setup your account.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildInputField('Name', controller.nameController, Icons.person_outline),
                  const SizedBox(height: 16),
                  _buildInputField('Username', controller.usernameController, Icons.alternate_email),
                  const SizedBox(height: 16),
                  _buildInputField('08114227399', controller.phoneController, Icons.phone_outlined),
                  const SizedBox(height: 16),
                  _buildInputField('Birthdate', controller.birthdateController, Icons.calendar_today),
                  const SizedBox(height: 16),
                  // Gender selection
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => _buildGenderButton(
                          'Male',
                          controller.selectedGender.value == 'Male',
                          () => controller.selectGender('Male'),
                        )),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(() => _buildGenderButton(
                          'Female',
                          controller.selectedGender.value == 'Female',
                          () => controller.selectGender('Female'),
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'I have accepted',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Continue button
        Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: Obx(() => ElevatedButton(
              onPressed: controller.canContinue() ? controller.nextPage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F0F1E),
                disabledBackgroundColor: const Color(0xFF0F0F1E).withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
          ),
        ),
      ],
    );
  }
  
  Widget _buildInputField(String hint, TextEditingController controller, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white60),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGenderButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black26 : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
  
  // Screen 5: Welcome with topics (green background)
  Widget _buildWelcomeScreen(OnboardingController controller) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00C853), Color(0xFF00E676)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Headphones icon at top left
                const Positioned(
                  top: 20,
                  left: 20,
                  child: Icon(
                    Icons.headphones,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                // Content
                SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Obx(() => Text(
                        'Welcome, ${controller.userName.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      const SizedBox(height: 8),
                      const Text(
                        'Personalize your Jolly experience by selecting\nyour top interest and favorite topics.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Obx(() => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.availableTopics.map((topic) {
                          final isSelected = controller.selectedTopics.contains(topic);
                          return TopicChip(
                            topic: topic,
                            isSelected: isSelected,
                            onTap: () => controller.toggleTopic(topic),
                          );
                        }).toList(),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Continue button
        Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(() => CustomButton(
            text: controller.getButtonText(),
            onPressed: controller.canContinue()
                ? controller.nextPage
                : null,
          )),
        ),
      ],
    );
  }
  
  // Screen 6: Avatar selection (green background)
  Widget _buildAvatarScreen(OnboardingController controller) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00C853), Color(0xFF00E676)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Headphones icon at top left
                const Positioned(
                  top: 20,
                  left: 20,
                  child: Icon(
                    Icons.headphones,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                // Content
                SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      const Text(
                        'Select an avatar to represent\nyour funk',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 48),
                      Obx(() => Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: controller.availableAvatars.map((avatar) {
                          final isSelected = controller.selectedAvatar.value == avatar['id'];
                          return AvatarSelector(
                            avatarId: avatar['id'],
                            emoji: avatar['emoji'],
                            isSelected: isSelected,
                            onTap: () => controller.selectAvatar(avatar['id']),
                          );
                        }).toList(),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Continue button
        Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(() => CustomButton(
            text: controller.getButtonText(),
            onPressed: controller.canContinue()
                ? controller.nextPage
                : null,
          )),
        ),
      ],
    );
  }
  
  // Screen 7: Complete (dark background)
  Widget _buildCompleteScreen(OnboardingController controller) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F0F1E), Color(0xFF1A1A2E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  // Avatar display
                  Obx(() {
                    final avatarId = controller.selectedAvatar.value;
                    final avatar = controller.availableAvatars.firstWhere(
                      (a) => a['id'] == avatarId,
                      orElse: () => controller.availableAvatars[0],
                    );
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00C853),
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          avatar['emoji'],
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 32),
                  Obx(() => Text(
                    'You\'re all set ${controller.userName.value}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )),
                  const SizedBox(height: 16),
                  const Text(
                    'Subscribe to a plan to enjoy Jolly Premium.\nGet access to all audio contents, personalize\nyour library to your style and do more cool\njolly stuff.',
                    style: TextStyle(
                      color: Color(0xFFB0B0C3),
                      fontSize: 15,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'By continuing, you verify that you are at least 18 years old,\nand you agree with our Terms of Use',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        // Continue button
        Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(() => CustomButton(
            text: controller.getButtonText(),
            onPressed: controller.canContinue()
                ? controller.nextPage
                : null,
          )),
        ),
      ],
    );
  }
}

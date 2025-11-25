import 'package:flutter/material.dart';

class ProfessionalErrorScreen extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;
  final IconData icon;

  const ProfessionalErrorScreen({
    super.key,
    this.title = 'Oops! Something went wrong',
    this.message = 'We encountered an error. Please try again.',
    this.onRetry,
    this.onGoHome,
    this.icon = Icons.error_outline,
  });

  // Factory constructors for common error types
  factory ProfessionalErrorScreen.network({
    VoidCallback? onRetry,
    VoidCallback? onGoHome,
  }) {
    return ProfessionalErrorScreen(
      title: 'No Internet Connection',
      message: 'Please check your connection and try again.',
      icon: Icons.wifi_off_outlined,
      onRetry: onRetry,
      onGoHome: onGoHome,
    );
  }

  factory ProfessionalErrorScreen.auth({
    VoidCallback? onRetry,
    VoidCallback? onGoHome,
  }) {
    return ProfessionalErrorScreen(
      title: 'Authentication Required',
      message: 'Please log in again to continue.',
      icon: Icons.lock_outline,
      onRetry: onRetry,
      onGoHome: onGoHome,
    );
  }

  factory ProfessionalErrorScreen.server({
    VoidCallback? onRetry,
    VoidCallback? onGoHome,
  }) {
    return ProfessionalErrorScreen(
      title: 'Server Error',
      message: 'Our servers are having issues. Please try again later.',
      icon: Icons.cloud_off_outlined,
      onRetry: onRetry,
      onGoHome: onGoHome,
    );
  }

  factory ProfessionalErrorScreen.notFound({
    VoidCallback? onRetry,
    VoidCallback? onGoHome,
  }) {
    return ProfessionalErrorScreen(
      title: 'Content Not Found',
      message: 'The content you\'re looking for doesn\'t exist.',
      icon: Icons.search_off_outlined,
      onRetry: onRetry,
      onGoHome: onGoHome,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF0B0B0F),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF00C853).withValues(alpha: 0.2),
                      const Color(0xFF00C853).withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 60,
                  color: const Color(0xFF00C853),
                ),
              ),
              const SizedBox(height: 32),
              
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              Text(
                message,
                style: const TextStyle(
                  color: Color(0xFFB0B0C3),
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              if (onRetry != null)
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C853),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              
              if (onGoHome != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton(
                    onPressed: onGoHome,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF00C853)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Go to Home',
                      style: TextStyle(
                        color: Color(0xFF00C853),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

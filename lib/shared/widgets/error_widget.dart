import 'package:flutter/material.dart';
import 'professional_error_screen.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_strings.dart';

class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorDisplay({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // Determine error type from message
    if (message.toLowerCase().contains('internet') || 
        message.toLowerCase().contains('network') ||
        message.toLowerCase().contains('connection')) {
      return ProfessionalErrorScreen.network(onRetry: onRetry);
    } else if (message.toLowerCase().contains('log in') || 
               message.toLowerCase().contains('auth')) {
      return ProfessionalErrorScreen.auth(onRetry: onRetry);
    } else if (message.toLowerCase().contains('server') ||
               message.toLowerCase().contains('500') ||
               message.toLowerCase().contains('502') ||
               message.toLowerCase().contains('503')) {
      return ProfessionalErrorScreen.server(onRetry: onRetry);
    } else if (message.toLowerCase().contains('not found') ||
               message.toLowerCase().contains('404')) {
      return ProfessionalErrorScreen.notFound(onRetry: onRetry);
    }
    
    // Default error screen
    return ProfessionalErrorScreen(
      message: message,
      onRetry: onRetry,
    );
  }
}

class EmptyState extends StatelessWidget {
  final String? message;
  final IconData? icon;

  const EmptyState({
    super.key,
    this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.inbox_rounded,
            size: 64,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            message ?? AppStrings.noPodcastsFound,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/utils/storage_service.dart';
import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // If no token, redirect to login screen
    if (!StorageService.hasToken()) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null; // allow navigation
  }
}

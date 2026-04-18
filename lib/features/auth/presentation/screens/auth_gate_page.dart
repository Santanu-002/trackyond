import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';

class AuthGatePage extends GetView<AuthController> {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger bootstrap on first build if it hasn't been started yet.
    // Since AuthController is permanent, we can ensure it runs once.
    // Note: In GetX, onReady is often better for navigation actions.
    
    // We'll call bootstrap here just in case, but usually splash logic 
    // happens in onReady or via a specific trigger.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.bootstrap();
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

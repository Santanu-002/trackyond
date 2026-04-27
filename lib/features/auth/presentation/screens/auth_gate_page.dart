import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';

class AuthGatePage extends GetView<AuthController> {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

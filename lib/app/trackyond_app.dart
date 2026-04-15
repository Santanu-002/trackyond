import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_pages.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/theme/app_theme.dart';
import 'package:trackyond/app/bindings/initial_bindings.dart';

class TrackyondApp extends StatelessWidget {
  const TrackyondApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.common.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialBinding: InitialBindings(),
      initialRoute: AppRoutes.common.auth.splash,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      getPages: AppPages.pages,
    );
  }
}

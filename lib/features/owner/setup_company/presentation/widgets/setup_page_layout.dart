import 'package:flutter/material.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/header/app_header.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

/// A unified wireframe for the setup flow pages.
/// Encapsulates the scaffold, header, scrollable content, and primary action button.
class SetupPageLayout extends StatelessWidget {
  final String scaffoldTitle;
  final IconData headerIcon;
  final String headerTitle;
  final String headerSubtitle;
  final Widget child;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final bool isLoading;
  final Widget? footer;

  const SetupPageLayout({
    super.key,
    required this.scaffoldTitle,
    required this.headerIcon,
    required this.headerTitle,
    required this.headerSubtitle,
    required this.child,
    required this.buttonText,
    this.onButtonPressed,
    this.isLoading = false,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: scaffoldTitle,
      child: Column(
        children: [
          // Header Section
          AppHeader(
            icon: headerIcon,
            title: headerTitle,
            subtitle: headerSubtitle,
          ),

          AppUIConstants.widgets.verticalBox$32,

          // Main Content
          child,

          AppUIConstants.widgets.verticalBox$32,

          // Primary Action Button
          AppButton.filled(
            text: buttonText,
            onPressed: onButtonPressed,
            isLoading: isLoading,
          ),

          // Optional Footer (e.g. Terms & Privacy)
          if (footer != null) ...[
            AppUIConstants.widgets.verticalBox$24,
            footer!,
          ],
        ],
      ),
    );
  }
}

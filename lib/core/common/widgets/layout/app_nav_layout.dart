import 'package:flutter/material.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/button/app_floating_action_button.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';

class AppNavLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? drawer;
  final VoidCallback? onFabPressed;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? padding;

  final Widget? leading;

  const AppNavLayout({
    super.key,
    required this.title,
    required this.child,
    this.drawer,
    this.leading,
    this.onFabPressed,
    this.actions,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      padding: padding,
      floatingActionButton: onFabPressed != null
          ? AppFloatingActionButton(
              onPressed: onFabPressed!,
            )
          : null,
      drawer: drawer,
      leading: leading ??
          (drawer != null
              ? Builder(
                  builder: (context) => IconButton(
                    icon: Icon(AppIcons.common.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                )
              : null),
      actions: actions ?? [AppUIConstants.widgets.horizontalBox$8],
      useScrollView: true,
      child: child,
    );
  }
}

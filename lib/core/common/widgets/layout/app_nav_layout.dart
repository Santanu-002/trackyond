import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/button/app_floating_action_button.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';

class AppNavLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? drawer;
  final VoidCallback? onFabPressed;
  final Widget Function(BuildContext, void Function({Object? returnValue}))? openBuilder;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? padding;
  final Widget? leading;
  final bool useScrollView;

  const AppNavLayout({
    super.key,
    required this.title,
    required this.child,
    this.drawer,
    this.leading,
    this.onFabPressed,
    this.openBuilder,
    this.actions,
    this.padding,
    this.useScrollView = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      padding: padding,
      floatingActionButton: openBuilder != null
          ? OpenContainer(
              transitionDuration: const Duration(milliseconds: 250),
              openBuilder: openBuilder!,
              closedElevation: 6,
              closedShape: const CircleBorder(),
              closedColor: context.theme.colorScheme.primary,
              openColor: context.theme.scaffoldBackgroundColor,
              closedBuilder: (context, openContainer) => AppFloatingActionButton(
                onPressed: openContainer,
              ),
            )
          : (onFabPressed != null
              ? AppFloatingActionButton(
                  onPressed: onFabPressed!,
                )
              : null),
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
      useScrollView: useScrollView,
      child: child,
    );
  }
}

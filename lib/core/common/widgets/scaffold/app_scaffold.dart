import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? titleWidget;
  final bool? centerTitle;
  final double? titleSpacing;
  final VoidCallback? onBackPressed;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final bool useScrollView;
  final Widget? footer;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? leading;
  final EdgeInsetsGeometry? padding;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const AppScaffold({
    super.key,
    required this.child,
    this.title,
    this.titleWidget,
    this.centerTitle,
    this.titleSpacing,
    this.onBackPressed,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.useScrollView = true,
    this.footer,
    this.drawer,
    this.endDrawer,
    this.leading,
    this.padding,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        drawer: drawer,
        endDrawer: endDrawer,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        appBar: AppBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          elevation: 0,
          titleSpacing: titleSpacing,
          centerTitle: centerTitle ?? true,
          title: titleWidget ?? (title != null ? Text(title!) : null),
          systemOverlayStyle: context.theme.brightness == Brightness.light
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
          actions: actions,
          automaticallyImplyLeading: false,
          leading:
              leading ??
              ((onBackPressed != null ||
                      (automaticallyImplyLeading &&
                          (ModalRoute.of(context)?.canPop ?? false)))
                  ? IconButton(
                      onPressed: onBackPressed ?? Get.back,
                      icon: Icon(
                        AppIcons.common.back,
                        color: context.theme.colorScheme.onSurface,
                        size: 20,
                      ),
                    )
                  : null),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: useScrollView
                    ? SingleChildScrollView(
                        padding:
                            padding ??
                            EdgeInsets.all(AppUIConstants.spacing.space$24),
                        child: child,
                      )
                    : Padding(
                        padding:
                            padding ??
                            EdgeInsets.all(AppUIConstants.spacing.space$24),
                        child: child,
                      ),
              ),
              if (footer != null)
                Padding(
                  padding: EdgeInsets.all(AppUIConstants.spacing.space$24),
                  child: footer!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

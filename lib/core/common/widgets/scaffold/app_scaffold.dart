import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final String? title;
  final VoidCallback? onBackPressed;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;

  const AppScaffold({
    super.key,
    required this.child,
    this.title,
    this.onBackPressed,
    this.automaticallyImplyLeading = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: title != null ? Text(title!) : null,
          systemOverlayStyle: context.theme.brightness == Brightness.light
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,

          actions: actions,
          automaticallyImplyLeading: false,
          leading:
              (onBackPressed != null ||
                  (automaticallyImplyLeading &&
                      (ModalRoute.of(context)?.canPop ?? false)))
              ? IconButton(
                  onPressed: onBackPressed ?? Get.back,
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: context.theme.colorScheme.onSurface,
                    size: 20,
                  ),
                )
              : null,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppUIConstants.spacing.space$24),
            child: child,
          ),
        ),
      ),
    );
  }
}

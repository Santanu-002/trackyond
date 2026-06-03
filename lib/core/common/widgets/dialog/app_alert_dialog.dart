import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppAlertDialog extends StatelessWidget {
  final String? title;
  final String message;
  final String? confirmText;
  final VoidCallback? onConfirm;
  final String? cancelText;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final bool canPop;
  final List<Widget>? actions;
  final bool actionsVertical;

  const AppAlertDialog({
    super.key,
    this.title,
    required this.message,
    this.confirmText,
    this.onConfirm,
    this.cancelText,
    this.onCancel,
    this.isDestructive = false,
    this.canPop = true,
    this.actions,
    this.actionsVertical = false,
  }) : assert(actions != null || (confirmText != null && onConfirm != null));

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required String message,
    String? confirmText,
    VoidCallback? onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
    bool isDestructive = false,
    bool canPop = true,
    List<Widget>? actions,
    bool actionsVertical = false,
  }) {
    return Get.dialog<T>(
      AppAlertDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        onConfirm: onConfirm,
        cancelText: cancelText,
        onCancel: onCancel,
        isDestructive: isDestructive,
        canPop: canPop,
        actions: actions,
        actionsVertical: actionsVertical,
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(AppUIConstants.spacing.space$24),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$24),
            boxShadow: [
              BoxShadow(
                color: context.theme.colorScheme.onSurface.withValues(alpha: 0.1),
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDestructive
                        ? context.theme.colorScheme.error
                        : context.theme.colorScheme.onSurface,
                  ),
                ),
                AppUIConstants.widgets.verticalBox$12,
              ],
              Text(
                message,
                textAlign: TextAlign.start,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppUIConstants.widgets.verticalBox$24,
              if (actionsVertical)
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: AppUIConstants.spacing.space$8,
                    children: actions ?? [],
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: AppUIConstants.spacing.space$12,
                  children: actions ?? [
                    if (cancelText != null)
                      Expanded(
                        child: AppButton.ghost(
                          text: cancelText!,
                          onPressed: onCancel ?? () => Get.back(),
                        ),
                      ),
                    Expanded(
                      child: isDestructive
                          ? AppButton.custom(
                              onPressed: onConfirm!,
                              child: Container(
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: context.theme.colorScheme.errorContainer,
                                  borderRadius: BorderRadius.circular(
                                      AppUIConstants.radius.radius$12),
                                ),
                                child: Text(
                                  confirmText!,
                                  style: context.textTheme.labelLarge?.copyWith(
                                    color: context.theme.colorScheme.onErrorContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : AppButton.filled(
                              text: confirmText!,
                              onPressed: onConfirm!,
                            ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

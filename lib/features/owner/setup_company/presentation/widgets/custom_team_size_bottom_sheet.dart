import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/text_field/app_text_field.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class CustomTeamSizeBottomSheet extends StatefulWidget {
  final int? initialValue;
  final Function(int) onConfirm;

  const CustomTeamSizeBottomSheet({
    super.key,
    this.initialValue,
    required this.onConfirm,
  });

  @override
  State<CustomTeamSizeBottomSheet> createState() =>
      _CustomTeamSizeBottomSheetState();
}

class _CustomTeamSizeBottomSheetState extends State<CustomTeamSizeBottomSheet> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue != null && widget.initialValue! > 0
          ? widget.initialValue.toString()
          : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppUIConstants.spacing.space$24),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppUIConstants.radius.radius$24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppUIConstants.spacing.space$24,
            children: [
              Column(
                spacing: AppUIConstants.spacing.space$4,
                children: [
                  Text(
                    AppStrings.chooseTeamSize.customTitle,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppStrings.chooseTeamSize.customSubtitle,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.theme.colorScheme.onSurface.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              ),
              AppTextField(
                controller: _controller,
                label: AppStrings.chooseTeamSize.teamSizeLabel,
                hintText: AppStrings.chooseTeamSize.teamSizeHint,
                keyboardType: TextInputType.number,
                autofocus: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.common.requiredField;
                  }
                  final n = int.tryParse(value);
                  if (n == null || n < 1 || n > 999999) {
                    return AppStrings.chooseTeamSize.invalidTeamSize;
                  }
                  return null;
                },
              ),
              Row(
                spacing: AppUIConstants.spacing.space$12,
                children: [
                  Expanded(
                    child: AppButton.outlined(
                      text: AppStrings.common.cancel,
                      onPressed: () => Get.back(),
                    ),
                  ),
                  Expanded(
                    child: AppButton.filled(
                      text: AppStrings.common.confirm,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final size = int.parse(_controller.text);
                          widget.onConfirm(size);
                          Get.back();
                          HapticFeedback.mediumImpact();
                        }
                      },
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

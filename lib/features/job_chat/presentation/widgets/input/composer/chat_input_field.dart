import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/text_field/app_text_field.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Widget? suffix;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? textColor;
  final Color? hintColor;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.suffix,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.textColor,
    this.hintColor,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final RxBool _hasFocus = false.obs;

  @override
  void initState() {
    super.initState();
    _hasFocus.value = widget.focusNode.hasFocus;
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) {
      _hasFocus.value = widget.focusNode.hasFocus;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;

    return Obx(() {
      final isFocused = _hasFocus.value;
      final effectiveBgColor = widget.backgroundColor ?? colorScheme.surface;
      final effectiveBorderColor = widget.borderColor ?? colorScheme.onSurfaceVariant.withValues(alpha: 0.2);
      final effectiveFocusedBorderColor = widget.focusedBorderColor ?? colorScheme.primary;

      return Container(
        decoration: BoxDecoration(
          color: effectiveBgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isFocused ? effectiveFocusedBorderColor : effectiveBorderColor,
            width: isFocused ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppTextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                hintText: widget.hintText,
                textStyle: textTheme.bodyMedium?.copyWith(
                  color: widget.textColor ?? colorScheme.onSurface,
                ),
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: widget.hintColor ?? colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
                maxLines: 5,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                filled: false,
              ),
            ),
            if (widget.suffix != null) widget.suffix!,
          ],
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? prefix;
  final IconData? prefixIcon;
  final double? prefixIconSize;
  final Widget? suffix;
  final int? maxLength;
  final String? errorText;
  final bool readOnly;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final void Function(String)? onChanged;
  final bool autofocus;
  final BorderRadius? borderRadius;

  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.obscureText = false,
    this.prefix,
    this.prefixIcon,
    this.prefixIconSize,
    this.suffix,
    this.maxLength,
    this.errorText,
    this.readOnly = false,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.sentences,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    this.onChanged,
    this.autofocus = false,
    this.borderRadius,
  });
  @override
  Widget build(BuildContext context) {
    final Widget? effectivePrefix =
        prefix ??
        (prefixIcon != null
            ? Icon(
                prefixIcon,
                size: prefixIconSize ?? 20,
                color: context.theme.colorScheme.primary,
              )
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: AppUIConstants.spacing.space$8,
      children: [
        if (label != null)
          Text(
            label!,
            style: context.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          obscureText: obscureText,
          maxLength: maxLength,
          onChanged: onChanged,
          readOnly: readOnly,
          enabled: enabled,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          autofocus: autofocus,
          style: context.textTheme.bodyLarge?.copyWith(
            color: (readOnly || !enabled)
                ? context.theme.colorScheme.onSurface.withValues(alpha: 0.5)
                : null,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: effectivePrefix,
            suffixIcon: suffix,
            errorText: errorText,
            fillColor: (readOnly || !enabled)
                ? context.theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  )
                : null,
            focusedBorder: borderRadius != null
                ? OutlineInputBorder(
                    borderRadius: borderRadius!,
                    borderSide: BorderSide(
                      color: context.theme.colorScheme.primary,
                      width: 2,
                    ),
                  )
                : (readOnly
                      ? context.theme.inputDecorationTheme.enabledBorder
                      : null),
            enabledBorder: borderRadius != null
                ? OutlineInputBorder(
                    borderRadius: borderRadius!,
                    borderSide: BorderSide(
                      color: context.theme.colorScheme.outlineVariant,
                    ),
                  )
                : null,
            border: borderRadius != null
                ? OutlineInputBorder(borderRadius: borderRadius!)
                : null,
          ),
        ),
      ],
    );
  }
}

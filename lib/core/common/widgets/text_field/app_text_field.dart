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
  final void Function(String)? onFieldSubmitted;
  final bool autofocus;
  final FocusNode? focusNode;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final EdgeInsetsGeometry? contentPadding;
  final bool? filled;
  final Color? fillColor;
  final int? maxLines;
  final int? minLines;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

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
    this.onFieldSubmitted,
    this.autofocus = false,
    this.focusNode,
    this.borderRadius,
    this.borderSide,
    this.contentPadding,
    this.filled,
    this.fillColor,
    this.maxLines = 1,
    this.minLines,
    this.textStyle,
    this.hintStyle,
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
          RichText(
            text: TextSpan(
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color:
                    context.theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              children: [
                TextSpan(
                  text: label!.replaceAll('*', ''),
                ),
                if (label!.contains('*'))
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      color: context.theme.colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          obscureText: obscureText,
          maxLength: maxLength,
          maxLines: maxLines,
          minLines: minLines,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          readOnly: readOnly,
          enabled: enabled,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          autofocus: autofocus,
          style: textStyle ??
              context.textTheme.bodyLarge?.copyWith(
                color: (readOnly || !enabled)
                    ? context.theme.colorScheme.onSurface.withValues(alpha: 0.5)
                    : null,
              ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle,
            prefixIcon: effectivePrefix,
            suffixIcon: suffix,
            errorText: errorText,
            contentPadding: contentPadding,
            filled: filled,
            fillColor: fillColor ??
                ((readOnly || !enabled)
                    ? context.theme.colorScheme.surfaceContainerHighest
                        .withValues(
                        alpha: 0.3,
                      )
                    : null),
            focusedBorder: borderRadius != null
                ? OutlineInputBorder(
                    borderRadius: borderRadius!,
                    borderSide: borderSide ??
                        BorderSide(
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
                    borderSide: borderSide ??
                        BorderSide(
                          color: context.theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.2),
                        ),
                  )
                : null,
            border: borderRadius != null
                ? OutlineInputBorder(
                    borderRadius: borderRadius!,
                    borderSide: borderSide ?? const BorderSide(),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

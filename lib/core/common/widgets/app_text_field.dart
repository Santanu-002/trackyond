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
  final Widget? suffix;
  final int? maxLength;

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
    this.suffix,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
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
          style: context.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: context.textTheme.bodyLarge?.copyWith(
              color: context.theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            prefixIcon: prefix,
            suffixIcon: suffix,
            filled: true,
            fillColor: context.theme.colorScheme.surface,
            contentPadding: EdgeInsets.all(AppUIConstants.spacing.space$16),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppUIConstants.radius.radius$12),
              borderSide: BorderSide(
                color: context.theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppUIConstants.radius.radius$12),
              borderSide: BorderSide(
                color: context.theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppUIConstants.radius.radius$12),
              borderSide: BorderSide(
                color: context.theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppUIConstants.radius.radius$12),
              borderSide: BorderSide(
                color: context.theme.colorScheme.error,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

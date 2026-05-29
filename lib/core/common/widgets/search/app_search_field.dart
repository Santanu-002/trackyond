import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/text_field/app_text_field.dart';
import 'package:trackyond/core/constants/app_icons.dart';

/// A specialized search field that works with Obx and GetX controllers.
/// It utilizes the standardized [AppTextField] for consistent styling across the app.
class AppSearchField extends StatelessWidget {
  final RxString query;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final BorderRadius? borderRadius;
  final Widget? leading;
  final List<Widget>? trailing;

  const AppSearchField({
    super.key,
    required this.query,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
    this.borderRadius,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = TextEditingController.fromValue(
        TextEditingValue(
          text: query.value,
          selection: TextSelection.collapsed(offset: query.value.length),
        ),
      );

      return SearchBar(
        controller: controller,
        onChanged: (val) {
          query.value = val;
          onChanged?.call(val);
        },
        hintText: hintText,
        leading:
            leading ??
            Icon(
              AppIcons.common.search,
              color: context.theme.colorScheme.primary,
            ),
        trailing: [
          if (query.isNotEmpty)
            IconButton(
              icon: Icon(AppIcons.common.close, size: 20),
              splashColor: context.theme.colorScheme.surface.withValues(
                alpha: 0,
              ),
              highlightColor: context.theme.colorScheme.surface.withValues(
                alpha: 0,
              ),
              onPressed: () {
                query.value = '';
                onClear?.call();
                FocusScope.of(context).unfocus();
              },
            ),
          ...?trailing,
        ],
        elevation: WidgetStateProperty.all(0),
        shape: borderRadius != null
            ? WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: borderRadius!),
              )
            : null,
      );
    });
  }
}

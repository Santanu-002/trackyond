import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppMenu<T> extends StatelessWidget {
  final Widget Function(BuildContext context, MenuController controller, Widget? child) builder;
  final List<T> items;
  final T Function() selectedValueGetter;
  final String Function(T item) labelBuilder;
  final void Function(T item) onSelected;
  final Offset? alignmentOffset;

  const AppMenu({
    super.key,
    required this.builder,
    required this.items,
    required this.selectedValueGetter,
    required this.labelBuilder,
    required this.onSelected,
    this.alignmentOffset,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: alignmentOffset ?? Offset.zero,
      style: MenuStyle(
        alignment: Alignment.bottomRight,
        
      ),
      builder: builder,
      menuChildren: items.map((T value) {
        return Obx(() {
          final isSelected = selectedValueGetter() == value;
          return MenuItemButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onSelected(value);
            },
            style: MenuItemButton.styleFrom(
              backgroundColor: isSelected
                  ? context.theme.colorScheme.primaryContainer
                  : null,
              padding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: AppUIConstants.spacing.space$20,
              ),
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              labelBuilder(value),
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? context.theme.colorScheme.onPrimaryContainer
                    : null,
              ),
            ),
          );
        });
      }).toList(),
    );
  }
}

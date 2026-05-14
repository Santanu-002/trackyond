import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:trackyond/core/common/entities/filter/app_chip_entity.dart';
import 'package:trackyond/core/common/widgets/chip/app_filter_chip.dart';

class AppFilterChipRow extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final double height;
  final ItemScrollController? itemScrollController;
  final ItemPositionsListener? itemPositionsListener;

  const AppFilterChipRow({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.spacing = 8.0,
    this.height = 40.0,
    this.itemScrollController,
    this.itemPositionsListener,
  });

  /// Factory for passing a list of widgets directly.
  factory AppFilterChipRow.children({
    required List<Widget> children,
    EdgeInsetsGeometry? padding,
    double? spacing,
    double height = 40.0,
    ItemScrollController? itemScrollController,
    ItemPositionsListener? itemPositionsListener,
  }) {
    return AppFilterChipRow(
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
      padding: padding,
      spacing: spacing ?? 8.0,
      height: height,
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
    );
  }

  /// Type-safe factory using AppChipEntity
  factory AppFilterChipRow.fromEntityList({
    required List<AppChipEntity> items,
    required bool Function(int) isSelected,
    void Function(int)? onTap,
    EdgeInsetsGeometry? padding,
    double spacing = 8.0,
    double height = 40.0,
    ItemScrollController? itemScrollController,
    ItemPositionsListener? itemPositionsListener,
    Color? activeColor,
    Color? inactiveColor,
    Color? borderColor,
    double? radius,
  }) {
    return AppFilterChipRow(
      itemCount: items.length,
      padding: padding,
      spacing: spacing,
      height: height,
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      itemBuilder: (context, index) => AppFilterChip(
        label: items[index].label,
        isSelected: isSelected(index),
        onTap: () {
          items[index].onTap?.call();
          onTap?.call(index);
        },
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        borderColor: borderColor,
        radius: radius,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ScrollablePositionedList.separated(
        scrollDirection: Axis.horizontal,
        padding: padding as EdgeInsets?,
        physics: const BouncingScrollPhysics(),
        itemCount: itemCount,
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        itemBuilder: itemBuilder,
        separatorBuilder: (context, index) => SizedBox(width: spacing),
      ),
    );
  }
}

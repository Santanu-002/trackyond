import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/menu/app_menu.dart';
import 'package:trackyond/core/common/widgets/search/app_search_field.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

/// A premium search bar that integrates [AppSearchField] with optional "Search By" filtering.
/// This component provides a unified look and feel for search functionality across the app.
class AppSearchBar<T> extends StatelessWidget {
  final RxString query;
  final String hintText;

  /// Items for the "Search By" dropdown menu.
  final List<T>? searchByItems;

  /// Getter for the currently selected search criteria.
  final T Function()? selectedSearchByGetter;

  /// Builder for labels in the "Search By" menu.
  final String Function(T item)? searchByLabelBuilder;

  /// Callback when a new search criteria is selected.
  final void Function(T item)? onSearchBySelected;

  /// Optional extra widgets to show after the search field.
  final List<Widget>? extraTrailing;

  /// Optional border radius for the search bar. Defaults to a fully rounded pill shape.
  final BorderRadius? borderRadius;

  const AppSearchBar({
    super.key,
    required this.query,
    required this.hintText,
    this.searchByItems,
    this.selectedSearchByGetter,
    this.searchByLabelBuilder,
    this.onSearchBySelected,
    this.extraTrailing,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AppSearchField(
      query: query,
      hintText: hintText,
      borderRadius:
          borderRadius ??
          BorderRadius.circular(AppUIConstants.radius.radius$48),
      trailing: [
        if (_hasSearchBy) ...[
          Container(
            height: 24,
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: context.theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          AppMenu<T>(
            alignmentOffset: const Offset(-116, 8),
            items: searchByItems!,
            selectedValueGetter: selectedSearchByGetter!,
            labelBuilder: searchByLabelBuilder!,
            onSelected: onSearchBySelected!,
            builder: (context, menuController, child) {
              return AppButton.ghost(
                onPressed: () => menuController.isOpen
                    ? menuController.close()
                    : menuController.open(),
                width: null,
                height: null,
                enableHaptic: false,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => Text(
                        searchByLabelBuilder!(selectedSearchByGetter!()),
                        style: context.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    AppUIConstants.widgets.horizontalBox$4,
                    Icon(
                      AppIcons.common.chevronDown,
                      size: 18,
                      color: context.theme.colorScheme.primary,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        ...?extraTrailing,
      ],
    );
  }

  bool get _hasSearchBy =>
      searchByItems != null &&
      selectedSearchByGetter != null &&
      searchByLabelBuilder != null &&
      onSearchBySelected != null;
}

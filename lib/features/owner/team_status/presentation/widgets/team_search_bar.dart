import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/search/app_search_bar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_status_controller.dart';

class TeamSearchBar extends GetView<TeamStatusController> {
  const TeamSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSearchBar<String>(
      query: controller.searchQuery,
      hintText: AppStrings.teamStatus.searchHint,
      searchByItems: const ['All', 'Name', 'Designation', 'Phone'],
      selectedSearchByGetter: () => controller.searchBy.value,
      searchByLabelBuilder: (value) => controller.getSearchByLabel(value),
      onSearchBySelected: (value) => controller.searchBy.value = value,
    );
  }

}

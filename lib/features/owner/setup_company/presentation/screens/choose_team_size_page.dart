import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/features/owner/setup_company/presentation/controllers/setup_company_controller.dart';
import 'package:trackyond/features/owner/setup_company/presentation/widgets/info_banner.dart';
import 'package:trackyond/features/owner/setup_company/presentation/widgets/setup_page_layout.dart';
import 'package:trackyond/features/owner/setup_company/presentation/widgets/team_size_tile.dart';

class ChooseTeamSizePage extends GetView<SetupCompanyController> {
  const ChooseTeamSizePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SetupPageLayout(
        scaffoldTitle: AppStrings.chooseTeamSize.appBarTitle,
        headerIcon: AppIcons.common.team,
        headerTitle: AppStrings.chooseTeamSize.title,
        headerSubtitle: AppStrings.chooseTeamSize.subtitle,
        isLoading: controller.isLoading.value,
        buttonText: AppStrings.chooseTeamSize.finishButton,
        onButtonPressed: controller.finalizeSetup,
        child: Column(
          children: [
            // Info Banner
            const InfoBanner(),

            AppUIConstants.widgets.verticalBox$24,

            // Options List with RadioGroup management
            RadioGroup<int>(
              groupValue: controller.selectedTeamSize.value,
              onChanged: (val) {
                if (val != null) {
                  HapticFeedback.selectionClick();
                  controller.selectTeamSize(val);
                }
              },
              child: Column(
                children: controller.teamSizeOptions.map((option) {
                  final isSelected = option.value == 0
                      ? !([
                          5,
                          10,
                          20,
                        ].contains(controller.selectedTeamSize.value))
                      : option.value == controller.selectedTeamSize.value;

                  return TeamSizeTile(
                    title: option.title,
                    subtitle: option.value == 0 && isSelected
                        ? '${controller.selectedTeamSize.value} members'
                        : option.subtitle,
                    icon: option.icon,
                    value: isSelected ? controller.selectedTeamSize.value : option.value,
                    isSelected: isSelected,
                    onChanged: (val) {
                      if (option.value == 0) {
                        controller.selectTeamSize(0);
                      } else if (val != null) {
                        controller.selectTeamSize(val);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

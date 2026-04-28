import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/text/terms_and_privacy_text.dart';
import 'package:trackyond/core/common/widgets/text_field/app_text_field.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/setup_company/presentation/controllers/setup_company_controller.dart';
import 'package:trackyond/features/owner/setup_company/presentation/widgets/setup_page_layout.dart';

class SetupCompanyPage extends GetView<SetupCompanyController> {
  const SetupCompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SetupPageLayout(
        scaffoldTitle: AppStrings.setupCompany.appBarTitle,
        headerIcon: AppIcons.common.business,
        headerTitle: AppStrings.setupCompany.title,
        headerSubtitle: AppStrings.setupCompany.subtitle,
        buttonText: AppStrings.setupCompany.continueButton,
        isLoading: controller.isLoading.value,
        onButtonPressed:
            controller.isFormValid.value && !controller.isLoading.value
            ? controller.submitStepOne
            : null,
        footer: const TermsAndPrivacyText(onTermsTap: null, onPrivacyTap: null),
        child: AutofillGroup(
          child: Column(
            spacing: AppUIConstants.spacing.space$16,
            children: [
              AppTextField(
                controller: controller.companyNameController,
                label: AppStrings.setupCompany.companyNameLabel,
                hintText: AppStrings.setupCompany.companyNameHint,
                prefixIcon: AppIcons.setup.apartment,
                textCapitalization: TextCapitalization.words,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s\.]')),
                ],
                autofillHints: const [AutofillHints.organizationName],
              ),
              AppTextField(
                controller: controller.userNameController,
                label: AppStrings.setupCompany.yourNameLabel,
                hintText: AppStrings.setupCompany.yourNameHint,
                textInputAction: TextInputAction.done,
                prefixIcon: AppIcons.auth.user,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s\.]')),
                  LengthLimitingTextInputFormatter(20),
                ],
                autofillHints: const [AutofillHints.name],
              ),
              AppTextField(
                controller: controller.phoneController,
                label: AppStrings.setupCompany.phoneNumberLabel,
                hintText: '',
                readOnly: true,
                prefixIcon: AppIcons.auth.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

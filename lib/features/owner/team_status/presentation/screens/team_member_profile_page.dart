import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_member_profile_page_controller.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/profile/member_profile_actions.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/profile/member_profile_header.dart';
import 'package:trackyond/features/owner/team_status/presentation/widgets/profile/member_profile_settings.dart';

class TeamMemberProfilePage extends GetView<TeamMemberProfilePageController> {
  const TeamMemberProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final memberStatus = controller.memberStatus.value;
        if (memberStatus == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            MemberProfileHeader(memberStatus: memberStatus),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MemberProfileActions(),
                  const Divider(height: 1),
                  const MemberProfileSettings(),
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                  AppUIConstants.widgets.verticalBox$32,
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/skeleton/job_card_skeleton.dart';

class JobsListSkeleton extends StatelessWidget {
  const JobsListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: List.generate(6, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < 5 ? AppUIConstants.spacing.space$12 : 0,
            ),
            child: const JobCardSkeleton(),
          );
        }),
      ),
    );
  }
}

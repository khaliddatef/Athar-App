import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';

class TasksHeader extends StatelessWidget {
  const TasksHeader({super.key, required this.tasksCount});

  final int tasksCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('مهام اليوم', style: TextStyles.cairoBold18Black2(context)),
        Container(
          height: 30.h(context),
          padding: EdgeInsets.symmetric(horizontal: 10.w(context)),
          decoration: BoxDecoration(
            color: AppColors.tasksChipBackground,
            borderRadius: BorderRadius.circular(24.r(context)),
          ),
          child: Center(
            child: Text(
              '$tasksCount مهمة',
              style: TextStyles.cairoBold12BlackHeighted(context),
            ),
          ),
        ),
      ],
    );
  }
}

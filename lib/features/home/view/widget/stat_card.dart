import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.valueStyle,
  });

  final String title;
  final String value;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 16.h(context),
        left: 16.w(context),
        right: 16.w(context),
        bottom: 8.h(context),
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.50, 0.66),
          end: Alignment(0.50, 1.74),
          colors: [AppColors.white, AppColors.gradientGray],
        ),
        borderRadius: BorderRadius.circular(12.r(context)),
        border: Border.all(color: AppColors.cardBorder, width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.cairoRegular12Gray(context)),
          verticalSpace(context, height: 4),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}

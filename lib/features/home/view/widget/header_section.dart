import 'package:flutter/material.dart';
import 'package:sanad/core/constants/app_images.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24.r(context),
          backgroundImage: const AssetImage(Assets.imageFace),
        ),
        horizontalSpace(context, width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("مرحباً، أحمد", style: TextStyles.cairoBold16Black(context)),
            Row(
              children: [
                Container(
                  width: 8.w(context),
                  height: 8.w(context),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                horizontalSpace(context, width: 6),
                Text(
                  "متصل الآن",
                  style: TextStyles.cairoRegular12Gray(context),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        Container(
          width: 44.w(context),
          height: 44.w(context),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r(context)),
          ),
          child: Center(
            child: Icon(
              Icons.notifications_none,
              color: AppColors.black,
              size: 24.sp(context),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String body;
  final String timeAgo;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.body,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w(context),
          vertical: 12.h(context),
        ),
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.50, 0.24),
            end: Alignment(0.50, 1.00),
            colors: [AppColors.chatChipBorder, AppColors.darkGreen],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r(context)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.right,
                            style: TextStyles.cairoBold16White(context),
                          ),
                          horizontalSpace(context, width: 8),
                          Image.asset(
                            Assets.megaphone,
                            width: 24.w(context),
                            height: 24.w(context),
                          ),
                        ],
                      ),
                      verticalSpace(context, height: 3),
                      Text(
                        body,
                        textAlign: TextAlign.right,
                        style: TextStyles.cairoRegular13White(context),
                      ),
                    ],
                  ),
                  verticalSpace(context, height: 10),
                  Text(timeAgo, style: TextStyles.cairoRegular10White(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

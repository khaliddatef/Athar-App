import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class UserMessageBubble extends StatelessWidget {
  final String message;
  final String time;

  const UserMessageBubble({
    super.key,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 12.h(context),
                left: 16.w(context),
                right: 16.w(context),
                bottom: 16.h(context),
              ),
              decoration: ShapeDecoration(
                color: AppColors.chatChipBorder,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r(context)),
                    bottomLeft: Radius.circular(16.r(context)),
                    bottomRight: Radius.circular(16.r(context)),
                  ),
                ),
                shadows: const [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 10.5,
                    offset: Offset(-2, 3),
                  ),
                ],
              ),
              child: Text(
                message,
                textAlign: TextAlign.right,
                style: TextStyles.cairoMedium12White(context),
              ),
            ),
            verticalSpace(context, height: 4),
            Text(time, style: TextStyles.cairoRegular10Gray(context)),
          ],
        ),
      ),
    );
  }
}

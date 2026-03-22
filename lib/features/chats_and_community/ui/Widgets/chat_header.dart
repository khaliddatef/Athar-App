import 'package:flutter/material.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class ChatHeader extends StatelessWidget {
  final String title;
  const ChatHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        spacing: context.responsiveWidth(93),
        children: [
          Container(
            margin: EdgeInsets.only(left: 16.w(context)),
            width: 44.w(context),
            height: 44.w(context),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r(context)),
            ),
            child: Center(
              child: Image.asset(
                width: 24.w(context),
                Assets.imageNotifications,
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              title,
              key: ValueKey(title),
              style: TextStyles.cairoBold20DarkBlue(context),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../../core/constants/app_images.dart';
import '../../../../../core/helper/responsive_extensions.dart';
import '../../../../../core/theme/app_colors.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () async {},
          child: Container(
            width: context.responsiveWidth(60),
            height: context.responsiveHeight(44),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(Assets.logoGoogle),
          ),
        ),
      ],
    );
  }
}

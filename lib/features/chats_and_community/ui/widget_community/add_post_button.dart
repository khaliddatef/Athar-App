import 'package:flutter/material.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class AddPostButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddPostButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.h(context),
      left: 16.w(context), 
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: 56.w(context),
          height: 56.w(context),
          decoration: ShapeDecoration(
            color: AppColors.chatChipBorder,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            shadows: const [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 6,
                offset: Offset(0, 4),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 15,
                offset: Offset(0, 10),
                spreadRadius: -3,
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              Assets.add,
              width: 28.w(context),
              height: 28.w(context),
            ),
          ),
        ),
      ),
    );
  }
}
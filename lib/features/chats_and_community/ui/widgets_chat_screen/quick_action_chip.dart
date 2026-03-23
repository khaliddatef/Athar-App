import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class QuickActionChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const QuickActionChip({
    super.key,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: 12.w(context),
          vertical: 8.h(context),
        ),
        decoration: ShapeDecoration(
          color: isActive ? AppColors.chatChipBorder : AppColors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.chatChipBorder),
            borderRadius: BorderRadius.circular(28.r(context)),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: isActive
              ? TextStyles.cairoSemiBold12White(context)
              : TextStyles.cairoSemiBold12Primary(context),
        ),
      ),
    );
  }
}

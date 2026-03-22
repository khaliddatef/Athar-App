import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/text_styles.dart';

class ChatTabButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final bool isActive;
  final VoidCallback onTap;

  const ChatTabButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 56.h(context),
          decoration: ShapeDecoration(
            color: isActive ? const Color(0xFF1A7A4A) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r(context)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: isActive
                    ? TextStyles.cairoBold14White(context)
                    : TextStyles.cairoBold14Gray(context),
              ),
              horizontalSpace(context, width: 8),
              SvgPicture.asset(
                iconPath,
                width: 24.w(context),
                height: 24.w(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/widgets.dart';
import '../../../../../core/helper/responsive_extensions.dart';
import '../../../../../core/theme/app_colors.dart';

class DotsIndicator extends StatelessWidget {
  final int count;
  final int current;

  const DotsIndicator({super.key, required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final bool isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 4.w(context)),
          width: isActive ? 24.w(context) : 8.w(context),
          height: 8.h(context),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryColor
                : AppColors.primaryColor.withOpacity(0.35),
            borderRadius: BorderRadius.circular(4.r(context)),
          ),
        );
      }),
    );
  }
}

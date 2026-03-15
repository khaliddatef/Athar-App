import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';

import '../helper/responsive_extensions.dart';

class TextStyles {
  static TextStyle cairoBold32Black(BuildContext context) => TextStyle(
    color: AppColors.black,
    fontSize: 32.sp(context),
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w700,
  );

  static TextStyle cairoBold32Dark(BuildContext context) => TextStyle(
    color: AppColors.dark,
    fontSize: 32.sp(context),
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w700,
    height: 1.14,
  );

  static TextStyle cairoRegular14Muted(BuildContext context) => TextStyle(
    color: AppColors.gray,
    fontSize: 14.sp(context),
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w400,
    height: 1.82,
  );

  static TextStyle cairoExtraBold18White(BuildContext context) => TextStyle(
    color: AppColors.white,
    fontSize: 18.sp(context),
    fontFamily: 'Cairo',
    fontWeight: FontWeight.w800,
    height: 1.56,
  );
}
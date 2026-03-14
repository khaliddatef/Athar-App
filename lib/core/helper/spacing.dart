import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';

SizedBox verticalSpace(BuildContext context, {required double height}) =>
    SizedBox(height: height.h(context));

SizedBox horizontalSpace(BuildContext context, {required double width}) =>
    SizedBox(width: width.w(context));

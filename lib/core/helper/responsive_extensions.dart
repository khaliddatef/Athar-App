import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  // Get screen dimensions
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Check device type
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  // Responsive padding based on screen width
  double responsiveWidth(
    double mobileValue, {
    double? tabletValue,
    double? desktopValue,
  }) {
    if (isDesktop && desktopValue != null) {
      return desktopValue;
    } else if (isTablet && tabletValue != null) {
      return tabletValue;
    }
    // Scale based on screen width (375 is base design width)
    return (mobileValue / 375) * screenWidth;
  }

  // Responsive height based on screen height
  double responsiveHeight(
    double mobileValue, {
    double? tabletValue,
    double? desktopValue,
  }) {
    if (isDesktop && desktopValue != null) {
      return desktopValue;
    } else if (isTablet && tabletValue != null) {
      return tabletValue;
    }
    // Scale based on screen height (812 is base design height)
    return (mobileValue / 812) * screenHeight;
  }

  // Responsive font size - will remain as is for ScreenUtil
  double responsiveFontSize(double fontSize) {
    return fontSize;
  }

  // Responsive radius
  double responsiveRadius(double radius) {
    return (radius / 375) * screenWidth;
  }

  // Get padding values
  EdgeInsets responsivePadding({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return EdgeInsets.only(
      top: top != null
          ? responsiveHeight(top)
          : (vertical != null
                ? responsiveHeight(vertical)
                : (all != null ? responsiveHeight(all) : 0)),
      bottom: bottom != null
          ? responsiveHeight(bottom)
          : (vertical != null
                ? responsiveHeight(vertical)
                : (all != null ? responsiveHeight(all) : 0)),
      left: left != null
          ? responsiveWidth(left)
          : (horizontal != null
                ? responsiveWidth(horizontal)
                : (all != null ? responsiveWidth(all) : 0)),
      right: right != null
          ? responsiveWidth(right)
          : (horizontal != null
                ? responsiveWidth(horizontal)
                : (all != null ? responsiveWidth(all) : 0)),
    );
  }
}

// Extension for numbers to convert to responsive values
extension NumResponsive on num {
  double w(BuildContext context) => context.responsiveWidth(toDouble());
  double h(BuildContext context) => context.responsiveHeight(toDouble());
  double r(BuildContext context) => context.responsiveRadius(toDouble());
}

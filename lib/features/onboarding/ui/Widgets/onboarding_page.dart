import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/text_styles.dart';
import '../../models/onboarding_model.dart';

class OnBoardingPage extends StatelessWidget {
  final OnBoardingModel data;

  const OnBoardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWideLayout = constraints.maxWidth >= 900;
          final double imageSize = isWideLayout
              ? (constraints.maxHeight * 0.42).clamp(220.0, 320.0)
              : (constraints.maxWidth * 0.72).clamp(180.0, 280.0);

          final titleStyle = switch (data.titleStyleType) {
            TitleStyleType.boldBlack => TextStyles.cairoBold32Black(context),
            TitleStyleType.boldDark => TextStyles.cairoBold32Dark(context),
          }.copyWith(
            fontSize: context.responsiveFontSize(
              32,
              tabletFontSize: 30,
              desktopFontSize: 36,
            ),
          );

          final descriptionStyle = TextStyles.cairoRegular14Muted(context).copyWith(
            fontSize: context.responsiveFontSize(
              14,
              tabletFontSize: 15,
              desktopFontSize: 16,
            ),
          );

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWideLayout ? 48 : 24.w(context),
                  vertical: 12.h(context),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    verticalSpace(context, height: 12),
                    SvgPicture.asset(
                      data.image,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.contain,
                    ),
                    verticalSpace(context, height: isWideLayout ? 16 : 24),
                    Text(
                      data.title,
                      textAlign: data.titleAlign,
                      style: titleStyle,
                    ),
                    verticalSpace(context, height: 12),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWideLayout ? 520 : 291.w(context),
                      ),
                      child: Text(
                        data.description,
                        textAlign: TextAlign.center,
                        style: descriptionStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

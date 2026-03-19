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
    final titleStyle = switch (data.titleStyleType) {
      TitleStyleType.boldBlack => TextStyles.cairoBold32Black(context),
      TitleStyleType.boldDark => TextStyles.cairoBold32Dark(context),
    };

    return Padding(
      padding: context.responsivePadding(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          verticalSpace(context, height: 24),
          SvgPicture.asset(
            data.image,
            width: 280.w(context),
            height: 280.w(context),
            fit: BoxFit.contain,
          ),
          verticalSpace(context, height: 40),
          Text(data.title, textAlign: data.titleAlign, style: titleStyle),
          verticalSpace(context, height: 16),
          SizedBox(
            width: 291.w(context),
            child: Text(
              data.description,
              textAlign: TextAlign.center,
              style: TextStyles.cairoRegular14Muted(context),
            ),
          ),
        ],
      ),
    );
  }
}

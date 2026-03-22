import 'package:flutter/material.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/theme/text_styles.dart';

class BotMessageBubble extends StatelessWidget {
  final String message;
  final String time;

  const BotMessageBubble({
    super.key,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            spacing: context.responsiveWidth(2),
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w(context),
                    vertical: 12.h(context),
                  ),
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 10.5,
                        offset: Offset(-2, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    message,
                    textAlign: TextAlign.right,
                    style: TextStyles.cairoMedium12DarkBlue(context),
                  ),
                ),
              ),

              Image.asset(
                Assets.imageChatBot,
                width: 50.w(context),
                height: 50.h(context),
              ),
            ],
          ),

          // verticalSpace(context, height: 4),
          Directionality(
            textDirection: TextDirection.ltr,

            child: Padding(
              padding: context.responsivePadding(horizontal: 60, vertical: 20),
              child: Text(time, style: TextStyles.cairoRegular10Gray(context)),
            ),
          ),
        ],
      ),
    );
  }
}

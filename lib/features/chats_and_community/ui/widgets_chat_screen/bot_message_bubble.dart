import 'package:flutter/material.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/chat_message.dart';

class BotMessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isLoading;
  final List<ChatMessageSpan>? spans;

  const BotMessageBubble({
    super.key,
    required this.message,
    required this.time,
    this.isLoading = false,
    this.spans,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w(context),
                  height: 40.w(context),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset(Assets.imageChatBot),
                ),
                horizontalSpace(context, width: 4),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 12.h(context),
                      left: 16.w(context),
                      right: 16.w(context),
                      bottom: 16.h(context),
                    ),
                    decoration: ShapeDecoration(
                      color: AppColors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 10.5,
                          offset: Offset(-2, 3),
                        ),
                      ],
                    ),
                    child: isLoading
                        ? Text(
                            message,
                            textAlign: TextAlign.right,
                            style: TextStyles.cairoMedium12DarkBlue(context),
                          )
                        : spans != null
                        ? Text.rich(
                            TextSpan(
                              children: spans!.map((span) {
                                return TextSpan(
                                  text: span.text,
                                  style: span.isHighlighted
                                      ? TextStyles.cairoMedium12Primary(context)
                                      : TextStyles.cairoMedium12DarkBlue(
                                          context,
                                        ),
                                );
                              }).toList(),
                            ),
                            textAlign: TextAlign.right,
                          )
                        : Text(
                            message,
                            textAlign: TextAlign.right,
                            style: TextStyles.cairoMedium12DarkBlue(context),
                          ),
                  ),
                ),
              ],
            ),
            verticalSpace(context, height: 4),
            Padding(
              padding: EdgeInsets.only(left: 48.w(context)),
              child: Text(time, style: TextStyles.cairoRegular10Gray(context)),
            ),
          ],
        ),
      ),
    );
  }
}

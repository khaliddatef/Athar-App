import 'package:flutter/material.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class ChatInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;

  const ChatInputBar({super.key, required this.onSend});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w(context),
        vertical: 12.h(context),
      ),
      child: Row(
        children: [
          _ActionButton(imagePath: Assets.imageSend, onTap: _send),
          horizontalSpace(context, width: 8),
          Expanded(
            child: SizedBox(
              height: 44.h(context),
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.right,
                style: TextStyles.cairoMedium14Black(context),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك...',
                  hintStyle: TextStyles.cairoRegular14Muted(context),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w(context),
                    vertical: 10.h(context),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r(context)),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          horizontalSpace(context, width: 8),
          _ActionButton(imagePath: Assets.imageMicrophone, onTap: () {}),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const _ActionButton({required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 44.w(context),
        height: 44.w(context),
        decoration: ShapeDecoration(
          color: AppColors.primaryColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          shadows: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 4,
              offset: Offset(0, 2),
              spreadRadius: -2,
            ),
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: -1,
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            width: 20.w(context),
            height: 20.h(context),
          ),
        ),
      ),
    );
  }
}

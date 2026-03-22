import 'package:flutter/material.dart';
import 'package:sanad/features/chats_and_community/ui/widgets_chat_screen/bot_message_bubble.dart';

import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/helper/spacing.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 16.h(context)),
      children: [
        BotMessageBubble(
          message: 'اهلا يا أحمد! 👋 أنا سند، أقدر أساعدك ازاي انهارده؟',
          time: '10:21 AM',
        ),
        verticalSpace(context, height: 12),
      ],
    );
  }
}

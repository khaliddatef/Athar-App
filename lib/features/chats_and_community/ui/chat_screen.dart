import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/features/chats_and_community/ui/widgets_chat_screen/bot_message_bubble.dart';
import 'package:sanad/features/chats_and_community/ui/widgets_chat_screen/quick_action_chip.dart';
import 'package:sanad/features/chats_and_community/ui/widgets_chat_screen/user_message_bubble.dart';
import '../../../core/helper/responsive_extensions.dart';
import '../../../core/helper/spacing.dart';
import '../logic/chat_screen_cubit.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static const List<String> quickActions = ['مهامي اليومية 📋', 'أقرب حملة 📍'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatScreenCubit, ChatScreenState>(
      builder: (context, state) {
        final cubit = context.read<ChatScreenCubit>();

        return ListView(
          padding: EdgeInsets.symmetric(vertical: 16.h(context)),
          children: [
            BotMessageBubble(
              message: state.messages.first.text,
              time: state.messages.first.time,
            ),
            verticalSpace(context, height: 12),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: quickActions.map((label) {
                  final isActive = state.selectedChip == label;
                  return Padding(
                    padding: EdgeInsets.only(right: 12.w(context)),
                    child: QuickActionChip(
                      label: label,
                      isActive: isActive,
                      onTap: () => cubit.sendMessage(label),
                    ),
                  );
                }).toList(),
              ),
            ),
            verticalSpace(context, height: 12),
            ...state.messages
                .skip(1)
                .map(
                  (msg) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h(context)),
                    child: msg.isUser
                        ? UserMessageBubble(message: msg.text, time: msg.time)
                        : BotMessageBubble(
                            message: msg.text,
                            time: msg.time,
                            isLoading: msg.isLoading,
                            spans: msg.spans,
                          ),
                  ),
                ),
          ],
        );
      },
    );
  }
}

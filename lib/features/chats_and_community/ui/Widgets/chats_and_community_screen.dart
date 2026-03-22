import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/features/chats_and_community/logic/chat_cubit.dart';
import 'package:sanad/features/chats_and_community/ui/Widgets/chat_header.dart';
import 'package:sanad/features/chats_and_community/ui/Widgets/chat_tab_button.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/helper/spacing.dart';
import '../chat_screen.dart';
import '../community_screen.dart';

class ChatsAndCommunityScreen extends StatelessWidget {
  const ChatsAndCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(),
      child: const _ChatsAndCommunityView(),
    );
  }
}

class _ChatsAndCommunityView extends StatelessWidget {
  const _ChatsAndCommunityView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatTab>(
      builder: (context, selectedTab) {
        final cubit = context.read<ChatCubit>();
        final isAssistant = selectedTab == ChatTab.assistant;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w(context)),
              child: Column(
                children: [
                  ChatHeader(title: isAssistant ? 'محادثاتي' : 'المجتمع'),
                  verticalSpace(context, height: 12),
                  Row(
                    children: [
                      ChatTabButton(
                        label: 'المساعد الذكي',
                        iconPath: Assets.aiChat,
                        isActive: isAssistant,
                        onTap: cubit.selectAssistant,
                      ),
                      horizontalSpace(context, width: 12),
                      ChatTabButton(
                        label: 'مجتمع المتطوعين',
                        iconPath: Assets.community,
                        isActive: !isAssistant,
                        onTap: cubit.selectCommunity,
                      ),
                    ],
                  ),
                  verticalSpace(context, height: 16),
                  Expanded(
                    child: isAssistant
                        ? const ChatScreen()
                        : const CommunityScreen(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

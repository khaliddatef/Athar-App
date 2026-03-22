import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../data/chat_message.dart';

class ChatScreenState {
  final List<ChatMessage> messages;
  final String? selectedChip;

  const ChatScreenState({required this.messages, this.selectedChip});

  ChatScreenState copyWith({
    List<ChatMessage>? messages,
    String? selectedChip,
  }) {
    return ChatScreenState(
      messages: messages ?? this.messages,
      selectedChip: selectedChip ?? this.selectedChip,
    );
  }
}

class ChatScreenCubit extends Cubit<ChatScreenState> {
  ChatScreenCubit()
    : super(
        const ChatScreenState(
          messages: [
            ChatMessage(
              text: 'اهلا يا أحمد! 👋 أنا سند، أقدر أساعدك ازاي انهارده؟',
              isUser: false,
              time: '10:21 AM',
            ),
          ],
        ),
      );

  String get _now => DateFormat('hh:mm a').format(DateTime.now());

  void sendMessage(String text) {
    final userMsg = ChatMessage(text: text, isUser: true, time: _now);
    final loadingMsg = ChatMessage(
      text: 'جاري معالجة طلبك...',
      isUser: false,
      time: _now,
      isLoading: true,
    );

    emit(
      state.copyWith(
        messages: [...state.messages, userMsg, loadingMsg],
        selectedChip: text,
      ),
    );

    _fetchBotReply(text);
  }

  Future<void> _fetchBotReply(String userText) async {
    await Future.delayed(const Duration(seconds: 2));

    final updatedMessages = state.messages.where((m) => !m.isLoading).toList();

    final botReply = userText.contains('مهامي اليومية')
        ? ChatMessage(
            text: '',
            isUser: false,
            time: _now,
            spans: const [
              ChatMessageSpan(
                text: 'عندك 2 مهام متاحة انهارده يا أحمد\n',
                isHighlighted: false,
              ),
              ChatMessageSpan(
                text: 'منطقة أكتوبر — 10:00 AM\nمنطقة المعادي — 2:30 PM',
                isHighlighted: true,
              ),
            ],
          )
        : ChatMessage(
            text: '',
            isUser: false,
            time: _now,
            spans: const [
              ChatMessageSpan(
                text: 'أقرب حملة ليك دلوقتي يا أحمد\n',
                isHighlighted: false,
              ),
              ChatMessageSpan(
                text: 'حملة التوعية بالجيزة — 10:00 AM',
                isHighlighted: true,
              ),
            ],
          );

    emit(state.copyWith(messages: [...updatedMessages, botReply]));
  }
}

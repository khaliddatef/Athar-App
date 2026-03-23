class ChatMessage {
  final String text;
  final bool isUser;
  final String time;
  final bool isLoading;
  final List<ChatMessageSpan>? spans;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.isLoading = false,
    this.spans,
  });
}

class ChatMessageSpan {
  final String text;
  final bool isHighlighted;

  const ChatMessageSpan({required this.text, this.isHighlighted = false});
}

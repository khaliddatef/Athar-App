import 'package:flutter_bloc/flutter_bloc.dart';

enum ChatTab { assistant, community }

class ChatCubit extends Cubit<ChatTab> {
  ChatCubit() : super(ChatTab.assistant);

  void selectAssistant() => emit(ChatTab.assistant);
  void selectCommunity() => emit(ChatTab.community);
}

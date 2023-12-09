import 'package:chat_ai/controllers/user_controller.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  final ChatUser _currentUser = ChatUser(
      id: UserController.user!.uid,
      firstName: UserController.user!.displayName!.split(' ').first,
      lastName: UserController.user!.displayName!.split(' ').last);

  final ChatUser chatAI = ChatUser(id: '2', firstName: 'Chat', lastName: 'AI');

  List<ChatMessage> _messages = <ChatMessage>[];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('ChatAI'),
      ),
      body: DashChat(
          currentUser: _currentUser,
          onSend: (ChatMessage text) {
            getChatAIresponse(text);
          },
          messages: _messages),
    );
  }

  Future<void> getChatAIresponse(ChatMessage text) async {}
}

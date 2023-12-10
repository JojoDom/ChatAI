import 'package:chat_ai/controllers/api_controller.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key, required this.isNewChat,  this.conversationID});
  final bool isNewChat;
  final String? conversationID;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ApiController apiController = Get.put(ApiController());

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          'ChatAI',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white),
        ),
      ),
      body: DashChat(
          currentUser: apiController.currentUser,
          messageOptions: MessageOptions(
              showCurrentUserAvatar: true,
              containerColor: Colors.blueGrey,
              currentUserContainerColor: Theme.of(context).primaryColor),
          onSend: (ChatMessage m) {
            if (widget.isNewChat) {
              apiController.newConversation(
                  createdAt: '${DateTime.now()}', title: m.text);
            } else {
               apiController.sendMessage(
                createdAt: '${DateTime.now()}',
                title: m.text,
                userID: UserID.userID.toString(),
                conversationID: widget.conversationID??'');
            }          
          },
          messages: apiController.messages),
    );
  }

  
}

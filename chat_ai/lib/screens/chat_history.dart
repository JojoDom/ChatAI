import 'package:chat_ai/screens/chat_screen.dart';
import 'package:chat_ai/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
    body: CustomButton(onTap: ()=> Get.to(ChatScreen(isNewChat: true,)), image: SizedBox(), text: 'Go', isBusy: false),
    );
  }
}

import 'package:chat_ai/controllers/api_controller.dart';
import 'package:chat_ai/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  late ApiController apiController;
  @override
  void initState() {
    apiController = Get.put(ApiController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Obx(
        () => Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/welcome_bg.jpg'))),
            child: apiController.isFetchingConversations.isTrue
                ? const CircularProgressIndicator()
                : apiController.isFetchingConversations.isFalse &&
                        apiController.conversations.isEmpty
                    ? const Text('No chats')
                    : ListView.separated(
                        itemBuilder: (((context, index) =>
                            Text(apiController.conversations[index].title))),
                        separatorBuilder: ((context, index) => const SizedBox(
                              height: 5,
                            )),
                        itemCount: apiController.conversations.length)),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'new',
        backgroundColor: Colors.deepOrange,
        shape: const CircleBorder(),
        onPressed: () {
          Get.to(() => const ChatScreen(
                isNewChat: true,
              ));
        },
        child: const Icon(Icons.message, color: Colors.white),
      ),
    );
  }
}

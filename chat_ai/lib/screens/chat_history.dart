import 'package:chat_ai/controllers/api_controller.dart';
import 'package:chat_ai/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    apiController.getUserConversations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 245, 245),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'ChatAI',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton.outlined(
                onPressed: () {},
                color: Colors.white,
                icon: Text(
                  'Sign Out',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                )),
          )
        ],
      ),
      body: Obx(
        () => Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: apiController.isFetchingConversations.isTrue
                ? const Center(child: CircularProgressIndicator())
                : apiController.isFetchingConversations.isFalse &&
                        apiController.conversations.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/no_chat.png',
                              color: const Color.fromARGB(255, 218, 200, 172),
                            ),
                          ),
                          Text(
                            'Your chat is empty. To start a new conversaton with ChatAI, tap the chat icon at the bottom right corner',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: const Color(0xFF8F92A1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                          )
                        ],
                      )
                    : ListView.separated(
                        itemBuilder: (((context, index) => InkWell(
                              onTap: (() => Get.to(()=>
                              ChatScreen(isNewChat: false, 
                              conversationID: apiController.conversations[index].id,))),
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                ),
                                child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    title: Text(
                                      timeago.format(
                                        apiController
                                            .conversations[index].createdAt,
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    subtitle: Container(
                                      constraints:
                                          const BoxConstraints(maxHeight: 150),
                                      child: Text(
                                        apiController
                                            .conversations[index].title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    ),
                                    trailing: PopupMenuButton<String>(
                                      onSelected: (String result) {
                                        if (result == 'pin') {
                                          Logger().i('Pin');
                                        }
                                        if (result == 'Delete') {
                                          Logger().i('Delete');
                                        }
                                      },
                                      itemBuilder: ((context) =>
                                          <PopupMenuEntry<String>>[
                                            const PopupMenuItem<String>(
                                              value: 'pin',
                                              child: Text('Favorite'),
                                            ),
                                            const PopupMenuItem<String>(
                                              value: 'Delete',
                                              child: Text('Delete'),
                                            ),
                                          ]),
                                    )),
                              ),
                            ))),
                        separatorBuilder: ((context, index) => Container(
                              color: Colors.white,
                              height: 3,
                            )),
                        itemCount: apiController.conversations.length)),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'new',
        backgroundColor: Colors.deepOrange,
        shape: const CircleBorder(),
        onPressed: () {
          Get.to(
              () => const ChatScreen(
                    isNewChat: true,
                  ),
              transition: Transition.rightToLeft);
        },
        child: const Icon(Icons.message, color: Colors.white),
      ),
    );
  }
}

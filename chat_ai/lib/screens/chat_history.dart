import 'package:chat_ai/controllers/api_controller.dart';
import 'package:chat_ai/controllers/user_controller.dart';
import 'package:chat_ai/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:iconsax/iconsax.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  late ApiController apiController;
  final RefreshController refreshChat =
      RefreshController(initialRefresh: false);
final RefreshController refresh =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    apiController = Get.put(ApiController());
    apiController.getUserConversations();
    super.initState();
  }

  onRefresh() {
    apiController.getUserConversations();
    refreshChat.refreshCompleted();
  }
  onPageRefresh() {
    apiController.getUserConversations();
    refreshChat.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'ChatAI',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  UserController().signOut();
                }
              },
              itemBuilder: ((context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'name',
                      child: Text(
                        UserController.user?.displayName ?? 'Unknwon',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Text(
                            'Log out',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Iconsax.logout),
                          )
                        ],
                      ),
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 70,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(UserController.user?.photoURL ?? ''),
                      radius: 30.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Obx(
          () => Container(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              child: apiController.isFetchingConversations.isTrue
                  ? const Center(child: CircularProgressIndicator())
                  : apiController.isFetchingConversations.isFalse &&
                          apiController.conversations.isEmpty
                      ? SmartRefresher(
                        controller: refresh,
                        onRefresh: onPageRefresh,
                        child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Image.asset(
                                      'assets/images/no_chat.png',
                                      color:const Color.fromARGB(255, 122, 78, 193) ,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                  child: Text(
                                    'Your chat is empty. To start a new conversaton with ChatAI, tap the chat icon at the bottom right corner',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: const Color(0xFF8F92A1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                  ),
                                )
                              ],
                            ),
                        ),
                      )
                      : SmartRefresher(
                          enablePullDown: true,
                          reverse: false,
                          enablePullUp: false,
                          controller: refreshChat,
                          onRefresh: onRefresh,
                          child: ListView(
                            children: [
                              apiController.favoriteConversations.isEmpty
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 20),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Pinned",
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  color:
                                                      const Color(0xFF1A1A1A),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                              apiController.favoriteConversations.isEmpty
                                  ? const SizedBox.shrink()
                                  : Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 205, 192, 227),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: ListView.separated(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (((context, index) =>
                                              InkWell(
                                                onTap: (() =>
                                                    Get.to(() => ChatScreen(
                                                          isNewChat: false,
                                                          conversationID:
                                                              apiController
                                                                  .favoriteConversations[
                                                                      index]
                                                                  .id,
                                                        ))),
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                18)),
                                                  ),
                                                  child: ListTile(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 20),
                                                      title: Text(
                                                        timeago.format(
                                                          apiController
                                                              .favoriteConversations[
                                                                  index]
                                                              .createdAt,locale: 'en_short'
                                                        ),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.grey,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      subtitle: Container(
                                                        constraints:
                                                            const BoxConstraints(
                                                                maxHeight: 150),
                                                        child: Text(
                                                          apiController
                                                              .favoriteConversations[
                                                                  index]
                                                              .title,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 3,
                                                        ),
                                                      ),
                                                      trailing: PopupMenuButton<
                                                          String>(
                                                        onSelected:
                                                            (String result) {
                                                          if (result == 'pin') {
                                                            apiController.favoriteChat(
                                                                apiController
                                                                    .favoriteConversations[
                                                                        index]
                                                                    .id,
                                                                false);
                                                          }
                                                          if (result ==
                                                              'Delete') {
                                                            apiController.deleteChat(
                                                                apiController
                                                                    .favoriteConversations[
                                                                        index]
                                                                    .id);
                                                          }
                                                        },
                                                        itemBuilder:
                                                            ((context) =>
                                                                <PopupMenuEntry<
                                                                    String>>[
                                                                  const PopupMenuItem<
                                                                      String>(
                                                                    value:
                                                                        'pin',
                                                                    child: Text(
                                                                        'Unpin'),
                                                                  ),
                                                                  const PopupMenuItem<
                                                                      String>(
                                                                    value:
                                                                        'Delete',
                                                                    child: Text(
                                                                        'Delete'),
                                                                  ),
                                                                ]),
                                                      )),
                                                ),
                                              ))),
                                          separatorBuilder: ((context, index) =>
                                              Container(
                                                color: Colors.white,
                                                height: 3,
                                              )),
                                          itemCount: apiController
                                              .favoriteConversations.length),
                                    ),
                            apiController.recentConversations.isEmpty?
                            const SizedBox.square():
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Chat History",
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            color: const Color(0xFF1A1A1A),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (((context, index) => InkWell(
                                        onTap: (() => Get.to(() => ChatScreen(
                                              isNewChat: false,
                                              conversationID: apiController
                                                  .recentConversations[index]
                                                  .id,
                                            ))),
                                        child: Container(
                                          
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(0)),
                                          ),
                                          child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              title: Text(
                                                timeago.format(
                                                  apiController
                                                      .recentConversations[
                                                          index]
                                                      .createdAt, locale: 'en_short'
                                                ),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              subtitle: Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxHeight: 150),
                                                child: Text(
                                                  apiController
                                                      .recentConversations[
                                                          index]
                                                      .title,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                ),
                                              ),
                                              trailing: PopupMenuButton<String>(
                                                onSelected: (String result) {
                                                  if (result == 'pin') {
                                                    apiController.favoriteChat(
                                                        apiController
                                                            .recentConversations[
                                                                index]
                                                            .id,
                                                        true);
                                                  }
                                                  if (result == 'Delete') {
                                                    apiController.deleteChat(
                                                        apiController
                                                            .recentConversations[
                                                                index]
                                                            .id);
                                                  }
                                                },
                                                itemBuilder: ((context) =>
                                                    <PopupMenuEntry<String>>[
                                                      const PopupMenuItem<
                                                          String>(
                                                        value: 'pin',
                                                        child: Text('Pin Chat'),
                                                      ),
                                                      const PopupMenuItem<
                                                          String>(
                                                        value: 'Delete',
                                                        child: Text('Delete'),
                                                      ),
                                                    ]),
                                              )),
                                        ),
                                      ))),
                                  separatorBuilder: ((context, index) =>
                                      Container(
                                        color: const Color.fromARGB(
                                              255, 205, 192, 227),
                                        height: 3,
                                      )),
                                  itemCount:
                                      apiController.recentConversations.length),
                            ],
                          ),
                        )),
        ),
        floatingActionButton: DraggableFab(
            securityBottom: MediaQuery.of(context).size.height * 0.1,
            child: RawMaterialButton(
              fillColor: Theme.of(context).primaryColor,
              shape: const CircleBorder(),
              elevation: 5.0,
              onPressed: (() {
                Get.to(() => const ChatScreen(isNewChat: true),
                    transition: Transition.rightToLeft);
              }),
              child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Iconsax.message_add, color: Colors.white)),
            )));
  }
}

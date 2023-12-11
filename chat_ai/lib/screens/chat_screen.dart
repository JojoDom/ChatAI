// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_final_fields

import 'package:chat_ai/controllers/api_controller.dart';
import 'package:chat_ai/utils/chat_ctresponse.dart';
import 'package:chat_ai/utils/message.dart';
import 'package:chat_ai/utils/usage.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart' as gpt;
import 'package:chat_ai/utils/chat_choice.dart' as mychoice;
import 'package:logger/logger.dart';
import '../utils/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.isNewChat, this.conversationID});
  final bool isNewChat;
  final String? conversationID;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ApiController apiController;
  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];
  final ChatUser chatAI = ChatUser(id: '1', firstName: 'Chat', lastName: 'AI');
  List<mychoice.ChatChoice> stubbedres = <mychoice.ChatChoice>[
    mychoice.ChatChoice(
        index: 0,
        message:
            Message(role: 'assistant', content: 'This is a test response')),
  ];

  final _openAI = gpt.OpenAI.instance.build(
      token: API_KEY,
      baseOption: gpt.HttpSetup(
        receiveTimeout: const Duration(seconds: 8),
      ),
      enableLog: true);

  Future<void> getChatAIresponse(ChatMessage text,
      {String? conversationID}) async {
    setState(() {
      _typingUsers.add(chatAI);
    });
    List<gpt.Messages> _messageHistory = _messages.reversed.map(
      (m) {
        if (m.user == apiController.currentUser) {
          return gpt.Messages(role: gpt.Role.user, content: m.text);
        } else {
          return gpt.Messages(role: gpt.Role.assistant, content: m.text);
        }
      },
    ).toList();
    final request = gpt.ChatCompleteText(
      model: gpt.GptTurbo0301ChatModel(),
      messages: _messageHistory,
    );
    final response = ChatCTResponse(
        id: 'id',
        object: 'message',
        created: 1,
        choices: stubbedres,
        usage: Usage(0, 0, 0));
    //  await _openAI.onChatCompletion(request: request);
    for (var text in response!.choices) {
      if (text.message != null) {
        Logger().i(text.message!.content);
        setState(() {
          _messages.insert(
              0,
              ChatMessage(
                  user: chatAI,
                  createdAt: DateTime.now(),
                  text: text.message!.content));
        });
        await apiController.sendMessage(
            createdAt: DateTime.now().toString(),
            title: text.message!.content,
            userID: '1',
            conversationID: widget.isNewChat
                ? apiController.conversationID.value
                : widget.conversationID ?? '');
      }
      setState(() {
        _typingUsers.remove(chatAI);
      });
    }
  }

  @override
  initState() {
    apiController = Get.put(ApiController());
    if (!widget.isNewChat) {
      getChatMessages();
    }
    super.initState();
  }

  getChatMessages() async {
    await apiController.getConversationMessages(
        conversationID: widget.conversationID ?? '');
    setState(() {
      _messages = apiController.messages.reversed.toSet().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (() => Get.back()),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          'ChatAI',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: Obx(
        () => apiController.isFetchingConversationMessages.isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : DashChat(
                currentUser: apiController.currentUser,
                typingUsers: _typingUsers,
                messageOptions: const MessageOptions(
                    containerColor: Color.fromARGB(255, 231, 204, 163),
                    currentUserContainerColor:
                        Color.fromARGB(255, 231, 204, 163)),
                onSend: (ChatMessage m) async {
                  if (_messages.isEmpty) {
                    setState(() {
                      _messages.insert(0, m);
                    });
                    await apiController.newConversation(
                        createdAt: DateTime.now().toString(), title: m.text);
                    getChatAIresponse(m);
                  } else {
                    setState(() {
                      _messages.insert(0, m);
                    });
                    apiController.sendMessage(
                        createdAt: DateTime.now().toString(),
                        title: m.text,
                        userID: apiController.userID.value,
                        conversationID: widget.isNewChat
                            ? apiController.conversationID.value
                            : widget.conversationID ?? '');
                    getChatAIresponse(m);
                  }
                },
                messages: _messages),
      ),
    );
  }
}

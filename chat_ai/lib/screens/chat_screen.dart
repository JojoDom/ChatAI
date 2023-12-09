import 'package:chat_ai/controllers/user_controller.dart';
import 'package:chat_ai/utils/chat_choice.dart' as mychoice;
import 'package:chat_ai/utils/chat_ctresponse.dart';
import 'package:chat_ai/utils/message.dart';
import 'package:chat_ai/utils/usage.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart' as gpt;
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatUser _currentUser = ChatUser(
      id: UserController.user!.uid,
      firstName: UserController.user!.displayName!.split(' ').first,
      lastName: UserController.user!.displayName!.split(' ').last);

  final ChatUser chatAI = ChatUser(id: '2', firstName: 'Chat', lastName: 'AI');
  // final _openAI = gpt.OpenAI.instance.build(
  //     token: API_KEY,
  //     baseOption: gpt.HttpSetup(
  //       receiveTimeout: const Duration(seconds: 8),
  //     ),
  //     enableLog: true);

  // ignore: prefer_final_fields
  List<ChatMessage> _messages = <ChatMessage>[];
  List<mychoice.ChatChoice> stubbedres = <mychoice.ChatChoice>[
    mychoice.ChatChoice(
        index: 0,
        message:
            Message(role: 'assistant', content: 'This is a test response')),
    mychoice.ChatChoice(
        index: 1,
        message: Message(role: 'assistant', content: 'Christian Barnes'))
  ];
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
          currentUser: _currentUser,
          messageOptions: MessageOptions(
              containerColor: Colors.blueGrey,
              currentUserContainerColor: Theme.of(context).primaryColor),
          onSend: (ChatMessage text) {
            getChatAIresponse(text);
          },
          messages: _messages),
    );
  }

  Future<void> getChatAIresponse(ChatMessage text) async {
    setState(() {
      _messages.insert(0, text);
    });
    List<gpt.Messages> _messageHistory = _messages.reversed.map(
      (m) {
        if (m.user == _currentUser) {
          return gpt.Messages(role: gpt.Role.user, content: m.text);
        } else {
          return gpt.Messages(role: gpt.Role.assistant, content: m.text);
        }
      },
    ).toList();
    // final request = ChatCompleteText(
    //     model: GptTurbo0301ChatModel(),
    //     messages: _messageHistory,);
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
          Logger().i(_messages.map((m) => m.toJson()).toList());
        });
      }
    }
  }
}

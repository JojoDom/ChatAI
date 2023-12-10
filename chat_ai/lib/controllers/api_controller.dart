import 'package:chat_ai/controllers/user_controller.dart';
import 'package:chat_ai/models/conversation_messages.dart';
import 'package:chat_ai/models/new_conversation.dart';
import 'package:chat_ai/models/user_conversations.dart';
import 'package:chat_ai/utils/api_strings.dart';
import 'package:chat_ai/utils/chat_choice.dart' as mychoice;
import 'package:chat_ai/utils/chat_ctresponse.dart';
import 'package:chat_ai/utils/constants.dart';
import 'package:chat_ai/utils/message.dart';
import 'package:chat_ai/utils/storage_keys.dart';
import 'package:chat_ai/utils/usage.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart' as gpt;
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart' as dioi;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiController extends GetxController {
  final dio = dioi.Dio();
  var isRegisteringUser = false.obs;
  var isLoggingIn = false.obs;
  var isFetchingConversations = false.obs;
  var isFetchingConversationMessages = false.obs;
  var isCreatingChatMessage = false.obs;
  var isCreatingNewChat = false.obs;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  var conversations = <Conversation>[].obs;
  var conversationsMessages = <ChatMessageLocal>[].obs;
  var messages = <ChatMessage>[].obs;
  var userID = ''.obs;
  late ChatUser currentUser;

  @override
  void onInit() async {
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90));
    await getUserID();
    await getUserConversations();
    super.onInit();
  }

  getUserID() async {
    var id = await secureStorage.read(key: StorageKeys.ST_KEY_USER_ID);
    userID.value = id ?? '';

    currentUser = ChatUser(
        id: userID.value,
        firstName: UserController.user!.displayName!.split(' ').first,
        lastName: UserController.user!.displayName!.split(' ').last);
  }

  final ChatUser chatAI = ChatUser(id: '1', firstName: 'Chat', lastName: 'AI');
  List<mychoice.ChatChoice> stubbedres = <mychoice.ChatChoice>[
    mychoice.ChatChoice(
        index: 0,
        message:
            Message(role: 'assistant', content: 'This is a test response')),
    mychoice.ChatChoice(
        index: 1,
        message: Message(role: 'assistant', content: 'Christian Barnes'))
  ];

  getUserConversations() async {
    isFetchingConversations(true);
    var userID = await secureStorage.read(key: StorageKeys.ST_KEY_USER_ID);
    int id = int.parse(userID ?? '');
    try {
      await dio
          .get('${ApiStrings.BASE_URL}/users/$id/converstions')
          .then((value) {
        isFetchingConversations(false);
        var response = UserConversations.fromJson(value.data);
        conversations.value = response.conversations;
      });
    } on dioi.DioException catch (e) {
      isFetchingConversations(false);
      Get.snackbar('Sorry', 'Failed to load chats.',
          backgroundColor: Colors.white);
      Logger().e(e.message);
      update();
    } catch (e, stackTrace) {
      isFetchingConversations(false);
      Logger().e('Error: $e');
      Logger().i(stackTrace);
      update();
    }
  }

  getConversationMessages({required String conversationID}) async {
    isFetchingConversationMessages(true);
    try {
      await dio
          .get(
              '${ApiStrings.BASE_URL}/conversations/$conversationID/chat-messages')
          .then((value) {
        isFetchingConversationMessages(false);
        var response = ConversationMessages.fromJson(value.data);
        conversationsMessages.value = response.chatMessages;
      });
    } on dioi.DioException catch (e) {
      isFetchingConversationMessages(false);
      Get.snackbar('Sorry', 'Failed to load chats.',
          backgroundColor: Colors.white);
      Logger().e(e.message);
      update();
    } catch (e, stackTrace) {
      isFetchingConversationMessages(false);
      Logger().e('Error: $e');
      Logger().i(stackTrace);
      update();
    }
  }

  newConversation({required String createdAt, required String title}) async {
    isCreatingNewChat(true);
    Map<String, dynamic> body = {
      "createdAt": createdAt,
      "updatedAt": createdAt,
      "userId": int.parse(userID.value),
      "title": title,
      "isFavorite": false
    };
    try {
      await dio
          .post('${ApiStrings.BASE_URL}/${ApiStrings.CREATE_CONVERSATION}',
              data: body)
          .then((value) async {
        isCreatingNewChat(false);
        var response = NewConversation.fromJson(value.data);
        await sendMessage(
            createdAt: createdAt,
            title: title,
            userID: userID.value,
            conversationID: response.conversation.id);
        var m = ChatMessage(
            user: ChatUser(id: userID.value),
            text: title,
            createdAt: DateTime.parse(createdAt));
        await getChatAIresponse(m, conversationID: response.conversation.id);
      });
    } on dioi.DioException catch (e) {
      isCreatingNewChat(false);
      Get.snackbar('Sorry', 'Failed to load chats.',
          backgroundColor: Colors.white);
      Logger().e(e.message);
      update();
    } catch (e, stackTrace) {
      isCreatingNewChat(false);
      Logger().e('Error: $e');
      Logger().i(stackTrace);
      update();
    }
  }

  sendMessage(
      {required String createdAt,
      required String title,
      required String userID,
      required String conversationID}) async {
    isCreatingChatMessage(true);
    Map<String, dynamic> body = {
      "createdAt": createdAt,
      "updatedAt": createdAt,
      "conversationId": conversationID,
      "userId": userID,
      "text": title,
    };
    try {
      await dio
          .post('${ApiStrings.BASE_URL}/${ApiStrings.CREATE_CONVERSATION}',
              data: body)
          .then((value) async {
        isCreatingChatMessage(false);
        var m = ChatMessage(
            user: ChatUser(id: userID),
            text: title,
            createdAt: DateTime.parse(createdAt));
        await getChatAIresponse(m);
      });
    } on dioi.DioException catch (e) {
      isCreatingChatMessage(false);
      Get.snackbar('Sorry', 'Failed to load chats.',
          backgroundColor: Colors.white);
      Logger().e(e.message);
      update();
    } catch (e, stackTrace) {
      isCreatingChatMessage(false);
      Logger().e('Error: $e');
      Logger().i(stackTrace);
      update();
    }
  }

  Future<void> getChatAIresponse(ChatMessage text,
      {String? conversationID}) async {
    final _openAI = gpt.OpenAI.instance.build(
        token: API_KEY,
        baseOption: gpt.HttpSetup(
          receiveTimeout: const Duration(seconds: 8),
        ),
        enableLog: true);
    messages.insert(0, text);
    List<gpt.Messages> _messageHistory = messages.reversed.map(
      (m) {
        if (m.user == currentUser) {
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
        messages.insert(
            0,
            ChatMessage(
                user: chatAI,
                createdAt: DateTime.now(),
                text: text.message!.content));
        await sendMessage(
            createdAt: DateTime.now().toString(),
            title: text.message!.content,
            userID: '1',
            conversationID: conversationID ?? '');
        Logger().i(messages.map((m) => m.toJson()).toList());
      }
    }
  }
}

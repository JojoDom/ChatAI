import 'package:chat_ai/controllers/user_controller.dart';
import 'package:chat_ai/models/conversation_messages.dart';
import 'package:chat_ai/models/new_conversation.dart';
import 'package:chat_ai/models/user_conversations.dart';
import 'package:chat_ai/utils/api_strings.dart';
import 'package:chat_ai/utils/chat_choice.dart' as mychoice;
import 'package:chat_ai/utils/helper.dart';
import 'package:chat_ai/utils/message.dart';
import 'package:chat_ai/utils/storage_keys.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart' as dioi;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cherry_toast/cherry_toast.dart';

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
  var isNewChat = false.obs;
  var conversationID = ''.obs;
  var isDeletingChat = false.obs;

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
        messages.clear();
        for (var res in conversationsMessages) {
          messages.add(ChatMessage(
              user: ChatUser(id: res.user.id.toString()),
              text: res.text,
              createdAt: DateTime.now()));
        }
        Logger().i(messages.map((element) => element.toJson()));
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
        conversationID.value = response.conversation.id;
        Logger().i(conversationID);
        Logger().i('Call this in controller');
        await sendMessage(
            createdAt: createdAt,
            title: title,
            userID: userID.value,
            conversationID: response.conversation.id);
      });
    } on dioi.DioException catch (e) {
      isCreatingNewChat(false);
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
          .post('${ApiStrings.BASE_URL}/${ApiStrings.CREATE_CHAT_MESSAGES}',
              data: body)
          .then((value) async {
        isCreatingChatMessage(false);
      });
    } on dioi.DioException catch (e) {
      isCreatingChatMessage(false);
      Logger().e(e.message);
      update();
    } catch (e, stackTrace) {
      isCreatingChatMessage(false);
      Logger().e('Error: $e');
      Logger().i(stackTrace);
      update();
    }
  }

  deleteChat(String conversationID) async {
    isDeletingChat(true);
    try {
      await dio
          .delete('${ApiStrings.BASE_URL}/conversations/$conversationID')
          .then((value) async {
        isDeletingChat(false);
         Helper().playSound('assets/audios/post.wav');
        CherryToast.success(
                title: const Text('Conversation Deleted'),
                displayTitle: true,
                animationType: AnimationType.fromTop,
                animationDuration: const Duration(milliseconds: 1000),
                autoDismiss: true)
            .show(Get.context!);
        await getUserConversations();
      });
    } on dioi.DioException catch (e) {
      isDeletingChat(false);
      Get.snackbar('', 'Failed to delete conversation',
          backgroundColor: Colors.red);
      Logger().e(e.message);
      update();
    } catch (e, stackTrace) {
      isDeletingChat(false);
      Get.snackbar('', 'Failed to delete conversation',
          backgroundColor: Colors.red);
      Logger().e('Error: $e');
      Logger().i(stackTrace);
      update();
    }
  }

  favoriteChat(String conversationID, bool isFavorite) async {
    isDeletingChat(true);
    try {
      await dio
          .put('${ApiStrings.BASE_URL}/conversations/$conversationID', data: {"isFavorite" : isFavorite})
          .then((value) async {
        isDeletingChat(false);
         Helper().playSound('assets/audios/post.wav');
        CherryToast.success(
                title: const Text('Added to favorites'),
                displayTitle: true,
                animationType: AnimationType.fromTop,
                animationDuration: const Duration(milliseconds: 1000),
                autoDismiss: true)
            .show(Get.context!);
        await getUserConversations();
      });
    } on dioi.DioException catch (e) {
      isDeletingChat(false);
      Get.snackbar('', 'Failed to add to favorites',
          backgroundColor: Colors.red);
      Logger().e(e.message);
      update();
    } catch (e, stackTrace) {
      isDeletingChat(false);
      Get.snackbar('', 'Failed to add to favorites',
          backgroundColor: Colors.red);
      Logger().e('Error: $e');
      Logger().i(stackTrace);
      update();
    }
  }
}

import 'package:chat_ai/models/user_conversations.dart';
import 'package:chat_ai/models/user_object.dart';
import 'package:chat_ai/screens/welcome_page.dart';
import 'package:chat_ai/utils/api_strings.dart';
import 'package:chat_ai/utils/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart' as dioi;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController extends GetxController {
  final dio = dioi.Dio();
  var isRegisteringUser = false.obs;
  var isLoggingIn = false.obs;
  var isFetchingConversations = false.obs;
  var isCreatingNewChat = false.obs;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  var conversations = <Conversation>[].obs;

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
    super.onInit();
  }

  userHandOff(
      {required String userName,
      required String email,
      required String phoneNumber,
      required String imageURL}) async {
    isRegisteringUser(true);
    Map<String, dynamic> body = {
      "userName": userName,
      "email": email,
      "phoneNumber": phoneNumber,
      "imageUrl": imageURL
    };
    try {
      await dio
          .post('${ApiStrings.BASE_URL}/${ApiStrings.CREATE_USER}', data: body)
          .then((value) async {
        Logger().i(value.data);
        var response = UserObject.fromJson(value.data);
        Get.offAll(Welcome(userName: userName, imageUrl: imageURL));
        Logger().i(response.user.id);
        await secureStorage.write(
            key: StorageKeys.ST_KEY_USER_ID, value: '${response.user.id}');
      });
    } on dioi.DioException catch (e) {
      isRegisteringUser(false);
      Get.snackbar('Sorry', 'Something went wrong. Try logging in again',
          backgroundColor: Colors.white);
      Logger().e(e.message);
      update();
    } catch (e, stackTrace) {
      isRegisteringUser(false);
      Logger().e('Error: $e');
      Logger().i(stackTrace);
      update();
    }
  }

  getConversations() async {
    isFetchingConversations(true);
    var userID = await secureStorage.read(key: StorageKeys.ST_KEY_USER_ID);
    try {
      await dio
          .get('${ApiStrings.BASE_URL}/users/$userID/converstions')
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

  newConversation({required String createdAt, required String title}) async {
    isCreatingNewChat(true);
    var userID = await secureStorage.read(key: StorageKeys.ST_KEY_USER_ID);
    Map<String, dynamic> body = {
      "createdAt": createdAt,
      "updatedAt": createdAt,
      "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "userId": userID,
      "title": title,
      "isFavorite": false
    };
    try {
      await dio.post('${ApiStrings.BASE_URL}/${ApiStrings.CREATE_CONVERSATION}',data: body).then((value) {
        isCreatingNewChat(false);
        var response = UserConversations.fromJson(value.data);
        conversations.value = response.conversations;
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

  createChatMessages({required String createdAt, required String title, required String userID, required String conversationID}) async {
    isCreatingNewChat(true);
    Map<String, dynamic> body = {
      "createdAt": createdAt,
      "updatedAt": createdAt,
      "conversationId": conversationID,
      "userId": userID,
      "text": title,     
    };
    try {
      await dio.post('${ApiStrings.BASE_URL}/${ApiStrings.CREATE_CONVERSATION}',data: body).then((value) {
        isCreatingNewChat(false);
        var response = UserConversations.fromJson(value.data);
        conversations.value = response.conversations;
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
}

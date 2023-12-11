import 'dart:convert';

import 'package:chat_ai/models/user_object.dart';
import 'package:chat_ai/utils/api_strings.dart';
import 'package:chat_ai/utils/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:chat_ai/screens/chat_history.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart' as dioi;
import 'package:auth_state_manager/auth_state_manager.dart';

class AuthController extends GetxController {
  final dio = dioi.Dio();
  var isRegisteringUser = false.obs;
  var isLoggingIn = false.obs;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();


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
         AuthStateManager.instance.login();
        Get.offAll(const ChatHistory());
        Logger().i(response.user.id);
        await secureStorage.write(
            key: StorageKeys.ST_KEY_USER_ID, value: '${response.user.id}');
        await secureStorage.write(
            key: StorageKeys.ST_USER_OBJECT, value: jsonEncode(value.data));
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
}


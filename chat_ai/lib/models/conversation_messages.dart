// To parse this JSON data, do
//
//     final conversationMessages = conversationMessagesFromJson(jsonString);

import 'dart:convert';

ConversationMessages conversationMessagesFromJson(String str) => ConversationMessages.fromJson(json.decode(str));

String conversationMessagesToJson(ConversationMessages data) => json.encode(data.toJson());

class ConversationMessages {
    List<ChatMessageLocal> chatMessages;

    ConversationMessages({
        required this.chatMessages,
    });

    factory ConversationMessages.fromJson(Map<String, dynamic> json) => ConversationMessages(
        chatMessages: List<ChatMessageLocal>.from(json["chatMessages"].map((x) => ChatMessageLocal.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "chatMessages": List<dynamic>.from(chatMessages.map((x) => x.toJson())),
    };
}

class ChatMessageLocal {
    User user;
    String text;

    ChatMessageLocal({
        required this.user,
        required this.text,
    });

    factory ChatMessageLocal.fromJson(Map<String, dynamic> json) => ChatMessageLocal(
        user: User.fromJson(json["user"]),
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "text": text,
    };
}

class User {
    int id;
    String userName;
    String email;
    String phoneNumber;
    String imageUrl;

    User({
        required this.id,
        required this.userName,
        required this.email,
        required this.phoneNumber,
        required this.imageUrl,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userName: json["userName"]??'',
        email: json["email"]??'',
        phoneNumber: json["phoneNumber"]??'',
        imageUrl: json["imageUrl"]??'',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "email": email,
        "phoneNumber": phoneNumber,
        "imageUrl": imageUrl,
    };
}

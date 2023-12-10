// To parse this JSON data, do
//
//     final newConversation = newConversationFromJson(jsonString);

import 'dart:convert';

NewConversation newConversationFromJson(String str) => NewConversation.fromJson(json.decode(str));

String newConversationToJson(NewConversation data) => json.encode(data.toJson());

class NewConversation {
    NewMessage conversation;

    NewConversation({
        required this.conversation,
    });

    factory NewConversation.fromJson(Map<String, dynamic> json) => NewConversation(
        conversation: NewMessage.fromJson(json["conversation"]),
    );

    Map<String, dynamic> toJson() => {
        "conversation": conversation.toJson(),
    };
}

class NewMessage {
    DateTime createdAt;
    DateTime updatedAt;
    String id;
    String title;
    int userId;
    bool isFavorite;

    NewMessage({
        required this.createdAt,
        required this.updatedAt,
        required this.id,
        required this.title,
        required this.userId,
        required this.isFavorite,
    });

    factory NewMessage.fromJson(Map<String, dynamic> json) => NewMessage(
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        id: json["id"],
        title: json["title"],
        userId: json["userId"],
        isFavorite: json["isFavorite"],
    );

    Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "id": id,
        "title": title,
        "userId": userId,
        "isFavorite": isFavorite,
    };
}

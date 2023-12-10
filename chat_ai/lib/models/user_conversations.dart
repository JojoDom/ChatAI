// To parse this JSON data, do
//
//     final userConversations = userConversationsFromJson(jsonString);

import 'dart:convert';

UserConversations userConversationsFromJson(String str) => UserConversations.fromJson(json.decode(str));

String userConversationsToJson(UserConversations data) => json.encode(data.toJson());

class UserConversations {
    List<Conversation> conversations;
    UserConversations({
        required this.conversations,
    });

    factory UserConversations.fromJson(Map<String, dynamic> json) => UserConversations(
        conversations: List<Conversation>.from(json["conversations"].map((x) => Conversation.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "conversations": List<dynamic>.from(conversations.map((x) => x.toJson())),
    };
}

class Conversation {
    DateTime createdAt;
    DateTime updatedAt;
    String id;
    String title;
    int userId;
    bool isFavorite;

    Conversation({
        required this.createdAt,
        required this.updatedAt,
        required this.id,
        required this.title,
        required this.userId,
        required this.isFavorite,
    });

    factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
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

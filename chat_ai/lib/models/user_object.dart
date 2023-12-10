// To parse this JSON data, do
//
//     final userObject = userObjectFromJson(jsonString);

import 'dart:convert';

UserObject userObjectFromJson(String str) => UserObject.fromJson(json.decode(str));

String userObjectToJson(UserObject data) => json.encode(data.toJson());

class UserObject {
    User user;

    UserObject({
        required this.user,
    });

    factory UserObject.fromJson(Map<String, dynamic> json) => UserObject(
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
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
        userName: json["userName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "email": email,
        "phoneNumber": phoneNumber,
        "imageUrl": imageUrl,
    };
}

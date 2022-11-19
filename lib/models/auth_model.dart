// To parse this JSON data, do
//
//     final authResponse = authResponseFromMap(jsonString);

import 'dart:convert';

class AuthResponse {
    AuthResponse({
        required this.email,
        required this.fullName,
        this.phone,
        required this.id,
        required this.token,
    });

    String email;
    String fullName;
    String? phone;
    String id;
    String token;

    factory AuthResponse.fromJson(String str) => AuthResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
        email: json["email"].toString(),
        fullName: json["fullName"].toString(),
        phone: json["phone"].toString(),
        id: json["id"].toString(),
        token: json["token"].toString(),
    );

    Map<String, dynamic> toMap() => {
        "email": email,
        "fullName": fullName,
        "phone": phone ?? '',
        "id": id,
        "token": token,
    };
}

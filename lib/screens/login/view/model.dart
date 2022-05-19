import 'dart:convert';

class LoginResponseModel {
  final String token;
  final String error;
  final String email;

  LoginResponseModel(
      {required this.token, required this.error, required this.email});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
        token: json["access_token"] != null ? json["access_token"] : "",
        error: json['error'] != null ? json["error"] : "",
        email: json['email'] != null ? json["email"] : "");
  }
}

class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.trim(),
      'password': password.trim()
    };
    return map;
  }
}
// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

SocialLogin userFromJson(String str) => SocialLogin.fromJson(json.decode(str));

String userToJson(SocialLogin data) => json.encode(data.toJson());

class SocialLogin {
  SocialLogin({
    required this.access_token,
    required this.code,
    required this.id_token,
    //required this.password,
  });

  String access_token;
  String code;
  String id_token;

  // String password;

  factory SocialLogin.fromJson(Map<String, dynamic> json) => SocialLogin(
        access_token: json["access_token"],
        code: json["code"],
        id_token: json["id_token"],
        // password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": access_token,
        "code": code,
        "id_token": id_token,
        //"password": password,
      };
}

import 'package:flutter/foundation.dart';

class Signup {
  String username;
  String password;
  String email;

  Signup(
      {
        @required this.username,
        @required this.password,
        @required this.email
      }
      );

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "email": email
    };
  }
}
import 'dart:convert';

import 'package:healthub_frontend/Model/SIgnup.dart';
import 'package:healthub_frontend/Model/api_response.dart';

import 'package:http/http.dart' as http;

class SignupService {
  static const API = 'http://10.0.2.2:8080';
  static const headers = {
    'Content-Type': 'application/json'
  };

  Future<APIResponse<bool>> signup(Signup item) {
    return http.post(API + '/signup',headers:headers, body: json.encode(item.toJson())).then((data) {
      print(json.encode(item.toJson()));
      print(data.statusCode);
      print(data.body);
      if (data.statusCode == 200 && (data.body == "Sign up is successful")) {
        return APIResponse<bool>(data: true);
      }
      else{
        return APIResponse<bool>(error: true, errorMessage: 'An error occured');
      }
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

}
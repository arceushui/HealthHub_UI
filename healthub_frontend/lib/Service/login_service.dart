import 'dart:convert';

import 'package:healthub_frontend/Model/api_response.dart';
import 'package:healthub_frontend/Model/login.dart';
import 'package:http/http.dart' as http;


class LoginService {
  static const API = 'http://10.0.2.2:8080';
  static const headers = {
    'Content-Type': 'application/json'
  };

  Future<APIResponse<Object>> login(Login item) {
    return http.post(API + '/login', headers: headers, body: json.encode(item.toJson())).then((data) {
      print(json.encode(item.toJson()));
      print(data.statusCode);
      print(data.body);
      if (data.statusCode == 200 && data.body == "error") {
        return APIResponse<bool>(error: true, errorMessage: 'An error occured');
      }
      else{
        return APIResponse<bool>(error: false);
      }
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<String>> sendId(Login item) {
    return http.post(API + '/login', headers: headers, body: json.encode(item.toJson())).then((data) {
        return APIResponse<String>(data: data.body);
    });
  }

}
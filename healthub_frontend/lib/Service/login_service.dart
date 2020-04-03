import 'dart:convert';

import 'package:healthub_frontend/Model/api_response.dart';
import 'package:healthub_frontend/Model/login.dart';
import 'package:http/http.dart' as http;


class LoginService {
  static const API = 'http://localhost:8080';

  Future<APIResponse<bool>> login(Login item) {
    return http.post(API + '/login', body: json.encode(item.toJson())).then((data) {
      if (data.statusCode == 200 && data.body != "Error" ) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<String>> sendId(Login item) {
    return http.post(API + '/login', body: json.encode(item.toJson())).then((data) {
        return APIResponse<String>(data: data.body);
    });
  }

}
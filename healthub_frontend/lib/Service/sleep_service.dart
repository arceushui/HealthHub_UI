import 'dart:convert';

import 'package:healthub_frontend/Model/SleepStore.dart';
import 'package:healthub_frontend/Model/api_response.dart';
import 'package:http/http.dart' as http;

class SleepService {
  static const API = 'http://10.0.2.2:8080';
  static const headers = {'Content-Type': 'application/json'};

  Future<APIResponse<SleepStore>> getSleepStore(String id) {
    return http.get(API + '/sleeping?id=' + id, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<SleepStore>(data: SleepStore.fromJson(jsonData));
      }
      return APIResponse<SleepStore>(
          error: true, errorMessage: 'An error occured');
    }).catchError((_) =>
        APIResponse<SleepStore>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<String>> addSleepStore(SleepStore sleepStore, String id) {
    return http
        .post(API + '/sleeping?id=' + id,
            headers: headers, body: json.encode(sleepStore.toJson()))
        .then((data) {
      return APIResponse<String>(data: data.body);
    }).catchError((data) => APIResponse<SleepStore>(
            error: true, errorMessage: data.body.error));
  }
}

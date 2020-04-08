import 'dart:convert';

import 'package:healthub_frontend/Model/Activities.dart';
import 'package:healthub_frontend/Model/api_response.dart';
import 'package:http/http.dart' as http;

class ActivityService {
  static const API = 'http://10.0.2.2:8080';
  static const headers = {'Content-Type': 'application/json'};

  Future<APIResponse<Activities>> getActivities(String id) {
    return http.get(API + '/activity?id=' + id, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Activities>(data: Activities.fromJson(jsonData));
      }
      return APIResponse<Activities>(
          error: true, errorMessage: 'An error occured');
    }).catchError((_) =>
        APIResponse<Activities>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<String>> addActivities(Activities activities, String id) {
    return http
        .post(API + '/activity?id=' + id,
            headers: headers, body: json.encode(activities.toJson()))
        .then((data) {
      return APIResponse<String>(data: data.body);
    }).catchError((data) => APIResponse<Activities>(
            error: true, errorMessage: data.body.error));
  }
}

import 'dart:convert';

import 'package:healthub_frontend/Model/GenerateProfile.dart';
import 'package:healthub_frontend/Model/Profile.dart';
import 'package:healthub_frontend/Model/api_response.dart';
import 'package:http/http.dart' as http;

class ProfileService {

  static const API = 'http://10.0.2.2:8080';
  static const headers = {
    'Content-Type': 'application/json'
  };

  Future<APIResponse<Profile>> getProfile(String id) {
    return http.get(API + '/healthprofile?id=' + id, headers: headers).then((data) {
      print(id);
      print(data.body);
      print(data.statusCode);
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        print(jsonData);
        return APIResponse<Profile>(data: Profile.fromJson(jsonData));
      }
      return APIResponse<Profile>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<Profile>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<String>> editProfile(GenerateProfile item, String id) {
    return http.post(API + '/healthprofile?id=' + id, headers: headers, body: json.encode(item.toJson())).then((data) {
      print(data.body);
      return APIResponse<String>(data: data.body);
    });
  }
}
import 'dart:convert';

import 'package:healthub_frontend/Model/GenerateMeal.dart';
import 'package:healthub_frontend/Model/api_response.dart';
import 'package:http/http.dart' as http;

class MealService {
  static const API = 'http://10.0.2.2:8080';
  static const headers = {
    'Content-Type': 'application/json'
  };
  Future<APIResponse<GenerateMeal>> getMeal(String id) {
    return http.get(API + '/meal?id=' + id, headers: headers).then((data) {
      print(id);
      print(data.body);
      print(data.statusCode);
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        print(jsonData);
        return APIResponse<GenerateMeal>(data: GenerateMeal.fromJson(jsonData));
      }
      return APIResponse<GenerateMeal>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<GenerateMeal>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<String>> editMeal(GenerateMeal item, String id, String auto) {
    return http.post(API + '/meal?id=' + id + "&auto=" + auto, headers: headers, body: json.encode(item.toJson())).then((data) {
      print(data.body);
      return APIResponse<String>(data: data.body);
    });
  }

}
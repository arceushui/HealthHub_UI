import 'dart:convert';

import 'package:healthub_frontend/Model/PrescriptionStore.dart';
import 'package:healthub_frontend/Model/Activity.dart';
import 'package:healthub_frontend/Model/api_response.dart';
import 'package:http/http.dart' as http;

class PrescriptionService {
  static const API = 'http://192.168.1.233:8080';
  static const headers = {'Content-Type': 'application/json'};

  Future<APIResponse<PrescriptionStore>> getPrescriptionStore(String id) {
    return http
        .get(API + '/prescriptions?id=' + id, headers: headers)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<PrescriptionStore>(
            data: PrescriptionStore.fromJson(jsonData));
      }
      return APIResponse<PrescriptionStore>(
          error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<PrescriptionStore>(
            error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<String>> addPrescriptionStore(
      PrescriptionStore activities, String id) {
    return http
        .post(API + '/prescriptions?id=' + id,
            headers: headers, body: json.encode(activities.toJson()))
        .then((data) {
      return APIResponse<String>(data: data.body);
    }).catchError((data) => APIResponse<PrescriptionStore>(
            error: true, errorMessage: data.body.error));
  }
}

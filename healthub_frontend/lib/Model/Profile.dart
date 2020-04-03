import 'package:flutter/foundation.dart';
import 'Weight.dart';

class Profile {
  String gender;
  int age;
  List<Weight> weights;
  int height;

  Profile(
      {
        @required this.gender,
        @required this.age,
        @required this.weights,
        @required this.height,
      }
      );

  factory Profile.fromJson(Map<String, dynamic> item) {
    return Profile(
      gender: item['gender'],
      age: item['age'],
      weights: item['weights'],
      height: item['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "gender": gender,
      "age": age,
      "weights": weights,
      "height" : height
    };
  }
}
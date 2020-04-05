import 'package:flutter/foundation.dart';
import 'Weight.dart';

class Profile {
  String gender;
  int age;
  List<Weight> weights;
  int height;
  int count;

  Profile(
      {
        @required this.gender,
        @required this.age,
        @required this.weights,
        @required this.height,
      }
      );

  factory Profile.fromJson(Map<String, dynamic> parsedJson){

    print(parsedJson['age']);

    var list = parsedJson['weights'] as List;
    print(list);
    print(list.runtimeType);

    List<Weight> weightList = list.map((i) => Weight.fromJson(i)).toList();

    print(weightList);

    return Profile(
        age: parsedJson['age'],
        height: parsedJson['height'],
        gender: parsedJson['gender'],
        weights: weightList
    );
  }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['age'] = this.age;
    data['gender'] = this.gender;
    if (this.weights != null) {
      data['weights'] = this.weights.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
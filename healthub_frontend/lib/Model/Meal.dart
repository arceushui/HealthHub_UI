import 'package:flutter/foundation.dart';

import 'CustomDateTimeConvertor.dart';

class Meal {
  String mealType;
  String mealName;
  DateTime mealTime;
  double calories;
  List<String> ingredients;

  Meal(
      {this.mealType,
        this.mealName,
        this.mealTime,
        this.calories,
        this.ingredients});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealType: json['mealType'],
      mealName: json['mealName'],
      mealTime: DateTime.parse(json['mealTime']),
      calories: json['calories'],
      ingredients: json['ingredients'].cast<String>()
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mealType'] = this.mealType;
    data['mealName'] = this.mealName;
    data['mealTime'] = this.mealTime == null ? null : const CustomDateTimeConverter().toJson(mealTime);
    data['calories'] = this.calories;
    data['ingredients'] = this.ingredients;
    return data;
  }
}
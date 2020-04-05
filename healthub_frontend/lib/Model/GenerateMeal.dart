import 'Meal.dart';

class GenerateMeal {
  List<Meal> meals;

  GenerateMeal({this.meals});

  factory GenerateMeal.fromJson(Map<String, dynamic> json) {
    List<Meal> meal = new List<Meal>();
    if (json['meals'] != null) {
      json['meals'].forEach((v) {
        meal.add(new Meal.fromJson(v));
      });
    }
    return GenerateMeal(
      meals: meal
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meals != null) {
      data['meals'] = this.meals.map((v) => v.toJson()).toList();
    }
    print(data);
    return data;
  }

}
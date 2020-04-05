import 'package:flutter/foundation.dart';
import 'package:healthub_frontend/Model/CustomDateTimeConvertor.dart';

class Activity {
  String activity;
  DateTime date;
  double caloriBurned;
  double duration;

  Activity({this.activity, this.date, this.caloriBurned, this.duration});

  factory Activity.fromJson(Map<String, dynamic> item) {
    return Activity(
        date: DateTime.parse(item['date']),
        activity: item['activity'],
        caloriBurned: item['caloriBurned'],
        duration: item['duration']);
  }

  Map<String, dynamic> toJson() {
    var now = new DateTime.now();
    return {
      "date": date == null
          ? const CustomDateTimeConverter().toJson(now)
          : const CustomDateTimeConverter().toJson(date),
      "activity": activity,
      "caloriBurned": caloriBurned,
      "duration": duration
    };
  }
}

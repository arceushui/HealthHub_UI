import 'package:healthub_frontend/Model/Activity.dart';
import 'package:collection/collection.dart';

class Activities {
  List<Activity> activities;
  Activities({this.activities});

  factory Activities.fromJson(Map<String, dynamic> json) {
    List<Activity> _activities = new List<Activity>();
    if (json['activities'] != null) {
      json['activities'].forEach((v) {
        _activities.add(new Activity.fromJson(v));
      });
    }
    return Activities(activities: _activities);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.activities != null) {
      data['activities'] = this.activities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

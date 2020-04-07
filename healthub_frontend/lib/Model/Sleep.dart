import 'package:flutter/foundation.dart';
import 'package:healthub_frontend/Model/CustomDateTimeConvertor.dart';

class Sleep {
  DateTime sleepingTime;
  double duration;

  Sleep({this.sleepingTime, this.duration});

  factory Sleep.fromJson(Map<String, dynamic> item) {
    return Sleep(
        sleepingTime: DateTime.parse(item['sleepingTime']),
        duration: item['duration']);
  }

  Map<String, dynamic> toJson() {
    var now = new DateTime.now();
    return {
      "sleepingTime": sleepingTime == null
          ? const CustomDateTimeConverter().toJson(now)
          : const CustomDateTimeConverter().toJson(sleepingTime),
      "duration": duration
    };
  }
}

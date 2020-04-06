import 'package:flutter/foundation.dart';

class Sleep {
  String sleepingTime;
  String duration;

  Sleep({this.sleepingTime, this.duration});

  factory Sleep.fromJson(Map<String, dynamic> item) {
    return Sleep(
        sleepingTime: item['sleepingTime'], duration: item['duration']);
  }

  Map<String, dynamic> toJson() {
    return {"sleepingTime": sleepingTime, "duration": duration};
  }
}

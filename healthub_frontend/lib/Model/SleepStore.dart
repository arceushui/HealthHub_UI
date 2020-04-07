import 'package:healthub_frontend/Model/Sleep.dart';

class SleepStore {
  List<Sleep> sleeping;
  SleepStore({this.sleeping});

  factory SleepStore.fromJson(Map<String, dynamic> json) {
    List<Sleep> _sleeping = new List<Sleep>();
    if (json['sleeping'] != null) {
      json['sleeping'].forEach((v) {
        _sleeping.add(new Sleep.fromJson(v));
      });
    }
    return SleepStore(sleeping: _sleeping);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sleeping != null) {
      data['sleeping'] = this.sleeping.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

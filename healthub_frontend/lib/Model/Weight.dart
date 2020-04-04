import 'package:flutter/foundation.dart';
import 'package:healthub_frontend/Model/CustomDateTimeConvertor.dart';

class Weight {
  DateTime timestamp;
  double weight;

  Weight({
    this.timestamp,
    this.weight,
  });

  factory Weight.fromJson(Map<String, dynamic> item) {
    return Weight(
        timestamp: DateTime.parse(item['timestamp']), weight: item['weight']);
  }

  Map<String, dynamic> toJson() {
    var now = new DateTime.now();
    return {
      "timestamp": timestamp == null
          ? const CustomDateTimeConverter().toJson(now)
          : const CustomDateTimeConverter().toJson(timestamp),
      "weight": weight
    };
  }
}

import 'package:flutter/foundation.dart';

class Weight {
  DateTime timestamp;
  int weight;

  Weight(
      {
        @required this.timestamp,
        @required this.weight,
      }
      );

  factory Weight.fromJson(Map<String, dynamic> item) {
    return Weight(
      timestamp: item['timestamp'],
      weight: item['weight']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "timestamp": timestamp,
      "weight": weight
    };
  }
}
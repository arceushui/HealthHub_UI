
class Activity {
  String activity;
  String date;
  double caloriBurned;
  double duration;

  Activity({this.activity, this.date, this.caloriBurned, this.duration});

  factory Activity.fromJson(Map<String, dynamic> item) {
    return Activity(
        date: item['date'],
        activity: item['activity'],
        caloriBurned: item['caloriBurned'],
        duration: item['duration']);
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "activity": activity,
      "caloriBurned": caloriBurned,
      "duration": duration
    };
  }
}

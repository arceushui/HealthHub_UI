class Prescription {
  String prescriptionName;
  String startDate;
  String instructions;
  String prescriptionUnit;
  String endDate;
  String repeatDay;

  Prescription({
    this.prescriptionName,
    this.startDate,
    this.instructions,
    this.prescriptionUnit,
    this.endDate,
    this.repeatDay,
  });

  factory Prescription.fromJson(Map<String, dynamic> item) {
    return Prescription(
      prescriptionName: item['prescriptionName'],
      startDate: item['startDate'],
      instructions: item['instructions'],
      prescriptionUnit: item['prescriptionUnit'],
      endDate: item['endDate'],
      repeatDay: item['repeatDay'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "prescriptionName": prescriptionName,
      "startDate": startDate,
      "instructions": instructions,
      "prescriptionUnit": prescriptionUnit,
      "endDate": endDate,
      "repeatDay": repeatDay,
    };
  }
}

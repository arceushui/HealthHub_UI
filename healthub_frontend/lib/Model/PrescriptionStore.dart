import 'package:healthub_frontend/Model/Prescription.dart';
import 'package:collection/collection.dart';

class PrescriptionStore {
  List<Prescription> prescriptions;
  PrescriptionStore({this.prescriptions});

  factory PrescriptionStore.fromJson(Map<String, dynamic> json) {
    List<Prescription> _prescriptions = new List<Prescription>();
    if (json['prescriptions'] != null) {
      json['prescriptions'].forEach((v) {
        _prescriptions.add(new Prescription.fromJson(v));
      });
    }
    return PrescriptionStore(prescriptions: _prescriptions);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.prescriptions != null) {
      data['prescriptions'] =
          this.prescriptions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

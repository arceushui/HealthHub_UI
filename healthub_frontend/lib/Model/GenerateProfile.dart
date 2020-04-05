import 'Profile.dart';

class GenerateProfile {
  Profile profile;

  GenerateProfile({this.profile});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profile != null) {
      data['profile'] = this.profile.toJson();
    }
    return data;
  }
}
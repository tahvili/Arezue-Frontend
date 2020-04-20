/// Jason deserialization of a jobseeker user.

import 'package:json_annotation/json_annotation.dart';

part 'jobseeker.g.dart';

@JsonSerializable()
class Jobseeker extends Object {
  final String uid;
  @JsonKey(name: 'fb_id')
  final String fbId;
  final String name;
  @JsonKey(name: 'email_address')
  final String email;
  @JsonKey(name: 'phone_number', nullable: true)
  final String phoneNumber;
  @JsonKey(nullable: true)
  final String location;
  @JsonKey(name: 'profile_picture', nullable: true)
  final String profilePicture;
  @JsonKey(name: 'active_states')
  bool activeStates;
  @JsonKey(name: 'date_created')
  var dateCreated;
  @JsonKey(name: 'date_last_login')
  var dateLastLogin;
  @JsonKey(name: 'num_employer_scanned', nullable: true)
  final int numEmployerScanned;
  @JsonKey(name: 'num_employer_viewed_resume', nullable: true)
  final int numEmployerViewedResume;
  @JsonKey(name: 'pending_interest', nullable: true)
  final int pendingInterest;
  @JsonKey(name: 'potential_client', nullable: true)
  final bool potentialClient;

  Jobseeker(this.uid, this.fbId, this.name, this.email,
      {this.phoneNumber,
      this.location,
      this.profilePicture,
      this.activeStates,
      this.dateCreated,
      this.dateLastLogin,
      this.numEmployerScanned,
      this.numEmployerViewedResume,
      this.pendingInterest,
      this.potentialClient});

  factory Jobseeker.fromJson(Map<String, dynamic> json) =>
      _$JobseekerFromJson(json);
  Map<String, dynamic> toJson() => _$JobseekerToJson(this);

  String getProfilePicture() {
    return profilePicture;
  }

  String getName() {
    return name;
  }
}

/// Jason deserialization of an employer user.

import 'package:json_annotation/json_annotation.dart';
part 'employer.g.dart';

@JsonSerializable()
class Employer extends Object {
  final String uid;
  @JsonKey(name: 'fb_id')
  final String fbId;
  final String name;
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
  @JsonKey(name: 'email_address')
  final String email;
  @JsonKey(name: 'interview_request_sent', nullable: true)
  final int interviewRequestSent;
  @JsonKey(name: 'accepted_interview_request', nullable: true)
  final int acceptedInterviewRequest;
  @JsonKey(name: 'successful_searches', nullable: true)
  final int successfulSearches;
  @JsonKey(name: 'company_name')
  final String companyID;

  Employer(this.uid, this.fbId, this.companyID, this.name, this.email,
      {this.phoneNumber,
      this.location,
      this.profilePicture,
      this.activeStates,
      this.dateCreated,
      this.dateLastLogin,
      this.interviewRequestSent,
      this.acceptedInterviewRequest,
      this.successfulSearches});

  factory Employer.fromJson(Map<String, dynamic> json) =>
      _$EmployerFromJson(json);
  Map<String, dynamic> toJson() => _$EmployerToJson(this);

  bool changeStatus() {
    if (activeStates == true) {
      activeStates = false;
    } else {
      activeStates = true;
    }
    return activeStates;
  }
}

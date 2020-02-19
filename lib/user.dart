import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Object {
  final String uid;
  @JsonKey(name: 'fb_id')
  final String fbId;
  final String name;
  @JsonKey(name: 'email_address')
  final String email;
  @JsonKey(name: 'phone_number', nullable: true)
  final String phoneNumber; // = '6479950165';
  @JsonKey(nullable: true)
  final String location; // = 'Mississauga, Ontario, Canada';
  @JsonKey(name: 'profile_picture', nullable: true)
  final String profilePicture; // = 'assets/profile.jpg';
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

  User(this.uid, this.fbId, this.name, this.email,
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

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  bool isActive() {
    return activeStates;
  }

  bool changeStatus() {
    if (activeStates == true) {
      activeStates = false;
      print(activeStates);
    } else {
      activeStates = true;
      print(activeStates);
    }
    return activeStates;
  }

  String getProfilePicture() {
    return profilePicture;
  }

  String getName() {
    return name;
  }
}

//class User extends Object{
//
//  String uid;
//  String name = 'Mohammad Tahvili';
//  String email = 'tahvili@outlook.com';
//  String phoneNumber = '6479950165';
//  String location = 'Mississauga, Ontario, Canada';
//  String profilePicture = 'assets/profile.jpg';
//  String activeStates = 'true';
//  var dateCreated;
//  var dateLastLogin;
//
//
//  User({this.uid});
//
//  String isActive(){
//    return activeStates;
//  }
//
//  String changeStatus(){
//    if (activeStates=='true') {
//      activeStates = 'false';
//      print(activeStates);
//    }
//    else{
//      activeStates = 'true';
//      print(activeStates);
//    }
//  }
//
//  String getProfilePicture(){
//    return profilePicture;
//  }
//
//  String getName(){
//    return name;
//  }
//
//}

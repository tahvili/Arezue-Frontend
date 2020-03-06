// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jobseeker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Jobseeker _$JobseekerFromJson(Map<String, dynamic> json) {
  return Jobseeker(
    json['uid'] as String,
    json['fb_id'] as String,
    json['name'] as String,
    json['email_address'] as String,
    phoneNumber: json['phone_number'] as String,
    location: json['location'] as String,
    profilePicture: json['profile_picture'] as String,
    activeStates: json['active_states'] as bool,
    dateCreated: json['date_created'],
    dateLastLogin: json['date_last_login'],
    numEmployerScanned: json['num_employer_scanned'] as int,
    numEmployerViewedResume: json['num_employer_viewed_resume'] as int,
    pendingInterest: json['pending_interest'] as int,
    potentialClient: json['potential_client'] as bool,
  );
}

Map<String, dynamic> _$JobseekerToJson(Jobseeker instance) => <String, dynamic>{
      'uid': instance.uid,
      'fb_id': instance.fbId,
      'name': instance.name,
      'email_address': instance.email,
      'phone_number': instance.phoneNumber,
      'location': instance.location,
      'profile_picture': instance.profilePicture,
      'active_states': instance.activeStates,
      'date_created': instance.dateCreated,
      'date_last_login': instance.dateLastLogin,
      'num_employer_scanned': instance.numEmployerScanned,
      'num_employer_viewed_resume': instance.numEmployerViewedResume,
      'pending_interest': instance.pendingInterest,
      'potential_client': instance.potentialClient,
    };

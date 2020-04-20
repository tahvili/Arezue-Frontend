// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employer _$EmployerFromJson(Map<String, dynamic> json) {
  return Employer(
    json['uid'] as String,
    json['fb_id'] as String,
    json['company_name'] as String,
    json['name'] as String,
    json['email_address'] as String,
    phoneNumber: json['phone_number'] as String,
    location: json['location'] as String,
    profilePicture: json['profile_picture'] as String,
    activeStates: json['active_states'] as bool,
    dateCreated: json['date_created'],
    dateLastLogin: json['date_last_login'],
    interviewRequestSent: json['interview_request_sent'] as int,
    acceptedInterviewRequest: json['accepted_interview_request'] as int,
    successfulSearches: json['successful_searches'] as int,
  );
}

Map<String, dynamic> _$EmployerToJson(Employer instance) => <String, dynamic>{
      'uid': instance.uid,
      'fb_id': instance.fbId,
      'name': instance.name,
      'phone_number': instance.phoneNumber,
      'location': instance.location,
      'profile_picture': instance.profilePicture,
      'active_states': instance.activeStates,
      'date_created': instance.dateCreated,
      'date_last_login': instance.dateLastLogin,
      'email_address': instance.email,
      'interview_request_sent': instance.interviewRequestSent,
      'accepted_interview_request': instance.acceptedInterviewRequest,
      'successful_searches': instance.successfulSearches,
      'company_name': instance.companyID,
    };

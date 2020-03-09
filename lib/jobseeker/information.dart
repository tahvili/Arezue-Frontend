import 'dart:convert';
import 'dart:async';

class JobseekerInfo{
  final UserData jobseeker;
  JobseekerInfo({this.jobseeker});

  factory JobseekerInfo.fromJson(Map<String, dynamic> parsedJson){
    return JobseekerInfo(
      jobseeker: UserData.fromJson(parsedJson['jobseeker'])
    );
  }
}
class UserData{
  String uid;
  Information information;

  UserData({this.uid, this.information});

  factory UserData.fromJson(Map<String, dynamic> parsedJson){
    print("the uid in info class");
    print(parsedJson['uid']);
    print(parsedJson['info']);
    return UserData(
        uid: parsedJson['uid'],
        information: Information.fromJson(parsedJson['info'])
    );
  }
}

class Information{
  final double acceptanceWage;
  final double goalWage;
  final bool openRelocation;
  Skill skill;
  DreamCareer dreamCareer;
  DreamCompany dreamCompany;
  Experiences experiences;

  Information({this.acceptanceWage, this.goalWage, this.openRelocation,
    this.skill, this.dreamCareer, this.dreamCompany, this.experiences});

  factory Information.fromJson(Map<String, dynamic> json){
    return Information(
        acceptanceWage: double.parse(json['acceptance_wage']),
        goalWage: double.parse(json['goal_wage']),
        openRelocation : json['open_relocation'],
//        dreamCompany: DreamCompany(json['dream_company']),
//        dreamCareer: DreamCareer(json['dream_career'])
    );
  }
}

class Experiences{

}

class DreamCareer{
//  final List<dynamic> careers;
//  DreamCareer(this.careers);

}

class DreamCompany{
//  final List<dynamic> companies;
//  DreamCompany(this.companies);
}

class Skill{

}
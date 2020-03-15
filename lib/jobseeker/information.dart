class JobseekerInfo {
  final UserData jobseeker;
  JobseekerInfo({this.jobseeker});

  factory JobseekerInfo.fromJson(Map<String, dynamic> parsedJson) {
    return JobseekerInfo(jobseeker: UserData.fromJson(parsedJson['jobseeker']));
  }
}

class UserData {
  String uid;
  Information information;

  UserData({this.uid, this.information});

  factory UserData.fromJson(Map<String, dynamic> parsedJson) {
    print("the uid in info class");
    print(parsedJson['uid']);
    print(parsedJson['info']);
    return UserData(
        uid: parsedJson['uid'],
        information: Information.fromJson(parsedJson['info']));
  }
}

class Information {
  final double acceptanceWage;
  final double goalWage;
  final bool openRelocation;
  List<Skill> skills;
  DreamCareer dreamCareer;
  DreamCompany dreamCompany;
  Experiences experiences;

  Information(
      {this.acceptanceWage,
      this.goalWage,
      this.openRelocation,
      this.skills,
      this.dreamCareer,
      this.dreamCompany,
      this.experiences});

  factory Information.fromJson(Map<String, dynamic> parsedJson) {

    var list = parsedJson['skill'] as List;
    print(list);
    List<Skill> skillsList = list.map((i) => Skill.fromJson(i)).toList();

    return Information(
      acceptanceWage: double.parse(parsedJson['acceptance_wage']),
      goalWage: double.parse(parsedJson['goal_wage']),
      openRelocation: parsedJson['open_relocation'],
      dreamCompany: DreamCompany(parsedJson['dream_company']),
      dreamCareer: DreamCareer(parsedJson['dream_career']),
      skills: skillsList,
    );
  }
}

class Experiences {}

class DreamCareer {
  final List careers;
  DreamCareer(this.careers);
}

class DreamCompany {
  final List companies;
  DreamCompany(this.companies);
}

class Skill {
  final String skill;
  final int ranking;
  final int yearsOfExperience;
  final int levelOfExperience;
  Skill(
      {this.skill,
      this.ranking,
      this.yearsOfExperience,
      this.levelOfExperience});

  factory Skill.fromJson(Map<String, dynamic> parsedJson) {
    return Skill(
        skill: parsedJson['skill'],
        ranking: parsedJson['ranking'],
        yearsOfExperience: parsedJson['years_of_experience'],
        levelOfExperience: parsedJson['level_expertise']);
  }
}

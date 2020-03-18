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
  List<Education> education;
  List<Certification> certification;
  List<Experience> experience;

  Information(
      {this.acceptanceWage,
      this.goalWage,
      this.openRelocation,
      this.skills,
      this.dreamCareer,
      this.dreamCompany,
        this.education,
      this.certification,
      this.experience});

  factory Information.fromJson(Map<String, dynamic> parsedJson) {

    var list = parsedJson['skill'] as List;
    List<Skill> skillsList = list.map((i) => Skill.fromJson(i)).toList();

    var edList = parsedJson['education'] as List;
    List<Education> educationList = edList.map((i) => Education.fromJson(i)).toList();

    var certList = parsedJson['certification'] as List;
    List<Certification> certificationList = certList.map((i) => Certification.fromJson(i)).toList();

    var expList = parsedJson['experience'] as List;
    List<Experience> experienceList = certList.map((i) => Experience.fromJson(i)).toList();

    return Information(
      acceptanceWage: double.parse(parsedJson['acceptance_wage']),
      goalWage: double.parse(parsedJson['goal_wage']),
      openRelocation: parsedJson['open_relocation'],
      dreamCompany: DreamCompany(parsedJson['dream_company']),
      dreamCareer: DreamCareer(parsedJson['dream_career']),
      skills: skillsList,
      education: educationList,
      certification: certificationList,
      experience: experienceList
    );
  }
}
//
class Education {

  String edId;
  String schoolName;
  String startDate;
  String gradDate;
  String program;

  Education({this.edId, this.schoolName, this.startDate, this.gradDate, this.program});

  factory Education.fromJson(Map<String, dynamic> parsedJson) {
    return Education(
        edId: parsedJson['ed_id'].toString(),
        schoolName: parsedJson['school_name'],
        startDate: parsedJson['start_date'],
        gradDate: parsedJson['grad_date'],
        program: parsedJson['program']);
  }
}

class Certification{

  String cId;
  String name;
  String startDate;
  String endDate;
  String issuer;

  Certification({this.cId, this.name, this.startDate, this.endDate, this.issuer});

  factory Certification.fromJson(Map<String, dynamic> parsedJson) {
    return Certification(
        cId: parsedJson['c_id'].toString(),
        name: parsedJson['cert_name'],
        startDate: parsedJson['start_date'],
        endDate: parsedJson['end_date'],
        issuer: parsedJson['issuer']);
  }
}

class Experience{

  String expId;
  String title;
  String startDate;
  String endDate;
  String description;

  Experience({this.expId, this.title, this.startDate, this.endDate, this.description});

  factory Experience.fromJson(Map<String, dynamic> parsedJson) {
    return Experience(
        expId: parsedJson['exp_id'].toString(),
        title: parsedJson['title'],
        startDate: parsedJson['start_date'],
        endDate: parsedJson['end_date'],
        description: parsedJson['description']);
  }
}

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
        yearsOfExperience: parsedJson['years_of_expertise'],
        levelOfExperience: parsedJson['level_expertise']);
  }
}

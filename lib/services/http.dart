/// HTTP server requests

import 'dart:async';
import 'dart:convert';
import 'package:arezue/employer/employer.dart';
import 'package:arezue/employer/jobInformation.dart';
import 'package:arezue/jobseeker/information.dart';
import 'package:arezue/jobseeker/jobseeker.dart';
import 'package:http/http.dart' as http;

class Requests {
  Future<Jobseeker> jobseekerGetRequest(Future<String> uid) async {
    var response = await http
        .get('https://api.daffychuy.com/api/v1/jobseeker/${await uid}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Jobseeker.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Job> jobGetRequest(uid) async {
    var response =
        await http.get('https://api.daffychuy.com/api/v1/employer/$uid/jobs');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return new Job.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      return new Job();
    }
  }

  Future<int> jobPostRequest(
      String uid, String companyName, List<String> lst) async {
    var url = 'https://api.daffychuy.com/api/v1/employer/$uid/jobs';
    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded"
    };
    var response = await http.post(url, headers: headers, body: {
      'company_name': companyName.toString(),
      'title': lst[0].toString(),
      'wage': lst[1].toString(),
      'position': lst[0].toString(),
      'hours': lst[2].toString(),
      'location': lst[3].toString(),
      'description': lst[5].toString(),
      'status': lst[4].toString(),
      'max_candidate': lst[6].toString()
    });
    int statusCode = response.statusCode;
    return statusCode;
  }

  Future<List<dynamic>> searchPostRequest(List<String> lst) async {
    var url = 'https://api.daffychuy.com/api/v1/search';
    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded"
    };
    var response = await http.post(url,
        headers: headers, body: {"skills": lst.join(',').toLowerCase()});
    var _list = json.decode(response.body);
    return _list["payload"];
  }

  Future<int> jobPutRequest(
      String uid, String jobId, Map<String, String> map) async {
    String url = 'https://api.daffychuy.com/api/v1/employer/$uid/jobs/$jobId';
    int statusCode;
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response =
        await http.put(url, headers: headers, body: json.encode(map));
    statusCode = response.statusCode;
    return statusCode;
  }

  Future<int> jobDeleteRequest(String uid, String jobId) async {
    String url = 'https://api.daffychuy.com/api/v1/employer/$uid/jobs/$jobId';
    http.Response response = await http.delete(url);
    int statusCode = response.statusCode;
    return statusCode;
  }

  Future<JobseekerInfo> profileGetRequest(Future<String> uid) async {
    var response = await http
        .get('https://api.daffychuy.com/api/v1/jobseeker/${await uid}/profile');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return new JobseekerInfo.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<JobseekerInfo> profileGetRequest2(String uid) async {
    var response = await http
        .get('https://api.daffychuy.com/api/v1/jobseeker/$uid/profile');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return new JobseekerInfo.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<List<Map<String, dynamic>>> skillsGetRequest(
      String uid, String type) async {
    var response =
        await http.get('https://api.daffychuy.com/api/v1/jobseeker/$uid/$type');
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> newList = new List<Map<String, dynamic>>();
      for (int i = 0; i < (json.decode(response.body)["data"]).length; i++) {
        newList.add((json.decode(response.body))["data"][i]);
      }
      return newList;
    } else {
      return [
        {'0': 0}
      ];
    }
  }

  Future<int> skillDeleteRequest(String uid, String skill) async {
    String url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/skill/$skill';
    http.Response response = await http.delete(url);
    int statusCode = response.statusCode;
    return statusCode;
  }

  Future<int> profileSkillPutRequest(String uid, String oldSkill,
      String newSkill, String numExperience, String numExpertise) async {
    if (await (skillDeleteRequest(uid, oldSkill)) == 200) {
      Future<int> response = profileSkillPostRequest(
          'jobseeker', uid, newSkill, numExpertise, numExperience);
      return response;
    } else {
      throw Exception('Failed to do a put request');
    }
  }

  searchListGetRequest(String uid, String category, String query) async {
    var response =
        await http.get('http://api.daffychuy.com/api/v1/jobseeker/$uid/$category/search?q=$query&limit=10' );
    var _list = (json.decode(response.body))["data"];
    return _list;
  }

  Future<int> profileSkillPostRequest(String usertype, String uid, String skill,
      String level, String years) async {
    var url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/skill';
    var response = await http
        .post(url, body: {'skill': skill, 'level': level, 'years': years});
    int statusCode = response.statusCode;
    return statusCode;
  }

  Future<Map<String, dynamic>> profileEdExCertPostRequest(
      String uid,
      String fieldId,
      String firstVal,
      String startDate,
      String endDate,
      String secondVal) async {
    var url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/$fieldId';
    http.Response response;
    if (fieldId == "education") {
      response = await http.post(url, body: {
        'school_name': firstVal,
        'start_date': startDate,
        'grad_date': endDate,
        'program': secondVal
      });
    } else if (fieldId == "experience") {
      response = await http.post(url, body: {
        'title': firstVal,
        'start_date': startDate,
        'end_date': endDate,
        'description': secondVal
      });
    } else {
      response = await http.post(url, body: {
        'cert_name': firstVal,
        'start_date': startDate,
        'end_date': endDate,
        'issuer': secondVal
      });
    }
    Map<String, dynamic> returnList = new Map<String, dynamic>();
    returnList["statusCode"] = response.statusCode;
    returnList["body"] = json.decode(response.body);
    return returnList;
  }

  Future<int> profileEdExCertPutRequest(
      String fieldId,
      String uid,
      String id,
      String firstVal,
      String startDate,
      String endDate,
      String secondVal) async {
    String url;
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response;
    if (fieldId == "education") {
      url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/education';
      response = await http.put(url,
          headers: headers,
          body: json.encode({
            'ed_id': id,
            'school_name': firstVal,
            'start_date': startDate,
            'grad_date': endDate,
            'program': secondVal
          }));
    } else if (fieldId == "experience") {
      url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/exp';
      response = await http.put(url,
          headers: headers,
          body: json.encode({
            'exp_id': id,
            'title': firstVal,
            'start_date': startDate,
            'end_date': endDate,
            'description': secondVal
          }));
    } else {
      url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/certification';
      response = await http.put(url,
          headers: headers,
          body: json.encode({
            'c_id': id,
            'cert_name': firstVal,
            'start_date': startDate,
            'end_date': endDate,
            'issuer': secondVal
          }));
    }
    // the makes the PUT request

    int statusCode = response.statusCode;
    return statusCode;
  }

  Future<int> edExCertDeleteRequest(
      String fieldId, String uid, String id) async {
    String url;
    if (fieldId == "education") {
      url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/education/$id';
    } else if (fieldId == "experience") {
      url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/exp/$id';
    } else {
      url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/certification/$id';
    }
    http.Response response = await http.delete(url);
    int statusCode = response.statusCode;
    return statusCode;
  }

  Future<Map<String, dynamic>> resumeGetList(Future<String> uid) async {
    var response = await http
        .get('https://api.daffychuy.com/api/v1/jobseeker/${await uid}/resumes');
    if (response.statusCode == 200) {
      var _list = json.decode(response.body);
      Map<String, dynamic> returnList = new Map<String, dynamic>();
      for (int i = 0; i < (_list["data"]).length; i++) {
        returnList[(_list["data"][i]["resume_id"].toString())] =
            (_list["data"][i]["resume"]);
      }
      // If the server did return a 200 OK response, then parse the JSON.
      return returnList;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      return {};
    }
  }

  Future<Map<String, dynamic>> resumeGetList2(String uid) async {
    var response = await http
        .get('https://api.daffychuy.com/api/v1/jobseeker/$uid/resumes');
    if (response.statusCode == 200) {
      var _list = json.decode(response.body);
      Map<String, dynamic> returnList = new Map<String, dynamic>();
      for (int i = 0; i < (_list["data"]).length; i++) {
        returnList[(_list["data"][i]["resume_id"].toString())] =
            (_list["data"][i]["resume"]);
      }
      // If the server did return a 200 OK response, then parse the JSON.
      return returnList;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      return {};
    }
  }

  Future<Map<String, dynamic>> resumeGetData(
      String uid, String resumeId) async {
    var response = await http.get(
        'https://api.daffychuy.com/api/v1/jobseeker/$uid/resumes/$resumeId');
    if (response.statusCode == 200) {
      var _list = json.decode(response.body);
      // If the server did return a 200 OK response, then parse the JSON.
      return _list;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      return {};
    }
  }

  Future<int> resumePostRequest(String uid, Map<String, String> list) async {
    var url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/resumes';
    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded"
    };
    var response = await http
        .post(url, headers: headers, body: {'resume': json.encode(list)});
    int statusCode = response.statusCode;
    return statusCode;
  }

  Future<int> resumePutRequest(
      String uid, String resumeId, Map<String, String> list) async {
    String url =
        'https://api.daffychuy.com/api/v1/jobseeker/$uid/resumes/$resumeId';
    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded"
    };
    http.Response response = await http
        .put(url, headers: headers, body: {'resume': json.encode(list)});
    int statusCode = response.statusCode;
    return statusCode;
  }

  Future<int> resumeDeleteRequest(String uid, String resumeId) async {
    String url =
        'https://api.daffychuy.com/api/v1/jobseeker/$uid/resumes/$resumeId';
    http.Response response = await http.delete(url);
    int statusCode = response.statusCode;
    return statusCode;
  }

  Future<int> profilePostRequest(String usertype, String uid, String command,
      String value, String preference, String rank) async {
    var url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/$command';
    var response =
        await http.post(url, body: {command: value, preference: rank});
    int statusCode = response.statusCode;
    return statusCode;
  }

  Future<int> deleteRequest(String uid, String type, String value) async {
    String url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/$type/$value';
    http.Response response = await http.delete(url);
    return response.statusCode;
  }

  Future<int> putRequest(
      String userType, String uid, String command, String change) async {
    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded"
    };
    http.Response response;
    if (userType == "jobseeker") {
      String url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid';
      response = await http.put(url, headers: headers, body: {command: change});
    }
    return response.statusCode;
  }

  //get request for employer

  Future<Employer> employerGetRequest(Future<String> uid) async {
    var response = await http
        .get('https://api.daffychuy.com/api/v1/employer/${await uid}');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Employer.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<int> jobseekerPostRequest(
      String uid, String email, String name) async {
    var url = 'https://api.daffychuy.com/api/v1/jobseeker';
    var response = await http
        .post(url, body: {'firebaseID': uid, 'email': email, 'name': name});

    return response.statusCode;
  }

  Future<int> employerPostRequest(
      String uid, String email, String name, String company) async {
    var url = 'https://api.daffychuy.com/api/v1/employer';
    var response = await http.post(url, body: {
      'firebaseID': uid,
      'email': email,
      'name': name,
      'company': company
    });

    return response.statusCode;
  }
}

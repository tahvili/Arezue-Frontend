/// HTTP server requests

import 'dart:async';
import 'dart:convert';
import 'package:arezue/employer/employer.dart';
import 'package:arezue/employer/jobInformation.dart';
import 'package:arezue/jobseeker/information.dart';
import 'package:arezue/jobseeker/jobseeker.dart';
import 'package:http/http.dart' as http;

class Requests {
  Future<Object> getRequest(Future<String> uid, String userType) async {
    var response = await http.get('https://api.daffychuy.com/api/v1/$userType/'
        '${await uid}');
    if (response.statusCode == 200) {
      if (userType == 'jobseeker') {
        return Jobseeker.fromJson(json.decode(response.body));
      } else if (userType == 'employer') {
        return Employer.fromJson(json.decode(response.body));
      } else {
        throw Exception('Illegal User Type');
      }
    } else {
      throw Exception('Failed to load user');
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

  searchListGetRequest(String category, String query) async {
    var response = await http.get(
        'http://api.daffychuy.com/api/v1/search/$category?q=$query&limit=10');
    var _list = (json.decode(response.body))["data"];
    return _list;
  }

  Future<JobseekerInfo> profileGetRequest(String uid) async {
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

  Future<Map<String, dynamic>> resumeGetRequest(
      String endpoint, String requestType) async {
    var response =
        await http.get('https://api.daffychuy.com/api/v1/jobseeker/$endpoint');
    if (requestType == 'resume_list') {
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
    } else if (requestType == 'resume_data') {
      if (response.statusCode == 200) {
        var _list = json.decode(response.body);
        // If the server did return a 200 OK response, then parse the JSON.
        return _list;
      } else {
        // If the server did not return a 200 OK response, then throw an exception.
        return {};
      }
    } else {
      throw Exception('Illegal Request');
    }
  }

  //Put requests

  Future<int> putRequest(String endpoint, String header,
      Map<String, String> map, bool flag) async {
    Map<String, String> headers = {"Content-type": "application/$header"};
    http.Response response;
    String url = 'https://api.daffychuy.com/api/v1/$endpoint';
    if (flag == false) {
      response = await http.put(url, headers: headers, body: map);
    } else {
      response = await http.put(url, headers: headers, body: json.encode(map));
    }
    return response.statusCode;
  }

  Future<int> profileSkillPutRequest(String uid, String oldSkill,
      String newSkill, String numExperience, String numExpertise) async {
    if (await (deleteRequest(uid, "skill/$oldSkill")) == 200) {
      Future<int> response = postRequest("jobseeker/$uid/skill", {
        'skill': newSkill,
        'level': '$numExpertise',
        'years': '$numExperience'
      });
      return response;
    } else {
      throw Exception('Failed to do a put request');
    }
  }

  // Delete Requests

  Future<int> deleteRequest(String uid, String endpoint) async {
    String url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/$endpoint';
    http.Response response = await http.delete(url);
    return response.statusCode;
  }

  //Post Requests

  Future<int> postRequest(String endpoint, Map<String, String> map) async {
    var url = 'https://api.daffychuy.com/api/v1/$endpoint';
    Map<String, String> headers = {
      "Content-type": "application/x-www-form-urlencoded"
    };
    var response = await http.post(url, headers: headers, body: map);
    int statusCode = response.statusCode;
    return statusCode;
  }

  Future<List<dynamic>> searchPostRequest(List<String> lst) async {
    var url = 'https://api.daffychuy.com/api/v1/search/candidates';
    var response = await http
        .post(url, body: {"skills": lst.join(',').toLowerCase().toString()});
    var _list = json.decode(response.body);
    return _list["payload"];
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
}

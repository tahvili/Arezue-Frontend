import 'dart:async';
import 'dart:convert';
import 'package:arezue/employer/employer.dart';
import 'package:arezue/jobseeker/information.dart';
import 'package:arezue/jobseeker/jobseeker.dart';
import 'package:http/http.dart' as http;

class Requests {
  /*
   Standard HTTP requests
   */

  //get request for jobseeker

  Future<Jobseeker> jobseekerGetRequest(Future<String> uid) async {
    var response = await http.get(
        'https://api.daffychuy.com/api/v1/jobseeker/${await uid}');
    print(response.statusCode);
    print("the status code is ${response.statusCode}");
    print(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Jobseeker.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<JobseekerInfo> profileGetRequest(Future<String> uid) async {
    var response = await http.get(
        'https://api.daffychuy.com/api/v1/jobseeker/${await uid}/profile');
    print(response.statusCode);
    print("the status code is ${response.statusCode}");
    print(response.body);
    if (response.statusCode == 200) {
      print("the response before sending is");
      print(json.decode(response.body));
      // If the server did return a 200 OK response, then parse the JSON.
        return new JobseekerInfo.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<Map<String,dynamic>> resumeGetList(Future<String> uid) async {
    var response = await http.get(
        'https://api.daffychuy.com/api/v1/jobseeker/${await uid}/resumes');
    if (response.statusCode == 200) {
      var _list = json.decode(response.body);
      Map<String,dynamic> returnList = new Map<String,dynamic>();
        for(int i=0;i<(_list["data"]).length;i++){
          returnList[(_list["data"][i]["resume_id"].toString())]=(_list["data"][i]["resume"]);
        }
      // If the server did return a 200 OK response, then parse the JSON.
      return returnList;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<int> profilePostRequest(
      String usertype, String uid, String command, String value, String preference, String rank) async {
    var url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/$command';
    var response = await http.post(url,
        body: {command: value, preference : rank});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
//    Post p_response = Post.fromjson(json.decode(response.body));
    int statusCode = response.statusCode;
    return statusCode;
  }

  Future<int> resumePostRequest(String uid, Map<String, String> list) async {
    print(uid);
    print(list);
    var url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/resumes';
    var response = await http.post(url,
        body: {'resume':json.encode(list)});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
//    Post p_response = Post.fromjson(json.decode(response.body));
    int statusCode = response.statusCode;
    return statusCode;
  }

    void deleteRequest(String uid, String type, String value) async {
    String url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid/$type/$value';
    http.Response response = await http.delete(url);
  }

  void putRequest(String userType, String uid, String command, String change) async {
    //URL for testing.
    if(userType=="jobseeker"){
      String url = 'https://api.daffychuy.com/api/v1/jobseeker/$uid';
      // the makes the PUT request
      http.Response response =
      await http.put(url, body: {command: change});
      print(response.statusCode);
    }
//    else if(userType=="employer"){
//      String url = 'https://api.daffychuy.com/api/v1/employer/$uid';
//      // the makes the PUT request
//      http.Response response =
//      await http.put(url, body: {command: change});
//      print(response.statusCode);
//    }

  }

//  void deleteRequest(String userType, String uid, String command, String value) async {
//
//    if(userType == "jobseeker"){
//      String url = "https://api.daffychuy.com/api/v1/jobseeker/$uid/$command";
//
//      http.Response response = await http.delete(url,headers:{command: value});
//      print("Delete Response code : ${response.statusCode}");
//    }
//  }

  //get request for employer

  Future<Employer> employerGetRequest(Future<String> uid) async {
    var response = await http.get(
        'https://api.daffychuy.com/api/v1/employer/${await uid}');
    print(response.statusCode);
    print("the status code is ${response.statusCode}");
    print(response.body);
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
    var response = await http.post(url,
        body: {'firebaseID': uid, 'email': email, 'name': name});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
//    Post p_response = Post.fromjson(json.decode(response.body));
    int statusCode = response.statusCode;
    return statusCode;
  }

  Future<int> employerPostRequest(
      String uid, String email, String name, String company) async {
    var url = 'https://api.daffychuy.com/api/v1/employer';
    var response = await http.post(url,
        body:{
          'firebaseID': uid,
          'email': email,
          'name': name,
          'company': company
        });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
//    Post p_response = Post.fromjson(json.decode(response.body));
    int statusCode = response.statusCode;
    return statusCode;
  }



//
//  void patchRequest(String letter) async {
//    // URL for testing;
//    String url = 'http://www.mocky.io/v2/5e39ee2f320000cef5ddfdbf';
//
//    // this makes the patch request
//    http.Response response =
//        await http.patch(url, body: json.encode({'message': letter}));
//
//    // the updated post
//    Post p_resonse = Post.fromjson(json.decode(response.body));
//
//    // status code for the result of the function
//    int statusCode = response.statusCode;
//  }
//
//
//// Mock post information from the site
//class Post {
//  final String message = "";
//  //final int name;
//  //final int email;
//
//  Post({message});
//
//  factory Post.fromjson(Map<String, dynamic> json) {
//    return Post(message: json['message']);
//  }
}

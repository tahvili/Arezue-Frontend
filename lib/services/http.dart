import 'dart:async';
import 'dart:convert';
import 'package:arezue/employer/employer.dart';
import 'package:arezue/user.dart';
import 'package:http/http.dart' as http;

class Requests {
  /*
   Standard HTTP requests
   */

  //get request for jobseeker

  Future<User> jobseekerGetRequest(Future<String> uid) async {
    var response = await http.get(
        'https://api.daffychuy.com/api/v1/jobseeker?uid=${await uid}');
    print(response.statusCode);
    print("the status code is ${response.statusCode}");
    print(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return User.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  //get request for employer

  Future<Employer> employerGetRequest(Future<String> uid) async {
    var response = await http.get(
        'https://api.daffychuy.com/api/v1/employer?uid=${await uid}');
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
        body: json.encode({
          'firebaseID': uid,
          'email': email,
          'name': name,
          'company': company
        }));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
//    Post p_response = Post.fromjson(json.decode(response.body));
    int statusCode = response.statusCode;
    return statusCode;
  }

  void putRequest(String letter) async {
    //URL for testing.
    String url = 'http://www.mocky.io/v2/5e39ee2f320000cef5ddfdbf';
    // the makes the PUT request
    http.Response response =
        await http.put(url, body: json.encode({'message': letter}));

    // the updated post, after the request has been made.
    Post p_response = Post.fromjson(json.decode(response.body));

    //the status code of the request.
    int statusCode = response.statusCode;
  }

  void patchRequest(String letter) async {
    // URL for testing;
    String url = 'http://www.mocky.io/v2/5e39ee2f320000cef5ddfdbf';

    // this makes the patch request
    http.Response response =
        await http.patch(url, body: json.encode({'message': letter}));

    // the updated post
    Post p_resonse = Post.fromjson(json.decode(response.body));

    // status code for the result of the function
    int statusCode = response.statusCode;
  }

  void deleteRequest() async {
    String url = 'http://www.mocky.io/v2/5e39ee2f320000cef5ddfdbf';

    http.Response response = await http.delete(url);

    int statusCode = response.statusCode;
  }
}

// Mock post information from the site
class Post {
  final String message = "";
  //final int name;
  //final int email;

  Post({message});

  factory Post.fromjson(Map<String, dynamic> json) {
    return Post(message: json['message']);
  }
}

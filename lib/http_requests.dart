import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Requests{
  /*
   Standard HTTP requests
   */

  Future get_request() async {
    http.Response response =
      await http.get('http://www.mocky.io/v2/5e39ee2f320000cef5ddfdbf');
    Post content = Post.fromjson(json.decode(response.body));
    return content.message;

  }

  void post_request(String letter) async {
    String url = 'http://www.mocky.io/v2/5e39ee2f320000cef5ddfdbf';
    http.Response response  = await http.post(url,
    body: json.encode({'message': letter}));

    Post p_response = Post.fromjson(json.decode(response.body));
    int status_code = response.statusCode;

  }

  void put_request(String letter) async{
    //URL for testing.
    String url = 'http://www.mocky.io/v2/5e39ee2f320000cef5ddfdbf';
    // the makes the PUT request
    http.Response response  = await http.put(url,
        body: json.encode({'message': letter}));

    // the updated post, after the request has been made.
    Post p_response = Post.fromjson(json.decode(response.body));

    //the status code of the request.
    int status_code = response.statusCode;
  }

  void patch_request(String letter) async{

    // URL for testing;
    String url = 'http://www.mocky.io/v2/5e39ee2f320000cef5ddfdbf';

    // this makes the patch request
    http.Response response = await http.patch(url,
        body: json.encode({'message' : letter}));

    // the updated post
    Post p_resonse = Post.fromjson(json.decode(response.body));

    // status code for the result of the function
    int status_code = response.statusCode;

  }

  void delete_request() async{
    String url  =  'http://www.mocky.io/v2/5e39ee2f320000cef5ddfdbf';

    http.Response response = await http.delete(url);

    int status_code = response.statusCode;
  }

}

// Mock post information from the site
class Post{

  final String message = "";
  //final int name;
  //final int email;

  Post({message});

  factory Post.fromjson(Map<String, dynamic> json){
    return Post(message: json['message']);
  }
}
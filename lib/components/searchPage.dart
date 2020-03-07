import 'package:arezue/employer/employer_homePage.dart';
import 'package:arezue/login_page.dart';
import 'package:arezue/services/auth.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:arezue/utils/colors.dart';


class SearchPage extends StatefulWidget{

  SearchPage({this.auth});
  final BaseAuth auth;

  @override
  _SearchPageState createState() => new _SearchPageState();
  }

  class _SearchPageState extends State<SearchPage>{

  Widget createJobForm(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {},
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) => JobFormPage(
//                  auth: widget.auth,
//                  jobId: null,
//                )),
//          );
//        },
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
        color: ArezueColors.outSecondaryColor,
        child: Text('Create a New Job Listing',
            style: TextStyle(color: ArezueColors.outPrimaryColor)),
      ),
    );
  }


  Future<List<Post>> search(String search) async {
    await Future.delayed((Duration(seconds: 2)));
    if (search == 'plumber'){
      return [];
    }
    return List.generate(search.length, (int index){
      return Post(
        "Job Title : $search",
         "Job Description : does job" ,
      );
    });
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ArezueColors.secondaryColor,
        title: const Text('Search')
      ),
      body: SafeArea (
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Post>(
            onSearch: search,
            onItemFound: (Post post, int index){
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.description),
              );
            },
           minimumChars: 1,
           placeHolder: Center(
             child: createJobForm(),
           ),
            emptyWidget: Center(
              child: createJobForm(),
            ),
            hintText: "Search Templates",
            hintStyle: TextStyle(
              color: Colors.grey[100],
            ),
          ),

        ),
      ),
    );
  }
}

class Post {

  final String title;
  final String description;

  Post(this.title, this.description);

}
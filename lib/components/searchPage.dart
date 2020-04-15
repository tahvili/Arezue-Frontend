/// Search page when looking for candidate
///
/// the purpose of this page is to ask for input from client and show a list of resumes based on the search items

import 'dart:math';

import 'package:arezue/jobseeker/resumeView.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/services/http.dart';
import 'package:flutter/material.dart';
import 'package:arezue/utils/colors.dart';

import '../loading.dart';
import 'inputChip.dart';

class SearchPage extends StatefulWidget {
  SearchPage({this.auth, this.uid, this.jobId});
  final BaseAuth auth;
  final String uid;
  final String jobId;
  @override
  _SearchPageState createState() => new _SearchPageState(this.auth);
}

class _SearchPageState extends State<SearchPage> {
  _SearchPageState(this.auth);
  List<String> searchItems = new List<String>();
  List<dynamic> minidata = new List<dynamic>();
  List<Widget> widgetList = new List<Widget>();
  void searchFieldHandler(String text, String command) {
    setState(() {});
  }

  Widget selectResume(
      String resumeID, String name, Map<String, dynamic> data, String uid) {
    // resume selector, which takes them to a page to view the resume
    Random random = new Random();
    int randomNumber = random.nextInt(1000000000) + 100000000;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ResumeView(data: data, resumeName: resumeID, uid: uid)),
          );
        },
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
        color: ArezueColors.outSecondaryColor,
        child: Text("#${uid.substring(0, 8)}${resumeID}",
            style: TextStyle(color: ArezueColors.outPrimaryColor)),
      ),
    );
  }

  Future<int> fetchData() async {
    // fetching data from server
    minidata = await request.searchPostRequest(searchItems);
    widgetList = listWidgets(uid);
    return minidata.length;
  }

  List<Widget> listWidgets(String uid) {
    // inputchip of skills needed for job
    List<Widget> widgetlist = new List<Widget>();
    widgetlist.add(
      InputChipBuilder(
        title: "Candidate's Skill: ",
        fieldType: "text",
        fieldData: searchItems,
        handler: searchFieldHandler,
      ),
    );
    var keys;
    var maps;
    //int counter=0;

    if (minidata.length == 0) {
      // when nothing is searched yet
      widgetlist.add(
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: Text(
              "Start adding some search items by pressing the + button.",
              style: TextStyle(
                color: ArezueColors.outPrimaryColor,
                fontSize: 16,
                fontFamily: 'Arezue',
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
      return widgetlist;
    }

    widgetlist.add(
      Padding(
        // when results are back from server. we count and show the number of candidates
        padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
        child: Text(
          "we found ${minidata.length} candidate(s)!",
          style: TextStyle(
            color: ArezueColors.greyColor,
            fontSize: 14,
            fontFamily: 'Arezue',
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
    for (maps in minidata) {
      widgetlist.add(Container(
          margin:
              const EdgeInsets.only(right: 50, left: 50, bottom: 10, top: 0),
          child: selectResume(maps["resume_id"].toString(),
              maps["resume"]["name"], maps["resume"], maps["uid"])));
      //counter++;
    }

    return widgetlist;
  }

  @override
  void initState() {
    super.initState();
    widgetList = listWidgets(uid);
  }

  final BaseAuth auth;
  Map<String, dynamic> sendList = new Map<String, dynamic>();
  Requests request = new Requests();
  String companyName;
  String uid;

  Widget build(BuildContext context) {
    // the build function for the program
    return FutureBuilder<int>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new Scaffold(
            appBar: AppBar(
                backgroundColor: ArezueColors.secondaryColor,
                title: const Text('Let\'s find a candidate!')),
            body: SafeArea(
              child: ListView(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 50),
                children: widgetList,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          return Loading();
        }
      },
    );
  }
}

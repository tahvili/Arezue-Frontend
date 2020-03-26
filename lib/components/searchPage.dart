import 'package:arezue/employer/employer.dart';
import 'package:arezue/employer/employer_homePage.dart';
import 'package:arezue/employer/jobForm.dart';
import 'package:arezue/employer/jobInformation.dart';
import 'package:arezue/jobseeker/resumeForm.dart';
import 'package:arezue/jobseeker/resumeView.dart';
import 'package:arezue/login_page.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/services/http.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:arezue/utils/colors.dart';

import 'inputChip.dart';

class SearchPage extends StatefulWidget {
  SearchPage({this.auth,this.uid,this.jobId});
  final BaseAuth auth;
  final String uid;
  final String jobId;
  @override
  _SearchPageState createState() => new _SearchPageState(this.auth);
}

class _SearchPageState extends State<SearchPage> {
  _SearchPageState(this.auth);
  List<String> searchItems = new List<String>();
  Map<String,dynamic> minidata = new Map<String,dynamic>();
  List<Widget> widgetList = new List<Widget>();
  void searchFieldHandler(String text, String command){
  }

  Widget selectResume(String resumeID, String Name, Map<String,dynamic> Data, String uid) {
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
                builder: (context) => ResumeView(
                    data: Data,
                    resumeName: Name,
                    uid: "4f6cf401-091a-49b0-bf89-7df29a4ab1f1"
                )),
          );
        },
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
        color: ArezueColors.outSecondaryColor,
        child: Text(Name,
            style: TextStyle(color: ArezueColors.outPrimaryColor)),
      ),
    );
  }

  void FetchData() async {
    minidata = await request.resumeGetList2("4f6cf401-091a-49b0-bf89-7df29a4ab1f1");
    widgetList = listWidgets(uid);
  }

  List<Widget> listWidgets(String uid) {
    List<Widget> widgetlist = new List<Widget>();
    widgetlist.add(InputChipBuilder(
      title: "Candidate's Skill: ",
      fieldType: "text",
      fieldData: searchItems,
      handler: searchFieldHandler,
    ),);
    var keys;
    int counter=0;
    if(minidata==null){
      return widgetlist;
    }
    for(keys in minidata.keys){
      widgetlist.add(Container(margin: const EdgeInsets.only(right: 50, left: 50, bottom: 10, top: 0),child:selectResume(keys, minidata[keys]['name'], minidata[keys], uid)));
      counter++;
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
    FetchData();
    return new Scaffold(
          appBar: AppBar(
              backgroundColor: ArezueColors.secondaryColor,
              title: const Text('Let\'s find a candidate!')),
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 50),
              children:widgetList,
            ),
          ),
        );
  }

}

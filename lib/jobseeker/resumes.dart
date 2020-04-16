import 'package:arezue/jobseeker/resumeView.dart';
/// Resume section's main page
///
/// contains a list of all resumes and have access to edit/remove or add a new resume.

import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/jobseeker/resumeForm.dart';
import 'package:arezue/jobseeker/information.dart';
import 'package:arezue/services/http.dart';
import '../loading.dart';

class ResumePage extends StatefulWidget {
  ResumePage({this.auth});
  final BaseAuth auth;
  @override
  _ResumePageState createState() => new _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  Map<String, dynamic> data;
  Requests request = new Requests();
  Map<String, dynamic> minidata;
  List<String> resumeData;

  Future<JobseekerInfo> fetchData() async {
    // Fetches data from server
    minidata = await request.resumeGetList(widget.auth.currentUser());
    return await request.profileGetRequest(widget.auth.currentUser());
  }

  Widget selectResume(
      String resumeID, String name, Map<String, dynamic> data, String uid) {
    // Resume selector
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),

      child: Row(
        children: <Widget>[
        Expanded(
        flex: 2,
            child: Container(
              margin: const EdgeInsets.only(right: 0, left: 0, bottom: 0, top: 0),
              decoration: new BoxDecoration(
                color: ArezueColors.outSecondaryColor, // border color
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ArezueColors.shadowColor,
                    blurRadius: 0.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      1.0, // horizontal, move right 10
                      1.0, // vertical, move down 10
                    ),
                  ),
                ],
              ),
              child: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResumeView(data: data, resumeName: resumeID, uid: uid, preview:true)),
                );
              },
            ),
          )
        ),
          Expanded(
            flex:6,
            child:RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: () {},
              padding: EdgeInsets.fromLTRB(35, 15, 35, 15),
              color: ArezueColors.outSecondaryColor,
              child:
              Text(name, style: TextStyle(color: ArezueColors.outPrimaryColor)),
            ),
          ),
          Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(right: 0, left: 0, bottom: 0, top: 0),
                decoration: new BoxDecoration(
                  color: ArezueColors.outSecondaryColor, // border color
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ArezueColors.shadowColor,
                      blurRadius: 0.0,
                      spreadRadius: 1.0,
                      offset: Offset(
                        1.0, // horizontal, move right 10
                        1.0, // vertical, move down 10
                      ),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResumeFormPage(
                              auth: widget.auth,
                              resumeId: resumeID,
                              resumeName: name,
                              uid: uid)),
                    );
                  },
                ),
              )
          ),
        ],
      )
    );
  }

  Widget createButton() {
    // Create Resume button
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResumeFormPage(
                  auth: widget.auth,
                  resumeId: null,
                  resumeName: '',
                  uid: null)),
        );
      },
      child: Icon(Icons.add),
      backgroundColor: ArezueColors.secondaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build function of the page
    return FutureBuilder<JobseekerInfo>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: ArezueColors.secondaryColor,
              title: Text('My Resumes'),
              actions: <Widget>[
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.help, color: Colors.white),
                  onPressed: null,
                )
              ],
            ),
            body: bodyContent(snapshot.data.jobseeker.uid),
            floatingActionButton: createButton(),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          return Loading();
        }
      },
    );
  }

  List<Widget> listWidgets(String uid) {
    // makes a list of all resumes

    List<Widget> widgetlist = new List<Widget>();
    var keys;
    for (keys in minidata.keys) {
      widgetlist
          .add(selectResume(keys, minidata[keys]['name'], minidata[keys], uid));
    }
    return widgetlist;
  }

  bodyContent(String uid) {
    // when there isn't any resumes on the account
    List<Widget> list = listWidgets(uid);
    if (list.length == 0) {
      return Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Text(
            "You have no resumes on your account! Press the + button to add a new resume.",
            style: TextStyle(
              color: ArezueColors.outPrimaryColor,
              fontSize: 20,
              fontFamily: 'Arezue',
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Center(
      child: ListView(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
        children: <Widget>[
          Column(
            children: list,
          ),
        ],
      ),
    );
  }
}

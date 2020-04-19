import 'dart:convert';

/// Resume Builder Page
///
/// The purpose of this page is to let the user create/edit/delete a resume and send the data to server

import 'package:arezue/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/jobseeker/information.dart';
import 'package:arezue/components/resumeField.dart';
import '../loading.dart';

class ResumeFormPage extends StatefulWidget {
  @override
  ResumeFormPage({this.auth, this.resumeId, this.resumeName, this.uid});
  final BaseAuth auth;
  final String resumeId;
  final String uid;
  final String resumeName;

  @override
  _ResumeFormPageState createState() => new _ResumeFormPageState();
}

class _ResumeFormPageState extends State<ResumeFormPage> {
  Map<String, dynamic> data;
  Requests request = new Requests();
  Future<JobseekerInfo> uData;
  List<String> dreamCareer = [];
  List<String> dreamCompany = [];
  List<String> skill = [];
  List<String> education = [];
  List<String> experience = [];
  List<String> certification = [];
  var resumeNameController = TextEditingController();
  final regExp = new RegExp(r'(?:\[)?(\[[^\]]*?\](?:,?))(?:\])?');
  bool update = false;

  void updateHandler(String endpoint, List list) {
    if (!((dreamCareer.isEmpty || dreamCareer[0].length==0) && (list.isEmpty || list[0].length==0)) && !listEquals(dreamCareer, list) && endpoint == "/dream_career") {
      update = true;
      dreamCareer = list;
    } else if (!((dreamCompany.isEmpty || dreamCompany[0].length==0) && (list.isEmpty || list[0].length==0)) && !listEquals(dreamCompany, list) &&
        endpoint == "/dream_company") {
      update = true;
      dreamCompany = list;
    } else if (!((skill.isEmpty || skill[0].length==0) && (list.isEmpty || list[0].length==0)) && !listEquals(skill, list) && endpoint == "/skill") {
      update = true;
      skill = list;
    } else if (!((education.isEmpty || education[0].length==0) && (list.isEmpty || list[0].length==0)) && !listEquals(education, list) && endpoint == "/education") {
      update = true;
      education = list;
    } else if (!((experience.isEmpty || experience[0].length==0) && (list.isEmpty || list[0].length==0)) && !listEquals(experience, list) && endpoint == "/exp") {
      update = true;
      experience = list;
    } else if (!((certification.isEmpty || certification[0].length==0) && (list.isEmpty || list[0].length==0)) && !listEquals(certification, list) &&
        endpoint == "/certification") {
      update = true;
      certification = list;
    }
  }

  void _showErrorDialog(String type) {
    // Error Dialog for when there is any error
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Oops!"),
            content: new Text("$type is missing!"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Dismiss")),
            ],
          );
        });
  }

  @override
  void dispose() {
    resumeNameController.dispose();
    super.dispose();
  }

  Future<JobseekerInfo> fetchData() async {
    // Fetching data from server and formatting it
    if (widget.resumeId != null && !update) {
      data = await request.resumeGetRequest(
          "${widget.uid}/resumes/${widget.resumeId}", 'resume_data');
      dreamCareer = (data['resume']['dream_career'])
          .replaceAll(RegExp(r'[\[\]]'), '')
          .split(',');
      dreamCompany = (data['resume']['dream_company'])
          .replaceAll(RegExp(r'[\[\]]'), '')
          .split(',');
      skill = (data['resume']['skill'])
          .replaceAll(RegExp(r'[\[\]]'), '')
          .split(',');
      education = (data['resume']['education'])
          .replaceAll(RegExp(r'[\[\]]'), '')
          .split(',');
      experience = (data['resume']['experience'])
          .replaceAll(RegExp(r'[\[\]]'), '')
          .split(',');
      certification = (data['resume']['certification'])
          .replaceAll(RegExp(r'[\[\]]'), '')
          .split(',');
    }

    return await request.profileGetRequest(await widget.auth.currentUser());
  }

  Widget resumeButton(String title, String endpoint, List<dynamic> original,
      List<dynamic> list) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 100,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResumeField(
                    title: title,
                    endpoint: endpoint,
                    list: list,
                    original: original,
                    handler: updateHandler)),
          );
        },
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
        color: ArezueColors.outSecondaryColor,
        child:
            Text(title, style: TextStyle(color: ArezueColors.outPrimaryColor)),
      ),
    );
  }

  Widget saveButton(String uid, String resumeId) {
    // Saving the resume and sending to server
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 55,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () async {
          if (resumeNameController.text == '') {
            _showErrorDialog("Resume Name");
//          } else if (dreamCareer.length==0 || (dreamCareer.length>0 && dreamCareer[0].length==0)) {
//            _showErrorDialog("Dream Career");
//          } else if (dreamCompany.length==0 || (dreamCompany.length>0 && dreamCompany[0].length==0)) {
//            _showErrorDialog("Dream Company");
          } else if (skill.length == 0 ||
              (skill.length > 0 && skill[0].length == 0)) {
            _showErrorDialog("Skill");
//          }else if (education.length==0 || (education.length>0 && education[0].length==0)) {
//            _showErrorDialog("Education");
//          }else if (experience.length==0 || (experience.length>0 && experience[0].length==0)) {
//            _showErrorDialog("Experiences");
//          }else if (certification.length==0 || (certification.length>0 && certification[0].length==0)) {
//            _showErrorDialog("Certificates");
          } else {
            var finalData = {
              "name": resumeNameController.text,
              "dream_career": dreamCareer.toString().replaceAll(", ", ","),
              "dream_company": dreamCompany.toString().replaceAll(", ", ","),
              "skill": skill.toString().replaceAll(", ", ","),
              "education": education.toString().replaceAll(", ", ","),
              "certification": certification.toString().replaceAll(", ", ","),
              "experience": experience.toString().replaceAll(", ", ","),
            };
            if (resumeId != null) {
              Future<int> result = request.putRequest(
                  "jobseeker/$uid/resumes/$resumeId",
                  "x-www-form-urlencoded",
                  {'resume': json.encode(finalData)},
                  false);
              if ((await result) == 200) {
                Navigator.pop(context);
              }
            } else {
              Future<int> result = request.postRequest(
                  "jobseeker/$uid/resumes", {'resume': json.encode(finalData)});
              if ((await result) == 200) {
                Navigator.pop(context);
              }
            }
          }
        },
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
        color: ArezueColors.secondaryColor,
        child: Text("Save", style: TextStyle(color: ArezueColors.primaryColor)),
      ),
    );
  }

  Widget deleteButton(String uid, String resumeId) {
    // Delete resume
    if (resumeId == null) {
      return SizedBox(
        width: (MediaQuery.of(context).size.width / 2) - 55,
      );
    } else {
      return SizedBox(
        width: (MediaQuery.of(context).size.width / 2) - 55,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () async {
            //List<List<String>> finalData = new List<List<String>>();
            Future<int> result =
                request.deleteRequest("jobseeker", uid, "/resumes/$resumeId");
            if ((await result) == 200) {
              Navigator.pop(context);
            }
          },
          padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
          color: ArezueColors.greyColor,
          child: Text("Delete",
              style: TextStyle(color: ArezueColors.primaryColor)),
        ),
      );
    }
  }

  Widget resumeName() {
    // Reume name input
    return Container(
        padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
        margin: const EdgeInsets.only(right: 50, left: 50, bottom: 20, top: 0),
        //height: 200,
        decoration: BoxDecoration(
          color: ArezueColors.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: ArezueColors.shadowColor,
              blurRadius: 10.0,
              spreadRadius: 5.0,
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),
            ),
          ],
        ),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            Text('Name it:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: resumeNameController,
                onChanged: (text) {
                  update = true;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter something",
                ),
              ),
            ),
          ],
        ));
  }

  List<String> generateListSkills(List<Skill> skills) {
    List<String> skillsList = new List();
    skills.forEach((skill) {
      skillsList.add(skill.skill);
    });
    return skillsList;
  }

  @override
  void initState() {
    super.initState();
    uData = fetchData();
    resumeNameController = TextEditingController(text: widget.resumeName);
  }

  Future<bool> _onWillPop() async {
    if (update) {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('There are unsaved changes!'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Build function for this page
    return FutureBuilder<JobseekerInfo>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new WillPopScope(
              onWillPop: _onWillPop,
              child: GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: ArezueColors.secondaryColor,
                      title: Text('Create/Edit Resume'),
                      actions: <Widget>[
                        IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.help, color: Colors.white),
                          onPressed: null,
                        )
                      ],
                    ),
                    body: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                      child: Column(
                        children: <Widget>[
                          //Make objects of the parent using the custom child widget created.
                          Text(
                            "Build your perfect resume!",
                            style: TextStyle(
                              color: ArezueColors.outPrimaryColor,
                              fontSize: 20,
                              fontFamily: 'Arezue',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          resumeName(),
                          resumeButton(
                              "Choose Your Related Careers",
                              "/dream_career",
                              List<String>.from(snapshot.data.jobseeker
                                  .information.dreamCareer.careers),
                              dreamCareer),
                          SizedBox(height: 5),
                          resumeButton(
                              "Choose Your Dream Company",
                              "/dream_company",
                              List<String>.from(snapshot.data.jobseeker
                                  .information.dreamCompany.companies),
                              dreamCompany),
                          SizedBox(height: 5),
                          resumeButton(
                              "Choose Your Skill Sets",
                              "/skill",
                              generateListSkills(
                                  snapshot.data.jobseeker.information.skills),
                              skill),
                          SizedBox(height: 5),
                          resumeButton(
                              "Choose Your Related Education",
                              "/education",
                              List<dynamic>.from(snapshot
                                  .data.jobseeker.information.education),
                              education),
                          SizedBox(height: 5),
                          resumeButton(
                              "Choose Your Related Experiences",
                              "/exp",
                              List<dynamic>.from(snapshot
                                  .data.jobseeker.information.experience),
                              experience),
                          SizedBox(height: 5),
                          resumeButton(
                              "Choose Your Related Certificates",
                              "/certification",
                              List<dynamic>.from(snapshot
                                  .data.jobseeker.information.certification),
                              certification),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              deleteButton(
                                  snapshot.data.jobseeker.uid, widget.resumeId),
                              SizedBox(width: 10),
                              saveButton(
                                  snapshot.data.jobseeker.uid, widget.resumeId),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )));
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          return Loading();
        }
      },
    );
  }
}

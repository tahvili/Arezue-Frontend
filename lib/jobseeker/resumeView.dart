/// Viewing Individual Resumes
///
/// The purpose of this page is to open up a chosen resume and show it's content.
/// This page is accessed by candidate search only.

import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/jobseeker/information.dart';
import '../loading.dart';

class ResumeView extends StatefulWidget {
  @override
  ResumeView({this.data, this.resumeName, this.uid, this.preview});
  final Map<String, dynamic> data;
  final String uid;
  final String resumeName;
  final bool preview;

  @override
  _ResumeView createState() => new _ResumeView();
}

class _ResumeView extends State<ResumeView> {
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

  Future<JobseekerInfo> fetchData() async {
    return await request.profileGetRequest(widget.uid);
  }

  @override
  void initState() {
    super.initState();
    uData = fetchData();
  }

  Function _buttonPress() {
    if (widget.preview) {
      return null;
    } else {
      return () {};
    }
  }

  @override
  Widget build(BuildContext context) {
    // the build function of the page
    return FutureBuilder<JobseekerInfo>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: ArezueColors.secondaryColor,
              title: Text("#${widget.uid.substring(0, 8)}${widget.resumeName}"),
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
              padding: EdgeInsets.fromLTRB(0, 50, 0, 40),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    margin: const EdgeInsets.only(
                        right: 50, left: 50, bottom: 20, top: 0),
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
                            0.0,
                            0.0,
                          ),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Wrap(
                          // Acceptance Wage
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 8, 12, 12),
                              child: Text(
                                  "\$" +
                                      snapshot.data.jobseeker.information
                                          .acceptanceWage
                                          .toString(),
                                  style: TextStyle(
                                    color: ArezueColors.greyColor,
                                    fontSize: 24,
                                    fontFamily: 'Arezue',
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                            RaisedButton(
                              // Request Interview Button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              onPressed: _buttonPress(),
                              padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
                              color: ArezueColors.secondaryColor,
                              child: Text("REQUEST INTERVIEW",
                                  style: TextStyle(
                                      color: ArezueColors.primaryColor)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                      // Experience Tab
                      padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                      margin: const EdgeInsets.only(
                          right: 50, left: 50, bottom: 20, top: 0),
                      //height: 200,
                      decoration: BoxDecoration(
                        color: ArezueColors.secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: ArezueColors.shadowColor,
                            blurRadius: 10.0,
                            spreadRadius: 5.0,
                            offset: Offset(
                              0.0,
                              0.0,
                            ),
                          ),
                        ],
                      ),
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "My Experiences",
                        style: TextStyle(
                          color: ArezueColors.primaryColor,
                        ),
                      )),
                  Column(
                    // Actual list of experiences
                    children: experienceList(
                        (widget.data["experience"])
                            .toString()
                            .replaceAll(RegExp(r'[\[\]]'), '')
                            .split(','),
                        snapshot.data.jobseeker.information.experience,
                        MediaQuery.of(context).size.width),
                  ),
                  Column(
                    // Skills list
                    children: skillList(
                        (widget.data["skill"])
                            .toString()
                            .replaceAll(RegExp(r'[\[\]]'), '')
                            .split(','),
                        MediaQuery.of(context).size.width),
                  ),
                  Container(
                      // Education Tab
                      padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                      margin: const EdgeInsets.only(
                          right: 50, left: 50, bottom: 20, top: 0),
                      //height: 200,
                      decoration: BoxDecoration(
                        color: ArezueColors.secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: ArezueColors.shadowColor,
                            blurRadius: 10.0,
                            spreadRadius: 5.0,
                            offset: Offset(
                              0.0,
                              0.0,
                            ),
                          ),
                        ],
                      ),
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "My Education Background",
                        style: TextStyle(
                          color: ArezueColors.primaryColor,
                        ),
                      )),
                  Column(
                    // Actual education items
                    children: educationList(
                        (widget.data["education"])
                            .toString()
                            .replaceAll(RegExp(r'[\[\]]'), '')
                            .split(','),
                        snapshot.data.jobseeker.information.education,
                        MediaQuery.of(context).size.width),
                  ),
                  Container(
                      // Certificates Tab
                      padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                      margin: const EdgeInsets.only(
                          right: 50, left: 50, bottom: 20, top: 0),
                      //height: 200,
                      decoration: BoxDecoration(
                        color: ArezueColors.secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: ArezueColors.shadowColor,
                            blurRadius: 10.0,
                            spreadRadius: 5.0,
                            offset: Offset(
                              0.0,
                              0.0,
                            ),
                          ),
                        ],
                      ),
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "My Certificates",
                        style: TextStyle(
                          color: ArezueColors.primaryColor,
                        ),
                      )),
                  Column(
                    // Actual certificates items
                    children: certificateList(
                        (widget.data["certification"])
                            .toString()
                            .replaceAll(RegExp(r'[\[\]]'), '')
                            .split(','),
                        snapshot.data.jobseeker.information.certification,
                        MediaQuery.of(context).size.width),
                  ),
                ],
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

List<Widget> skillList(List<String> list, double width) {
  // make skills list
  List<Widget> widgetList = new List();
  String minilist = "";
  for (int i = 0; i < list.length; i++) {
    minilist += (list[i] + "\n");
  }
  widgetList.add(Container(
      padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
      margin: const EdgeInsets.only(right: 50, left: 50, bottom: 0, top: 0),
      //height: 200,
      decoration: BoxDecoration(
        color: ArezueColors.secondaryColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: ArezueColors.shadowColor,
            blurRadius: 10.0,
            spreadRadius: 5.0,
            offset: Offset(
              0.0,
              0.0,
            ),
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
      width: width,
      child: Text(
        "My Skills",
        style: TextStyle(
          color: ArezueColors.primaryColor,
        ),
      )));

  widgetList.add(Container(
      padding: EdgeInsets.fromLTRB(25, 25, 25, 10),
      margin: const EdgeInsets.only(right: 50, left: 50, bottom: 20, top: 0),
      //height: 200,
      decoration: BoxDecoration(
        color: ArezueColors.primaryColor,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: ArezueColors.shadowColor,
            blurRadius: 10.0,
            spreadRadius: 5.0,
            offset: Offset(
              0.0,
              0.0,
            ),
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
      width: width,
      child: Text(minilist)));

  return widgetList;
}

List<Widget> experienceList(
    List<String> list, List<Experience> experience, double width) {
  List<Widget> widgetList = new List();
  if (list[0].length == 0) {
    widgetList.add(Padding(
        padding: EdgeInsets.fromLTRB(25, 10, 25, 25),
        child: Text("I don't have any relevent experiences")));
    return widgetList;
  }
  // make experience list
  experience.forEach((experience) {
    for (int i = 0; i < list.length; i++) {
      if (list[i] == experience.expId) {
        var contain = Container(
            padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
            margin:
                const EdgeInsets.only(right: 50, left: 50, bottom: 20, top: 0),
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
                    0.0,
                    0.0,
                  ),
                ),
              ],
            ),
            alignment: Alignment.centerLeft,
            width: width,
            child: Text(experience.title +
                "\n" +
                experience.startDate +
                " - " +
                experience.endDate +
                "\n" +
                experience.description));

        widgetList.add(contain);
        break;
      }
    }
  });
  return widgetList;
}

List<Widget> educationList(
    List<String> list, List<Education> education, double width) {
  // make education list
  List<Widget> widgetList = new List();
  if (list[0].length == 0) {
    widgetList.add(Padding(
        padding: EdgeInsets.fromLTRB(25, 10, 25, 25),
        child: Text("I don't have any relevent educations")));
    return widgetList;
  }
  education.forEach((education) {
    for (int i = 0; i < list.length; i++) {
      if (list[i] == education.edId) {
        var contain = Container(
            padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
            margin:
                const EdgeInsets.only(right: 50, left: 50, bottom: 20, top: 0),
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
                    0.0,
                    0.0,
                  ),
                ),
              ],
            ),
            alignment: Alignment.centerLeft,
            width: width,
            child: Text(education.program +
                "\n" +
                education.startDate +
                " - " +
                education.gradDate +
                "\n" +
                education.schoolName));

        widgetList.add(contain);
        break;
      }
    }
  });
  return widgetList;
}

List<Widget> certificateList(
    List<String> list, List<Certification> certification, double width) {
  // make certificates list
  List<Widget> widgetList = new List();
  if (list[0].length == 0) {
    widgetList.add(Padding(
        padding: EdgeInsets.fromLTRB(25, 10, 25, 25),
        child: Text("I don't have any relevent certificates")));
    return widgetList;
  }
  certification.forEach((certification) {
    for (int i = 0; i < list.length; i++) {
      if (list[i] == certification.cId) {
        var contain = Container(
            padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
            margin:
                const EdgeInsets.only(right: 50, left: 50, bottom: 20, top: 0),
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
                    0.0,
                    0.0,
                  ),
                ),
              ],
            ),
            alignment: Alignment.centerLeft,
            width: width,
            child: Text(certification.name +
                "\n" +
                certification.startDate +
                " - " +
                certification.endDate +
                "\n" +
                certification.issuer));

        widgetList.add(contain);
        break;
      }
    }
  });
  return widgetList;
}

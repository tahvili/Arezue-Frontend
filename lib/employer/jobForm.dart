/// Job Creation Page
///
/// on this page the employer can create/edit/delete a job that can be used to find candidates later on in search.

import 'dart:ui';
import 'package:arezue/components/textField2.dart';
import 'package:arezue/components/textfield.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';

class JobForm extends StatefulWidget {
  //Constructor of the child widget
  @override
  JobForm(
      {this.title,
      this.uid,
      this.auth,
      this.companyName,
      this.isNew,
      this.jobId,
      this.objectList});

  final String uid;
  final bool isNew;
  final String jobId;
  final String companyName;
  final BaseAuth auth;
  final String title;
  final Map<String, dynamic> objectList;

  @override
  State<StatefulWidget> createState() {
    return _JobFormState(
        title: this.title,
        isNew: this.isNew,
        companyName: this.companyName,
        uid: this.uid,
        auth: this.auth,
        jobId: this.jobId,
        objectList: this.objectList);
  }
}

class _JobFormState extends State<JobForm> {
  _JobFormState(
      {this.uid,
      this.title,
      this.companyName,
      this.auth,
      this.objectList,
      this.jobId,
      this.isNew});

  final String uid;
  final String companyName;
  final String title;
  final String jobId;
  final bool isNew;
  final BaseAuth auth;
  Map<String, dynamic> objects;
  Map<String, dynamic> objectList;
  bool isFieldEmpty;
  Requests request = new Requests();
  Map<String, String> finalEditList = new Map<String, String>();
  Map<String, TextEditingController> controllers = new Map();

  @override
  initState() {
    objects = objectList;
    this.isFieldEmpty = false;
    disposer();
    controllers = new Map();
    objectList.forEach((key, value) {
      controllers[key] = new TextEditingController(text: value);
    });
    super.initState();
  }

  void disposer() {
    controllers.forEach((k, v) {
      controllers[k].dispose();
    });
  }

  void submitHandler() async {
    // saves and stores to database
    controllers.forEach((k, v) {
      //print("$k:${v.toString().substring(21,27)}   ${v.text}");
      if (v.text == "") {
        isFieldEmpty = true;
      }
      objectList[k] = v.text;
    });
//    objectList.forEach((k, v) {
//      if (v == "") {
//        this.isFieldEmpty = true;
//      }
//    });
    if (isFieldEmpty) {
      _showPasswordResetSentDialog();
      this.isFieldEmpty =
          false; //sets to default, assuming everything is perfect.
    } else {
      List<String> arr = new List<String>();
      for (var keys in objectList.keys) {
        var element = objectList[keys].toString();
        arr.add(element);
      }
      if (isNew == true) {
        Map<String, String> map = new Map();
        map = {
          'company_name': this.companyName.toString(),
          'title': arr[0].toString(),
          'wage': arr[1].toString(),
          'position': arr[0].toString(),
          'hours': arr[2].toString(),
          'location': arr[3].toString(),
          'description': arr[5].toString(),
          'status': arr[4].toString(),
          'max_candidate': arr[6].toString()
        };

        if (await (request.postRequest("employer/${this.uid}/jobs", map)) ==
            200) {
          Navigator.pop(context);
        }
      } else {
        fillData(arr);
        if (await (request.putRequest("employer/$uid/jobs/${this.jobId}",
                "json", this.finalEditList, true)) ==
            200) {
          Navigator.pop(context);
        }
      }
    }
  }

  void fillData(List<String> arr) {
    // form storage space before sending to server
    finalEditList['title'] = arr[0].toString();
    finalEditList['position'] = arr[0].toString();
    finalEditList['wage'] = arr[1].toString();
    finalEditList['hours'] = arr[2].toString();
    finalEditList['location'] = arr[3].toString();
    finalEditList['status'] = arr[4].toString();
    finalEditList['description'] = arr[5].toString();
    finalEditList['max_candidate'] = arr[6].toString();
  }

  void formHandler(key, value) {
    // form storage space before sending to server
//    setState(() {
//      objectList[key] = value;
//    });
//    if (!(this.isNew)) {
//      if (key == "Title") {
//        finalEditList['title'] = value.toString();
//      } else if (key == "Wage") {
//        finalEditList['wage'] = value.toString();
//      } else if (key == "Hours") {
//        finalEditList['hours'] = value.toString();
//      } else if (key == "Location") {
//        this.finalEditList['location'] = value.toString();
//      } else if (key == "Status") {
//        finalEditList['status'] = value.toString();
//      } else if (key == "Description") {
//        finalEditList['description'] = value.toString();
//      } else if (key == "Maximum Candidates") {
//        finalEditList['max_candidate'] = value.toString();
//      }
//    }
//    setState(() {});
  }

  List<Widget> listWidgets(Map<String, dynamic> map) {
    // Text field for regular inputs
    List<Widget> list = new List<Widget>();
    objectList.forEach((key, value) {
      if (key == "Wage" || key == "Hours") {
        list.add(MyTextField(
            title: key,
            fieldId: key,
            fieldType: "numeric",
            fieldData: value.toString(),
            handler: formHandler,
            controller: controllers[key]));
      } else {
        list.add(MyTextField2(
            title: key,
            fieldData: value.toString(),
            controller: controllers[key]));
      }
    });
    return list;
  }

  bool update() {
    for (var key in objectList.keys) {
      if (objects[key] != controllers[key].text) {
        return true;
      }
    }
    return false;
  }

  Future<bool> _onWillPop() async {
    if (update()) {
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

  Widget build(BuildContext context) {
    //controller.text = this.fieldData as String;
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
                title: Text(title),
                actions: <Widget>[
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.help, color: Colors.white),
                    onPressed: null,
                  )
                ],
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        //width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: listWidgets(this.objectList),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          deleteButton(),
                          SizedBox(width: 10),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () {
                              submitHandler();
                            },
                            padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
                            color: ArezueColors.secondaryColor,
                            child: Text("Save",
                                style: TextStyle(
                                    color: ArezueColors.primaryColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget deleteButton() {
    // Delete button to remove job
    return (this.isNew == true)
        ? SizedBox(
            width: 1,
          )
        : RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () async {
              if (await (request.deleteRequest(
                      "employer", uid, "/jobs/${this.jobId}")) ==
                  200) {
                Navigator.pop(context);
              } else {
                _showPasswordResetSentDialog();
              }
            },
            padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
            color: ArezueColors.greyColor,
            child: Text("Delete",
                style: TextStyle(color: ArezueColors.primaryColor)),
          );
  }

  void _showPasswordResetSentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Oops!"),
            content: new Text("Please do not leave any fields empty."),
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
}

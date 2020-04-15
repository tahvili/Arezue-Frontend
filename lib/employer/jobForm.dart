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
  final Map<String, dynamic> objectList;
  bool isFieldEmpty;
  Requests request = new Requests();
  Map<String, String> finalEditList = new Map<String, String>();
  Map<String, TextEditingController> controllers = new Map();

  @override
  initState() {
    this.isFieldEmpty = false;
    super.initState();
  }

  void submitHandler() async {
    // saves and stores to database
    controllers.forEach((k, v) {
      if (v.text == "") {
        isFieldEmpty = true;
      }
      objectList[k] = v.text;
    });
    objectList.forEach((k, v) {
      if (v == "") {
        this.isFieldEmpty = true;
      }
    });
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
        if (await (request.jobPostRequest(this.uid, this.companyName, arr)) ==
            200) {
          Navigator.pop(context);
        }
      } else {
        fillData(arr);
        if (await (request.jobPutRequest(
                uid, this.jobId, this.finalEditList)) ==
            200) {
          Navigator.pop(context);
        }
      }
    }
  }

  void fillData(List<String> arr) {
    // form storage space before sending to server
    finalEditList['title'] = arr[0].toString();
    finalEditList['wage'] = arr[1].toString();
    finalEditList['hours'] = arr[2].toString();
    finalEditList['location'] = arr[3].toString();
    finalEditList['status'] = arr[4].toString();
    finalEditList['description'] = arr[5].toString();
    finalEditList['max_candidate'] = arr[6].toString();
  }

  void formHandler(key, value) {
    // form storage space before sending to server
    setState(() {
      objectList[key] = value;
    });
    if (!(this.isNew)) {
      if (key == "Title") {
        finalEditList['title'] = value.toString();
      } else if (key == "Wage") {
        finalEditList['wage'] = value.toString();
      } else if (key == "Hours") {
        finalEditList['hours'] = value.toString();
      } else if (key == "Location") {
        this.finalEditList['location'] = value.toString();
      } else if (key == "Status") {
        finalEditList['status'] = value.toString();
      } else if (key == "Description") {
        finalEditList['description'] = value.toString();
      } else if (key == "Maximum Candidates") {
        finalEditList['max_candidate'] = value.toString();
      }
    }
    setState(() {});
  }

  List<Widget> listWidgets(Map<String, dynamic> map) {
    // Text field for regular inputs
    List<Widget> list = new List<Widget>();
    map.forEach((key, value) {
      controllers[key] = new TextEditingController();
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

  Widget build(BuildContext context) {
    //controller.text = this.fieldData as String;
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Container(
              //width: MediaQuery.of(context).size.width,
              child: Column(
                children: listWidgets(this.objectList),
              ),
            ),
            RaisedButton(
              onPressed: () {
                submitHandler();
              },
              child: Text("Submit",
                  style: TextStyle(color: ArezueColors.outPrimaryColor)),
            ),
            deleteButton(),
          ],
        ),
      ),
    );
  }

  Widget deleteButton() {
    // Delete button to remove job
    return (this.isNew == true)
        ? SizedBox(
            width: 1,
          )
        : RaisedButton(
            onPressed: () async {
              if (await (request.jobDeleteRequest(uid, this.jobId)) == 200) {
                Navigator.pop(context);
              } else {
                _showPasswordResetSentDialog();
              }
            },
            child: Text("Delete",
                style: TextStyle(color: ArezueColors.outPrimaryColor)),
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

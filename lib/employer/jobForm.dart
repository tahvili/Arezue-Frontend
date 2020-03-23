import 'dart:ui';
import 'package:arezue/components/searchTextField.dart';
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
  bool isNew;
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
  bool isNew;
  final BaseAuth auth;
  final Map<String, dynamic> objectList;
  bool isFieldEmpty;
  Requests request = new Requests();
  Map<String, String> finalEditList = new Map<String, String>();

  @override
  initState() {
    this.isFieldEmpty = false;
    super.initState();
  }

  void submitHandler() async {
    objectList.forEach((k, v) {
      if (v == "") {
        this.isFieldEmpty = true;
      }
    });
    if (isFieldEmpty) {
      _showPasswordResetSentDialog();
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
        if (await (request.jobPutRequest(
                uid, this.jobId, this.finalEditList)) ==
            200) {
          Navigator.pop(context);
        }
      }
    }
  }

  void formHandler(key, value) {
    setState(() {
      objectList[key] = value;
    });
    if (!(this.isNew)) {
      if (key == "Title") {
        finalEditList['title'] = value.toString();
      } else if (key == "Position") {
        finalEditList['position'] = value.toString();
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
    List<Widget> list = new List<Widget>();
    map.forEach((key, value) {
      if (key == "Wage" || key == "Hours") {
        list.add(MyTextField(
            title: key,
            fieldId: key,
            fieldType: "numeric",
            fieldData: value.toString(),
            handler: formHandler));
      } else if (key == "Position") {
        list.add(MySearchTextField(
            title: "Enter the Position",
            fieldId: key,
            handler: formHandler,
            skill: value.toString()));
      } else {
        list.add(MyTextField2(
            title: key, fieldData: value.toString(), handler: formHandler));
      }
    });
    return list;
  }

  // The actual object itself.
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

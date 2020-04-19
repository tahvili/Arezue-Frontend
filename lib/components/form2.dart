/// Custom form used for education section

import 'dart:ui';
import 'package:arezue/components/datePicker.dart';
import 'package:arezue/components/textField2.dart';
import 'package:arezue/jobseeker/information.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';

class FormPage2 extends StatefulWidget {
  //Constructor of the child widget
  @override
  FormPage2(
      {this.title,
      this.uid,
      this.id,
      this.fieldId,
      this.handler,
      this.objectList,
      this.isNew});

  final String uid;
  final String id;
  final String title;
  final String fieldId;
  final String isNew;
  final Function handler;
  Map<String, dynamic> objectList;

  @override
  State<StatefulWidget> createState() {
    return _FormPageState2(
        title: this.title,
        uid: this.uid,
        id: this.id,
        fieldId: this.fieldId,
        handler: this.handler,
        objectList: this.objectList,
        isNew: this.isNew);
  }
}

class _FormPageState2 extends State<FormPage2> {
  _FormPageState2(
      {this.uid,
      this.title,
      this.id,
      this.fieldId,
      this.handler,
      this.objectList,
      this.isNew});

  final String uid;
  final String id;
  final String title;
  final String fieldId;
  final String isNew;
  Function handler;
  Map<String, dynamic> objectList;
  Map<String, TextEditingController> controllers = new Map();
  Requests request = new Requests();

  bool isFieldEmpty;

  @override
  initState() {
    super.initState();
    isFieldEmpty = false;

    /* TODO: NEW ISSUES
      if isNew == "false"
        make_get_request to using the id to update the fields
        or
        after modifying when the put request goes through update the field data in the parent
        by potentially calling handele(.., ..)
    */
  }

  void submitHandler() async {
    controllers.forEach((k, v) {
      if (v.text == "") {
        isFieldEmpty = true;
      }
      objectList[k] = v.text;
    });
    objectList.forEach((k, v) {
      if (v == "") {
        isFieldEmpty = true;
      }
    });
    if (isFieldEmpty) {
      _showPasswordResetSentDialog();
      this.isFieldEmpty =
          false; //sets to default, assuming everything is perfect.
    } else {
      String firstVal, secondVal, startDate, endDate;
      int i = 0;
      for (var keys in objectList.keys) {
        if (i == 0) {
          firstVal = objectList[keys];
          i++;
        } else if (i == 1) {
          startDate = objectList[keys];
          i++;
        } else if (i == 2) {
          endDate = objectList[keys];
          i++;
        } else if (i == 3) {
          secondVal = objectList[keys];
          i++;
        }
      }
      if (isNew == "true") {
        Map<String, dynamic> postResponse =
            await request.profileEdExCertPostRequest(
                uid, fieldId, firstVal, startDate, endDate, secondVal);
        if (postResponse["statusCode"] == 200) {
          if (fieldId == "education") {
            Education ed = new Education();
            ed.edId = postResponse["body"]["ed_id"].toString();
            ed.schoolName = firstVal;
            ed.program = secondVal;
            ed.startDate = startDate;
            ed.gradDate = endDate;
            handler(ed, "add");
          } else if (fieldId == "experience") {
            Experience exp = new Experience();
            // ###There is a bug in the response value of experience's post response body.###
            exp.expId = postResponse["body"]["exp_id"].toString();
            exp.description = secondVal;
            exp.title = firstVal;
            exp.startDate = startDate;
            exp.endDate = endDate;
            handler(exp, "add");
          } else {
            Certification cert = new Certification();
            cert.cId = postResponse["body"]["c_id"].toString();
            cert.name = firstVal;
            cert.startDate = startDate;
            cert.endDate = endDate;
            cert.issuer = secondVal;
            handler(cert, "add");
          }
          Navigator.pop(context);
        } else {
          print("Request Error");
        }
      } else {
        //make a put request here
        Map<String, String> map = new Map();
        String endpoint;
        if (this.fieldId == "education") {
          map = {
            'ed_id': id,
            'school_name': firstVal,
            'start_date': startDate,
            'grad_date': endDate,
            'program': secondVal
          };
          endpoint = "jobseeker/$uid/education";
        } else if (this.fieldId == "experience") {
          map = {
            'exp_id': id,
            'title': firstVal,
            'start_date': startDate,
            'end_date': endDate,
            'description': secondVal
          };
          endpoint = "jobseeker/$uid/exp";
        } else {
          map = {
            'c_id': id,
            'cert_name': firstVal,
            'start_date': startDate,
            'end_date': endDate,
            'issuer': secondVal
          };
          endpoint = "jobseeker/$uid/certification";
        }
        if (await (request.putRequest(endpoint, "json", map, true)) == 200) {
          handler([firstVal, startDate, endDate, secondVal], id);
          Navigator.pop(context);
        }
      }
    }
  }

  List<Widget> listWidgets(Map<String, dynamic> map) {
    List<Widget> list = new List<Widget>();
    map.forEach((key, value) {
      controllers[key] = new TextEditingController(text: value);
      if (key == "Start Date" || key == "End Date") {
        list.add(DatePickerField(key, value.toString(), controllers[key]));
      } else {
        list.add(MyTextField2(
            title: key,
            fieldData: value.toString(),
            controller: controllers[key]));
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
                        style: TextStyle(color: ArezueColors.primaryColor)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget deleteButton() {
    return (isNew == "true")
        ? SizedBox(
            width: 1,
          )
        : RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () async {
              if (this.fieldId == "experience") {
                if (await (request.deleteRequest(
                        "jobseeker", this.uid, "exp/${this.id}")) ==
                    200) {
                  Navigator.pop(context);
                  handler(this.id, "delete");
                } else {
                  _showPasswordResetSentDialog();
                }
              } else {
                if (await (request.deleteRequest(
                        "jobseeker", this.uid, "${this.fieldId}/${this.id}")) ==
                    200) {
                  Navigator.pop(context);
                  handler(this.id, "delete");
                } else {
                  _showPasswordResetSentDialog();
                }
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

import 'dart:ui';
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
  Requests request = new Requests();

  bool isFieldEmpty;

  @override
  initState() {
    super.initState();
    isFieldEmpty = false;
  }

  void submitHandler() async {
    objectList.forEach((k, v) {
      if (v == "") {
        isFieldEmpty = true;
      }
    });
    if (isFieldEmpty) {
      _showPasswordResetSentDialog();
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
        Map<String, dynamic> postResponse = await request.profileEdExCertPostRequest(
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
            // exp.expId = postResponse["body"]["exp_id"].toString();
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
        if (await (request.profileEdExCertPutRequest(this.fieldId, uid, id,
                firstVal, startDate, endDate, secondVal)) ==
            200) {
          Navigator.pop(context);
          handler([firstVal, startDate, endDate, secondVal], id);
        }
      }
    }
  }

  void formHandler(key, value) {
    setState(() {
      print("key is $key and value is $value");
      objectList[key] = value;
    });
  }

  List<Widget> listWidgets(Map<String, dynamic> map) {
    List<Widget> list = new List<Widget>();
    map.forEach((key, value) {
      list.add(MyTextField2(
          title: key, fieldData: value.toString(), handler: formHandler));
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
    return (isNew == "true")
        ? SizedBox(
            width: 1,
          )
        : RaisedButton(
            onPressed: () async {
              print(this.id.toString() + " " + uid.toString());
              if (await (request.edExCertDeleteRequest(
                      this.fieldId, uid, this.id)) ==
                  200) {
                Navigator.pop(context);
                handler(this.id, "delete");
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

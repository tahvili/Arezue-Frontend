/// Custom form used for skills in profile section

import 'dart:ui';
import 'package:arezue/components/radioButton.dart';
import 'package:arezue/components/searchTextField.dart';
import 'package:arezue/components/slider.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  //Constructor of the child widget
  @override
  FormPage({
    @required this.title,
    this.skill,
    this.numExperience,
    this.numExpertise,
    this.uid,
    this.handler,
    this.fieldId,
  });

  final String title;
  final String uid;
  final String fieldId;
  Function handler;

  String skill;
  int numExperience;
  int numExpertise;

  @override
  State<StatefulWidget> createState() {
    return _FormPageState(
        title: this.title,
        handler: this.handler,
        uid: this.uid,
        fieldId: this.fieldId,
        skill: this.skill,
        numExpertise: this.numExpertise,
        numExperience: this.numExperience);
  }
}

class _FormPageState extends State<FormPage> {
  _FormPageState(
      {@required this.title,
      this.handler,
      this.uid,
      this.fieldId,
      this.skill,
      this.numExperience,
      this.numExpertise});

  final String
      title; // this goes before the textfield, i.e. what textfield is this.
  Function
      handler; // the parent handler function that updates the parent state, this is passed from the parent.
  final String uid;
  final String fieldId;

  bool flag;

  String skill;
  int numExperience;
  int numExpertise;

  String oldSkill;

  Requests request = new Requests();

  @override
  initState() {
    super.initState();
    if (this.skill == null) {
      flag = false;
    } else {
      flag = true;
      this.oldSkill = skill;
    }
  }

  void submitHandler(preference) async {
    if (this.skill == null){
      _showPasswordResetSentDialog();
    }else {
      if (flag == true) {
        if (await (request.profileSkillPutRequest(
            uid, oldSkill, skill, '$numExperience', '$numExpertise')) ==
            200) {
          handler(oldSkill, "edit");
          handler(skill, "add");
          Navigator.pop(context);
        }else{
          handler(skill, "error");
          Navigator.pop(context);
        }
      } else {
        if (await (request.postRequest("jobseeker/$uid/skill",
            {'skill' : skill, 'level' : '$numExpertise', 'years' : '$numExperience'}))
            == 200) {
          handler(skill, "add");
          Navigator.pop(context);
        }else{
          handler(skill, "error");
          Navigator.pop(context);
        }
      }
    }
  }

  void _showPasswordResetSentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Oops!"),
            content: new Text("Please select a skill to be added!"),
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

  void formHandler(value, String command) {
    if (command == "skill") {
      setState(() {
        skill = value;
      });
    } else if (command == "experience") {
      setState(() {
        numExperience = value;
      });
    } else {
      setState(() {
        numExpertise = value;
      });
    }
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
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Container(
            //width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 35,
                ),
                MySearchTextField(title: "Skills", skill: this.skill, handler: formHandler, uid: this.uid),
                SliderWidget(
                    numExperience: this.numExperience, handler: formHandler),
                RadioWidget(numExpertise: this.numExpertise, handler: formHandler),
                RaisedButton(
                  onPressed: () {
                    submitHandler('ranking');
                  },
                  child: Text("Submit",
                      style: TextStyle(color: ArezueColors.outPrimaryColor)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

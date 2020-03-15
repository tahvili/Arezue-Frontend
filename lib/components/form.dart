import 'dart:ui';
import 'package:arezue/components/radioButton.dart';
import 'package:arezue/components/searchTextField.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  //Constructor of the child widget
  @override
  FormPage(
      {@required this.title,
        this.uid,
        this.handler,
        this.fieldId,
      });


  final String
  title;
  final String uid;
  final String fieldId;
  Function handler;


  @override
  State<StatefulWidget> createState() {
    return _FormPageState(title: this.title, handler:  this.handler, uid: this.uid,
    fieldId: this.fieldId);
  }
  }

class _FormPageState extends State<FormPage> {
  _FormPageState({
      @required this.title,
      this.handler, this.uid, this.fieldId});

  final String
  title; // this goes before the textfield, i.e. what textfield is this.
  Function
  handler; // the parent handler function that updates the parent state, this is passed from the parent.
  final String uid;
  final String fieldId;
  Requests request = new Requests();

  int numExperience;
  int numExpertise;
  String skill;

  @override
  initState(){
    super.initState();
  }

  void submitHandler(preference){
    //make the post request for skill here
    int result = numExpertise + numExperience;
    request.profilePostRequest('jobseeker', uid, this.fieldId, this.skill,
        preference, '$result');

    handler(skill, "add");
  }

  void formHandler(value, String command){
    if(command == "skill"){
      setState(() {
        skill = value;
      });
    }else if(command == "experience"){
      setState(() {
        numExperience = value;
      });
    }else{
      numExpertise = value;
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
      body: Container(
        child: Column(
          children: <Widget>[
            MySearchTextField(handler : formHandler),
            RadioWidget(handler: formHandler),
            RaisedButton(
              onPressed: (){
                submitHandler('ranking');
              },
              child: Text(
                  "Submit", style: TextStyle(color: ArezueColors.outPrimaryColor)
              ),
            ),
          ],
        ),
      ),
    );
  }

}

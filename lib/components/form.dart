import 'dart:ui';
import 'package:arezue/components/radioButton.dart';
import 'package:arezue/components/searchTextField.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  //Constructor of the child widget
  @override
  FormPage(
      {@required this.title,
        this.handler
      });


  final String
  title;
  Function handler;

  @override
  State<StatefulWidget> createState() {
    return _FormPageState(title: this.title, handler:  this.handler);
  }
  }

class _FormPageState extends State<FormPage> {
  _FormPageState({
      @required this.title,
      this.handler});

  final String
  title; // this goes before the textfield, i.e. what textfield is this.
  Function
  handler; // the parent handler function that updates the parent state, this is passed from the parent.

  int numExperience;
  int numExpertise;
  String skill;

  @override
  initState(){
    super.initState();
  }

  void submitHandler(){
    //make the post request for skill here
    handler();
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


  // The actual object iself.
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
                submitHandler();
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

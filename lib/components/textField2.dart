/// Custom text field that notifies the form about it's content after pressing the save button

import 'dart:ui';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/http.dart';

class MyTextField2 extends StatefulWidget {
  MyTextField2(
      {@required this.title,
      this.uid,
      this.skill,
      this.fieldData = "",
      this.fieldId = "",
      this.fieldType = "text",
      this.controller});
  final String uid;
  final String skill;
  final String title;
  final String fieldType;
  final String fieldId;
  final String fieldData;
  final TextEditingController controller;

  @override
  State<StatefulWidget> createState() {
    return _MyTextFieldState2(
        title: this.title,
        uid: this.uid,
        fieldData: this.fieldData,
        fieldType: this.fieldType,
        controller: this.controller);
  } // the parent handler function that updates the parent state, this is passed from the parent.
}

class _MyTextFieldState2 extends State<MyTextField2> {
  //Constructor of the child widget
  @override
  _MyTextFieldState2(
      {@required this.title,
      this.uid,
      //this.endpoint,
      this.fieldData = "",
      this.fieldId = "",
      this.fieldType = "text",
      this.controller});

  final String uid;
  final String title;
  final String fieldType;
  final String fieldId;
  String fieldData;

  // Using this controller instead of a handler now. controller.text gives the text in the textfield.
  TextEditingController controller;

  Requests serverRequest = new Requests();
  //created a text editing controller so that we can modify the text on init of this widget if need be.
  // var controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (this.controller == null) {
      this.controller = TextEditingController();
    }
  }

  //keyboard map
  final Map<String, TextInputType> keyboards = {
    "numeric": TextInputType.numberWithOptions(decimal: true),
    "text": TextInputType.text
  };

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // The actual object iself.
  Widget build(BuildContext context) {
    //controller.text = this.fieldData;
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
          Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: Text(this.title)),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  textAlign: TextAlign.left,
                  controller: controller,
                  keyboardType: keyboards[this.fieldType],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter something",
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide(color: Colors.red, width: 1),
                    ),
                  ),
                  // ########## We do not need this anymore, we're passing in a controller #####
                  // ### Keeping this comment temporarily
                  // onSubmitted: (text) => submitHandler(text),
                  // onChanged: (text) => submitHandler(text),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:arezue/components/search.dart';
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
      @required this.fieldId = "",
      this.fieldType = "text",
      this.handler});
  final String uid;
  final String skill;
  final String
      title; // this goes before the textfield, i.e. what textfield is this.
  final String
      fieldType; // numeric or text, depending on that it displays the keyboard differently
  final String
      fieldId; // the "key" in the data object defined in the parent stateful widget and DB.
  final String fieldData; // the actualy value of the key.
  Function handler;

  @override
  State<StatefulWidget> createState() {
    return _MyTextFieldState2(
        title: this.title,
        uid: this.uid,
        fieldData: this.fieldData,
        fieldType: this.fieldType,
        handler: this.handler);
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
      @required this.fieldId = "",
      @required this.fieldType = "text",
      this.handler});

  final String uid;
  final String
      title; // this goes before the textfield, i.e. what textfield is this.
  //final String endpoint; // api endpoint, send the whole URL for now but we'll need to generalize this
  final String
      fieldType; // numeric or text, depending on that it displays the keyboard differently
  final String
      fieldId; // the "key" in the data object defined in the parent stateful widget and DB.
  String fieldData; // the actualy value of the key.
  Function
      handler; // the parent handler function that updates the parent state, this is passed from the parent.

  Requests serverRequest = new Requests();
  //created a texteditting controll so that we can modify the text on init of this widget if need be.
  var controller = TextEditingController();

  //keyboard map
  final Map<String, TextInputType> keyboards = {
    "numeric": TextInputType.numberWithOptions(decimal: true),
    "text": TextInputType.text
  };

  @override
  void initState() {
    if (this.fieldData != null) {
      controller.text = fieldData;
    }
    super.initState();
  }

  // child handler that calls the API and then the parent handler.
  void submitHandler(text) {
    setState(() {
      controller.text = text;
      fieldData = text;
    });

    handler(this.title, text); //calling formHandler
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
              0.0, // horizontal, move right 10
              0.0, // vertical, move down 10
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
              Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: Text(this.title)),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter something",
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide(color: Colors.red, width: 1),
                    ),
                  ),
                  onSubmitted: (text) => submitHandler(text),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

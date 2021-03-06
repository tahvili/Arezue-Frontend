/// Custom switch on and off based on when pressing on it

import 'dart:ui';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/http.dart';

class MySwitchTextField extends StatefulWidget {
  MySwitchTextField(
      {@required this.title,
      this.uid,
      this.endpoint,
      this.fieldData,
      this.fieldId,
      this.fieldType = "text",
      this.handler});
  final String uid;
  final String
      title; // this goes before the textfield, i.e. what textfield is this.
  final String
      endpoint; // api endpoint, send the whole URL for now but we'll need to generalize this
  final String
      fieldType; // numeric or text, depending on that it displays the keyboard differently
  final String
      fieldId; // the "key" in the data object defined in the parent stateful widget and DB.
  final bool fieldData; // the actualy value of the key.
  final Function handler;

  @override
  State<StatefulWidget> createState() {
    return _MySwitchTextFieldState(
        title: this.title,
        uid: this.uid,
        endpoint: this.endpoint,
        fieldId: this.fieldId,
        handler: this.handler,
        fieldData: this.fieldData,
        fieldType: this.fieldType);
  } // the parent handler function that updates the parent state, this is passed from the parent.
}

class _MySwitchTextFieldState extends State<MySwitchTextField> {
  //Constructor of the child widget
  @override
  _MySwitchTextFieldState(
      {@required this.title,
      this.uid,
      this.endpoint,
      this.fieldData,
      this.fieldId,
      this.fieldType,
      this.handler});

  final String uid;
  final String
      title; // this goes before the textfield, i.e. what textfield is this.
  final String
      endpoint; // api endpoint, send the whole URL for now but we'll need to generalize this
  final String
      fieldType; // numeric or text, depending on that it displays the keyboard differently
  final String
      fieldId; // the "key" in the data object defined in the parent stateful widget and DB.
  bool fieldData; // the actualy value of the key.
  final Function
      handler; // the parent handler function that updates the parent state, this is passed from the parent.

  Requests serverRequest = new Requests();
  bool isSwitched;

  @override
  void initState() {
    this.isSwitched = this.fieldData;
    super.initState();
  }

  //keyboard map
  final Map<String, TextInputType> keyboards = {
    "numeric": TextInputType.numberWithOptions(decimal: true),
    "text": TextInputType.text
  };

  // child handler that calls the API and then the parent handler.
  void submitHandler(String fieldId, text) {
    // Handle PUT request to the api here
    serverRequest.putRequest("jobseeker/${this.uid}", "x-www-form-urlencoded" ,
        {fieldId : text}, false);
    // Once that's done, notify the parent so it knows to update its local state.
  }

  Widget build(BuildContext context) {
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
        child: Row(
          children: <Widget>[
            Text(this.title,
                style: TextStyle(
                  color: ArezueColors.outPrimaryColor,
                  fontSize: 18,
                  fontFamily: 'Arezue',
                  fontWeight: FontWeight.w600,
                )),
            SizedBox(width: 40),
            Expanded(
              child: Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                    submitHandler(this.fieldId, value.toString());
                  });
                },
                activeTrackColor: Colors.grey,
                inactiveThumbColor: Colors.grey,
                activeColor: Colors.black87,
              ),
            ),
          ],
        ));
  }
}

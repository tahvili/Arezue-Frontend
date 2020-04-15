/// Custom text field that updates the server directly after we finished typing

import 'dart:ui';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/http.dart';

class MyTextField extends StatefulWidget {
  MyTextField(
      {@required this.title,
      this.uid,
      this.endpoint,
      this.fieldData = "",
      this.fieldId,
      this.fieldType = "text",
      this.handler,
      this.controller});
  final String uid;
  final String title;
  final String endpoint;
  final String fieldType;
  final String fieldId;
  final String fieldData;
  final Function handler;
  final TextEditingController controller;

  @override
  State<StatefulWidget> createState() {
    return _MyTextFieldState(
        title: this.title,
        uid: this.uid,
        endpoint: this.endpoint,
        fieldId: this.fieldId,
        handler: this.handler,
        fieldData: this.fieldData,
        fieldType: this.fieldType,
        controller: this.controller);
  } // the parent handler function that updates the parent state, this is passed from the parent.
}

class _MyTextFieldState extends State<MyTextField> {
  //Constructor of the child widget
  @override
  _MyTextFieldState(
      {@required this.title,
      this.uid,
      this.endpoint,
      this.fieldData = "",
      this.fieldId,
      this.fieldType,
      this.handler,
      this.controller});

  final String uid;
  final String title;
  final String endpoint;
  final String fieldType;
  final String fieldId;
  String fieldData;
  final Function handler;

  Requests serverRequest = new Requests();
  TextEditingController controller;

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

  // child handler that calls the API and then the parent handler.
  void submitHandler(String fieldId, text) {
    controller.text = text;
    if (this.fieldId == "Wage" || this.fieldId == "Hours") {
      // Do nothing
    } else {
      // Handle PUT request to the api here
      serverRequest.putRequest('jobseeker', uid, fieldId, text);
    }
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
                0.0,
                0.0,
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
            SizedBox(width: 15),
            Expanded(
              child: optionValue(),
            ),
          ],
        ));
  }

  Widget optionValue() {
    if (this.fieldId == "goal_wage" || this.fieldId == "acceptance_wage") {
      return TextField(
        textAlign: TextAlign.right,
        controller: controller,
        keyboardType: keyboards[this.fieldType],
        readOnly: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter something",
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
        onTap: () => (_asyncInputDialog(context, this.fieldId, this.fieldData)),
      );
    }
    return TextField(
      textAlign: TextAlign.right,
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
      onSubmitted: (text) => submitHandler(this.fieldId, text),
    );
  }

  Future<String> _asyncInputDialog(
      BuildContext context, String title, String value) async {
    if (title == "goal_wage") {
      title = "goal wage";
    } else if (title == "acceptance_wage") {
      title = "acceptance wage";
    }
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('value for $title'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                textAlign: TextAlign.left,
                autofocus: true,
                controller: controller,
                keyboardType: keyboards[this.fieldType],
                decoration: new InputDecoration(
                    labelText: title, hintText: 'Value Yourself!'),
                onChanged: (value) {
                  teamName = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Save'),
              onPressed: () {
                serverRequest.putRequest('jobseeker', uid, fieldId, teamName);
                Navigator.of(context).pop(teamName);
              },
            ),
          ],
        );
      },
    );
  }
}

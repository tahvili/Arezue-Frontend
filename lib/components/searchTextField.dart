/// Custom text field used for searches

import 'dart:ui';
import 'package:arezue/components/search.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/http.dart';

class MySearchTextField extends StatefulWidget {
  MySearchTextField(
      {@required this.title,
      this.uid,
      this.skill,
      this.fieldData = "",
      this.fieldId = "",
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
  final Function handler;

  @override
  State<StatefulWidget> createState() {
    return _MySearchTextFieldState(
        title: this.title,
        uid: this.uid,
        skill: this.skill,
        fieldId: this.fieldId,
        fieldData: this.fieldData,
        fieldType: this.fieldType,
        handler: this.handler);
  } // the parent handler function that updates the parent state, this is passed from the parent.
}

class _MySearchTextFieldState extends State<MySearchTextField> {
  //Constructor of the child widget
  @override
  _MySearchTextFieldState(
      {@required this.title,
      this.uid,
      this.endpoint,
      this.skill,
      this.fieldData,
        this.fieldId,
      this.fieldType,
      this.handler});

  final String uid;
  final String skill;
  final String
      title; // this goes before the textfield, i.e. what textfield is this.
  final String
      endpoint; // api endpoint, send the whole URL for now but we'll need to generalize this
  final String
      fieldType; // numeric or text, depending on that it displays the keyboard differently
  String
      fieldId; // the "key" in the data object defined in the parent stateful widget and DB.
  final String fieldData; // the actualy value of the key.
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
    if (this.skill != null) {
      controller.text = skill;
    }
    super.initState();
  }

  // child handler that calls the API and then the parent handler.
  void submitHandler(text) {
    setState(() {
      controller.text = text;
    });
    if(this.fieldId == "Position"){ //for employer job posting
      handler(this.fieldId, text);
    }else {
      handler(text, "skill");
    }//calling formHandler
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
      child: TextField(
        onTap: () {
          _showSearchBar(context, fieldId, submitHandler, this.uid, "skill");
        },
        textAlign: TextAlign.right,
        textInputAction: TextInputAction.done,
        controller: controller,
        keyboardType: keyboards[this.fieldType],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search",
          prefixIcon: Icon(Icons.search),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
        onSubmitted: (text) => submitHandler(text),
      ),
    );
  }

  void _showSearchBar(BuildContext context, String id, Function handler, String uid, String category) async {
    final result = await showSearch(
        context: context,
        delegate: Search(
          fieldId: id,
          handler: handler,
          uid: uid,
          category: category
        ));
    if (result != null) {
      handler(result);
    }
  }
}

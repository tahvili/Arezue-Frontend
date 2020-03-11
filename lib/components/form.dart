import 'dart:ui';

import 'package:arezue/services/http.dart';
import 'package:arezue/utils/colors.dart';
import 'package:arezue/utils/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Formm extends StatelessWidget {
  //Constructor of the child widget
  @override
  Formm(
      {@required this.title,
      });

//  final String uid;
  final String
  title; // this goes before the textfield, i.e. what textfield is this.
//  final String
//  endpoint; // api endpoint, send the whole URL for now but we'll need to generalize this
//  final String
//  fieldType; // numeric or text, depending on that it displays the keyboard differently
//  final String
//  fieldId; // the "key" in the data object defined in the parent stateful widget and DB.
//  final List<String> fieldData; // the actualy value of the key.
//  Function
//  handler; // the parent handler function that updates the parent state, this is passed from the parent.

//  //created a texteditting controll so that we can modify the text on init of this widget if need be.
//  var controller = TextEditingController();
//  Requests serverRequest = new Requests();
//  //keyboard map
//  final Map<String, TextInputType> keyboards = {
//    "numeric": TextInputType.numberWithOptions(decimal: true),
//    "text": TextInputType.text
//  };

//  // child handler that calls the API and then the parent handler.
//  void submitHandler(text, command) {
//    // Handle PUT request to the api here
//    if (command == "add") {
//      serverRequest.putRequest('jobseeker', uid, fieldId, text);
//    } else if (command == "delete") {
//      //make a delete request to API here
//    } else {
//      print("why am I here?");
//    }
//    print("child handler triggered: ${text}");
//
//    // Once that's done, notify the parent so it knows to update its local state.
//    handler(text, fieldId);
//  }

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
      body: RaisedButton(
        onPressed: (){},
        child: Text(
          "Submit", style: TextStyle(color: ArezueColors.outPrimaryColor)
        ),
        ),
    );
  }
}

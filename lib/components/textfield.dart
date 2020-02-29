import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {

  //Constructor of the child widget
  @override
  MyTextField(
    {@required this.title, 
    this.endpoint, 
    this.fieldData="", 
    @required this.fieldId="", 
    @required this.fieldType="text", 
    this.handler}
    );
  
  final String title; // this goes before the textfield, i.e. what textfield is this.
  final String endpoint; // api endpoint, send the whole URL for now but we'll need to generalize this
  final String fieldType; // numeric or text, depending on that it displays the keyboard differently
  final String fieldId; // the "key" in the data object defined in the parent stateful widget and DB.
  final String fieldData; // the actualy value of the key.
  Function handler; // the parent handler function that updates the parent state, this is passed from the parent.

  //created a texteditting controll so that we can modify the text on init of this widget if need be.
  var controller = TextEditingController();

  //keyboard map
  final Map <String, TextInputType>keyboards = {"numeric": TextInputType.numberWithOptions(decimal: true), "text": TextInputType.text};

  // child handler that calls the API and then the parent handler.
  void submitHandler(text) {

    // Handle PUT request to the api here
    print("child handler triggered: ${text}");

    // Once that's done, notify the parent so it knows to update its local state.
    handler(text, fieldId);
  }

  // The actual object iself.
  Widget build(BuildContext context) {
    controller.text = this.fieldData;
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.5
        ),
        borderRadius: BorderRadius.circular(10)
      ),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Text(this.title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 20),
          Expanded(child:
            TextField(
              controller: controller,
              keyboardType: keyboards[this.fieldType],
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter something",
              ),
              onSubmitted: (text) => submitHandler(text),
            ),
          ),
        ],
      )
    );
  }
}
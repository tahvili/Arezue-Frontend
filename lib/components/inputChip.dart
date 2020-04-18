/// Custom input chip

import 'dart:ui';
import 'package:arezue/components/search.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputChipBuilder extends StatefulWidget {
  InputChipBuilder(
      {@required this.title,
      this.uid,
      this.endpoint,
      this.fieldData,
      this.fieldId = "",
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
  final List<String> fieldData; // the actualy value of the key.
  final Function
      handler; // the parent handler function that updates the parent state, this is passed from the parent.

  @override
  State<StatefulWidget> createState() {
    return _InputChipBuilderState(
        title, uid, endpoint, fieldData, fieldId, fieldType, handler);
  }
}

class _InputChipBuilderState extends State<InputChipBuilder> {
  _InputChipBuilderState(this.title, this.uid, this.endpoint, this.fieldData,
      this.fieldId, this.fieldType, this.handler);

  final String uid;
  final String
      title; // this goes before the textfield, i.e. what textfield is this.
  final String
      endpoint; // api endpoint, send the whole URL for now but we'll need to generalize this
  final String
      fieldType; // numeric or text, depending on that it displays the keyboard differently
  final String
      fieldId; // the "key" in the data object defined in the parent stateful widget and DB.
  final List<String> fieldData; // the actualy value of the key.
  Function
      handler; // the parent handler function that updates the parent state, this is passed from the parent.

  var controller = TextEditingController();
  Requests serverRequest = new Requests();

  @override
  void initState() {
    super.initState();
  }

  //keyboard map
  final Map<String, TextInputType> keyboards = {
    "numeric": TextInputType.numberWithOptions(decimal: true),
    "text": TextInputType.text
  };

  // child handler that calls the API and then the parent handler.
  void submitHandler(String text, String preference, String command) {
    // Handle PUT request to the api here
    if (command == "add") {
      if (this.fieldData.contains(text)) {
        _showExistingMessage(text);
      }
      else {
        if (uid != null) {
          serverRequest.postRequest("jobseeker/$uid/$fieldId",
              {this.fieldId : text, preference : "1"});
        }
        setState(() {
          this.fieldData.add(text);
        });
      }
    }else if (command == "delete") {
      //make a delete request to API here
      if (uid != null) {
        serverRequest.deleteRequest(uid, "$fieldId/$text");
      }
      setState(() {
        this.fieldData.remove(text);
      });
    } else {}

    handler(text, command);
    // Once that's done, notify the parent so it knows to update its local state.
  }

  Widget inputChips(text) {
    return InputChip(
      padding: EdgeInsets.all(2.0),
      label: Text(text),
      labelStyle: TextStyle(
        color: ArezueColors.secondaryColor,
      ),
      onDeleted: () {
        submitHandler(text, fieldId, "delete");
      }, //this is what happens when the x is pressed
    );
  }

  // The actual object iself.
  Widget build(BuildContext context) {
    //controller.text = this.fieldData as String;
    return Container(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
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
                Text(this.title,
                    style: TextStyle(
                      color: ArezueColors.outPrimaryColor,
                      fontSize: 18,
                      fontFamily: 'Arezue',
                      fontWeight: FontWeight.w600,
                    )),
                new Spacer(),
                Container(
                  width: 50,
                  child: MaterialButton(
                      padding: EdgeInsets.all(12),
                      shape: CircleBorder(),
                      textColor: ArezueColors.primaryColor,
                      child: Icon(
                        Icons.add,
                        size: 20,
                      ),
                      color: ArezueColors.secondaryColor,
                      onPressed: () {
                        String category = "";
                        if(this.fieldId=="dream_career"){
                          category = "career";
                        }
                        else if(this.fieldId=="dream_company"){
                          category = "company";
                        }
                        else if(this.fieldId=="skill"){
                          category = "skill";
                        }
                        _showSearchBar(context, fieldId, submitHandler, this.uid, category);
                      }),
                ),
              ],
            ),
            SizedBox(height: 15),
            //Row(children: <Widget>[
            Wrap(
              spacing: 5.0, // gap between adjacent chips
              alignment: WrapAlignment.start,
              children: listWidgets(this.fieldData),
            ),
          ],
        ));
  }

  List<Widget> listWidgets(List<String> list) {
    List<Widget> widglist = new List<Widget>();
    list.forEach((element) {
      widglist.add(inputChips(element));
    });
    return widglist;
  }

  void _showSearchBar(BuildContext context, String id, Function handler,
      String uid, String category) async {
    final result = await showSearch(
        context: context,
        delegate: Search(
          fieldId: id,
          handler: handler,
          uid: uid,
          category: category,
        ));
    if (result != null) {
      handler(result, 'ranking', 'add');
    }
  }


  void _showExistingMessage(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Oops!"),
            content: new Text("$text already exits!"),
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
}

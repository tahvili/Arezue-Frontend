/// Custom input chip used for skills in profile

import 'dart:ui';
import 'package:arezue/components/form.dart';
import 'package:arezue/jobseeker/information.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputChipBuilder2 extends StatefulWidget {
  InputChipBuilder2(
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
  final List<Object> fieldData; // the actualy value of the key.
  final Function
      handler; // the parent handler function that updates the parent state, this is passed from the parent.

  @override
  State<StatefulWidget> createState() {
    return _InputChipBuilderState2(
        title, uid, endpoint, fieldData, fieldId, fieldType, handler);
  }
}

class _InputChipBuilderState2 extends State<InputChipBuilder2> {
  _InputChipBuilderState2(this.title, this.uid, this.endpoint, this.fieldData,
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
  final List<Object> fieldData; // the actualy value of the key.
  Function
      handler; // the parent handler function that updates the parent state, this is passed from the parent.

  var controller = TextEditingController();
  Requests serverRequest = new Requests();

  List<String> objectList = new List();
  List<Map<String, dynamic>> arr = new List<Map<String, dynamic>>();

  void generateListSkills(List<Object> list) {
    if (fieldId == "skill") {
      List<Skill>.from(list).forEach((skill) {
        objectList.add(skill.skill);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // FetchData();
    generateListSkills(fieldData);
  }

  //keyboard map
  final Map<String, TextInputType> keyboards = {
    "numeric": TextInputType.numberWithOptions(decimal: true),
    "text": TextInputType.text
  };

  // child handler that calls the API and then the parent handler.
  void submitHandler(String text, String command) {
    // Handle PUT request to the api here
    if (command == "add") {
      setState(() {
        this.objectList.add(text);
      });
    } else if (command == "delete") {
      setState(() {
        serverRequest.skillDeleteRequest(this.uid, text);
        this.objectList.remove(text);
      });
    } else {
      setState(() {});
    }
    handler(text, command);
    // Once that's done, notify the parent so it knows to update its local state.
  }

  Future<int> fetchData() async {
    arr = await (serverRequest.skillsGetRequest(uid, this.fieldId));
    if (arr.length != 0) {
      return 200;
    } else {
      return 0;
    }
  }

  Widget inputChips(text) {
    return InputChip(
      padding: EdgeInsets.all(2.0),
      label: Text(text),
      labelStyle: TextStyle(
        color: ArezueColors.secondaryColor,
      ),
      onPressed: () async {
        if (await (fetchData()) == 200) {
          print(arr);
          Map<String, dynamic> value = arr.singleWhere(
              (element) => element['skill'] == text.toString().toLowerCase());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FormPage(
                      title: "Edit Your skill",
                      skill: value['skill'],
                      numExperience: value['years'],
                      numExpertise: value['level'],
                      handler: submitHandler,
                      uid: this.uid,
                      fieldId: this.fieldId)));
        }
      },
      onDeleted: () {
        submitHandler(text, "delete");
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FormPage(
                                    title: "Add a skill",
                                    skill: null,
                                    numExperience: 0,
                                    numExpertise: 5,
                                    handler: submitHandler,
                                    uid: this.uid,
                                    fieldId: this.fieldId)));
                      }),
                ),
              ],
            ),
            SizedBox(height: 15),
            //Row(children: <Widget>[
            Wrap(
              spacing: 5.0, // gap between adjacent chips
              alignment: WrapAlignment.start,
              children: listWidgets(this.objectList),
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
}

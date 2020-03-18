import 'dart:ui';
import 'package:arezue/components/form2.dart';
import 'package:arezue/jobseeker/information.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputChipBuilder3 extends StatefulWidget {
  InputChipBuilder3(
      {@required this.title,
      this.uid,
      this.id,
      this.endpoint,
      this.fieldData,
      @required this.fieldId = "",
      this.fieldType = "text",
      this.handler});

  final String uid;
  final String id;
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

  @override
  State<StatefulWidget> createState() {
    return _InputChipBuilderState3(
        title, id, uid, endpoint, fieldData, fieldId, fieldType, handler);
  }
}

class _InputChipBuilderState3 extends State<InputChipBuilder3> {
  _InputChipBuilderState3(
      @required this.title,
      this.id,
      this.uid,
      this.endpoint,
      this.fieldData,
      @required this.fieldId,
      this.fieldType,
      this.handler);

  final String uid;
  String id;
  final String
      title; // this goes before the textfield, i.e. what textfield is this.
  final String
      endpoint; // api endpoint, send the whole URL for now but we'll need to generalize this
  final String
      fieldType; // numeric or text, depending on that it displays the keyboard differently
  final String
      fieldId; // the "key" in the data object defined in the parent stateful widget and DB.
  final List<Object> fieldData; // the actual value of the key.
  Function
      handler; // the parent handler function that updates the parent state, this is passed from the parent.


  Map<String, String> sendList  = new  Map<String, String>();
  //created a text-editing controller so that we can modify the text on init of this widget if need be.
  var controller = TextEditingController();
  Requests serverRequest = new Requests();

  List<Object> objectList = new List();
  List<Map<String, dynamic>> arr = new List<Map<String, dynamic>>();

  void generateObjectList(List<Object> list) {
    if (fieldId == "experience") {
      List<Experience>.from(list).forEach((experience) {
        objectList.add(experience);
        this.id = experience.expId;
      });
    } else if (fieldId == "education") {
      List<Education>.from(list).forEach((education) {
        objectList.add(education);
        this.id = education.edId;
      });
    }else{
      List<Certification>.from(list).forEach((certification) {
        objectList.add(certification);
        this.id = certification.cId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    FetchData();
    generateObjectList(fieldData);
  }


  Future<int> FetchData() async {
    arr = await (serverRequest.skillsGetRequest(uid, this.fieldId));
    if (arr.length != 0) {
//      return 200;
    } else {
      return 0;
    }
  }

  //keyboard map
  final Map<String, TextInputType> keyboards = {
    "numeric": TextInputType.numberWithOptions(decimal: true),
    "text": TextInputType.text
  };

  // child handler that calls the API and then the parent handler.
  void submitHandler(Object text, String command) {
    // Handle PUT request to the api here

    if (command == "add") {
      setState(() {
        this.objectList.add(text);
      });
    } else if (command == "delete") {
      setState(() {
        this.objectList.remove(text);
      });
    } else {
      setState(() {});
    }
    handler(text, command);
    // Once that's done, notify the parent so it knows to update its local state.
  }


//
//  Widget inputChips(text) {
//    return InputChip(
//      padding: EdgeInsets.all(2.0),
//      label: Text(text),
//      labelStyle: TextStyle(
//        color: ArezueColors.secondaryColor,
//      ),
//      onPressed: () async {
//        if (await (FetchData()) == 200) {
//          //Skill value = fieldData.singleWhere((skill) => skill.skill == text);
//          Map<String, dynamic> value =
//              arr.singleWhere((element) => element['skill'] == text);
//          Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => FormPage(
//                      title: "Edit Your skill",
//                      skill: value['skill'],
//                      numExperience: value['years_of_expertise'],
//                      numExpertise: value['level_expertise'],
//                      handler: submitHandler,
//                      uid: this.uid,
//                      fieldId: this.fieldId)));
//        }
//      },
//      onDeleted: () {
//        submitHandler(text, "delete");
//      }, //this is what happens when the x is pressed
//    );
//  }

  Widget getText(String text) {
    return Expanded(
      child: Text(
        "$text",
        style: TextStyle(
          color: ArezueColors.outPrimaryColor,
          fontSize: 18,
          fontFamily: 'Arezue',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<Widget> getTextList(List<String> list) {
    List<Widget> textList = new List<Widget>();
    list.forEach((element) => textList.add(getText(element)));

    return textList;
  }


  List<String> getStringList(Object list) {
    List arrStr = new List();
    if (fieldId == "experience") {
      arrStr.add((list as Experience).title);
      arrStr.add((list as Experience).startDate);
      arrStr.add((list as Experience).endDate);
      arrStr.add((list as Experience).description);
    } else if (fieldId == "education") {
      arrStr.add((list as Education).schoolName);
      arrStr.add((list as Education).startDate);
      arrStr.add((list as Education).gradDate);
      arrStr.add((list as Education).program);
    } else {
      arrStr.add((list as Certification).name);
      arrStr.add((list as Certification).startDate);
      arrStr.add((list as Certification).endDate);
      arrStr.add((list as Certification).issuer);
    }
    return List<String>.from(arrStr);
  }

  Widget getContainer(Object elements) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      margin: const EdgeInsets.only(bottom: 20.0),
      width: MediaQuery.of(context).size.width - 150,
      height: MediaQuery.of(context).size.width - 150,
      decoration: BoxDecoration(
        color: ArezueColors.inputChipColor,
        borderRadius: BorderRadius.all(Radius.circular(35.0)),
      ),
      child: Column(
        children: getTextList(getStringList(elements)),
      ),
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
                getText(this.title),
                new Spacer(),
                Container(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: Icon(Icons.add),
                        color: ArezueColors.secondaryColor,
                        onPressed: () {
                          sendList = sendListGenerator(this.fieldId);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FormPage2(
                                      title: "Add your $fieldId",
                                      isNew: "true",
                                      objectList: sendList,
                                      handler: submitHandler,
                                      uid: this.uid,
                                      fieldId: this.fieldId)));
                        }),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Wrap(
              spacing: 5.0, // gap between adjacent chips
              alignment: WrapAlignment.start,
              children: listWidgets(this.objectList),
            ),
          ],
        ));
  }

  List<Widget> listWidgets(List<Object> list) {
    List<Widget> expList = new List<Widget>();
    list.forEach((element) {
      expList.add(getContainer(element));
    });
    return expList;
  }

  Map<String, String> sendListGenerator(String fieldId) {
    if(fieldId == "education"){
      sendList = {
        "Name of Institution" : null,
        "Start Date": null,
        "End Date": null,
        "Program": null,
      };
    }else if(fieldId == "experience"){
      sendList = {
        "Job Title": null,
        "Start Date": null,
        "End Date": null,
        "Description": null,
      };
    }else{
      sendList = {
        "Name": null,
        "Start Date": null,
        "End Date": null,
        "Issuing Organization": null,
      };
    }
    return sendList;
  }
}

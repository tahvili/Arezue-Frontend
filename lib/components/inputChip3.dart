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
      this.fieldId = "",
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
  final Function
      handler; // the parent handler function that updates the parent state, this is passed from the parent.

  @override
  State<StatefulWidget> createState() {
    return _InputChipBuilderState3(
        title, id, uid, endpoint, fieldData, fieldId, fieldType, handler);
  }
}

class _InputChipBuilderState3 extends State<InputChipBuilder3> {
  _InputChipBuilderState3(
      this.title,
      this.id,
      this.uid,
      this.endpoint,
      this.fieldData,
      this.fieldId,
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
  final Function
      handler; // the parent handler function that updates the parent state, this is passed from the parent.

  Map<String, dynamic> sendList = new Map<String, dynamic>();
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
    } else {
      List<Certification>.from(list).forEach((certification) {
        objectList.add(certification);
        this.id = certification.cId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
//    FetchData();
    generateObjectList(fieldData);
  }

  Future<int> fetchData() async {
    arr = await (serverRequest.skillsGetRequest(uid, this.fieldId));
    //print("the array after get is: $arr");
    if (arr.length != 0) {
      return 200;
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
        if(this.fieldId == "education"){
        this.objectList.removeWhere((element) => (element as Education).edId == text.toString());
      }else  if(this.fieldId == "experience"){
          this.objectList.removeWhere((element) => (element as Experience).expId == text.toString());
        }else {
          this.objectList.removeWhere((element) => (element as Certification).cId == text.toString());
        }
      });
    } else {
      List lst = List<String>.from(text);
      setState(() {
        if(this.fieldId == "education"){
          for(Object element in this.objectList){
            Education ed = (element as Education);
            if(ed.edId == command.toString()){
              ed.schoolName = lst[0];
              ed.startDate = lst[1];
              ed.gradDate = lst[2];
              ed.program = lst[3];
            }
          }
        }else  if(this.fieldId == "experience"){
          for(Object element in this.objectList){
            Experience exp = (element as Experience);
            if(exp.expId == command.toString()){
              exp.title = lst[0];
              exp.startDate = lst[1];
              exp.endDate = lst[2];
              exp.description = lst[3];
            }
          }
        }else {
          for(Object element in this.objectList){
            Certification cert = (element as Certification);
            if(cert.cId == command.toString()){
              cert.name = lst[0];
              cert.startDate = lst[1];
              cert.endDate = lst[2];
              cert.issuer = lst[3];
            }
          }
        }
      });
    }
    handler(text, command);
    // Once that's done, notify the parent so it knows to update its local state.
  }


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

  String getTextList(List<String> list) {
    String text="";
    for(int i = 0; i<list.length;i++){
      if(i==2){
        text+=" - ${list[i]}";
      }
      else {
        text += "\n${list[i]}";
      }
    }

    return text;
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
      padding: EdgeInsets.fromLTRB(5, 5, 5, 25),
      margin: const EdgeInsets.only(bottom: 20.0),
      width: MediaQuery.of(context).size.width - 150,
      decoration: BoxDecoration(
        color: ArezueColors.inputChipColor,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        children: [
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
              child:
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  Map<String, dynamic> val = await (sendEditListGenerator(this.fieldId, elements));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FormPage2(
                              title: "Edit your $fieldId",
                              isNew: "false",
                              objectList: val,
                              id: this.id,
                              handler: submitHandler,
                              uid: this.uid,
                              fieldId: this.fieldId)));
                },
              ),
    ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child:Text(getTextList(getStringList(elements)),style: TextStyle(
                color: ArezueColors.outPrimaryColor,
                fontSize: 18,
                fontFamily: 'Arezue',
                fontWeight: FontWeight.w600,
              ),
              ),),
            ],
          ),

//          Expanded(
//            child: Column(
//              children: getTextList(getStringList(elements)),
//            ),
//          ),
        ],
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
                  width:50,
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

  Map<String, dynamic> sendListGenerator(String fieldId) {
    if (fieldId == "education") {
      sendList = {
        "Name of Institution": "",
        "Start Date": "",
        "End Date": "",
        "Program": "",
      };
    } else if (fieldId == "experience") {
      sendList = {
        "Job Title": "",
        "Start Date": "",
        "End Date": "",
        "Description": "",
      };
    } else {
      sendList = {
        "Name": "",
        "Start Date": "",
        "End Date": "",
        "Issuing Organization": "",
      };
    }
    return sendList;
  }
  Future<Map<String, dynamic>> sendEditListGenerator(String fieldId, Object element) async {
    if (await(fetchData()) == 200) {
      print("arr is: $arr");
      Map<String, dynamic> value;
      if (fieldId == "education") {
        value = arr.singleWhere((val) => val['ed_id'].toString() == ((element as Education).edId).toString());
        sendList = {
          "Name of Institution": value['school_name'],
          "Start Date": value['start_date'],
          "End Date": value['grad_date'],
          "Program": value['program'],
          //"ed_id": value['ed_id'],
        };
      } else if (fieldId == "experience") {
        value = arr.singleWhere((val) => val['exp_id'].toString() == ((element as Experience).expId).toString());
        print("the value of value is: $value");
        sendList = {
          "Job Title": value['title'],
          "Start Date": value['start_date'],
          "End Date": value['end_date'],
          "Description": value['description'],
         // "exp_id": value['exp_id'],
        };
      } else {
        value = arr.singleWhere((val) => val['c_id'].toString() == ((element as Certification).cId).toString());
        sendList = {
          "Name": value['cert_name'],
          "Start Date": value['start_date'],
          "End Date": value['end_date'],
          "Issuing Organization": value['issuer'],
          //"cert_id": value['cert_id'],
        };
      }
      return sendList;
    }else{
      return {};
    }
  }
}

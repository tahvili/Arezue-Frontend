import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';

class RadioWidget extends StatefulWidget {

  RadioWidget({this.handler});

  final Function handler;
  @override
  RadioWidgetState createState() => RadioWidgetState(handler : this.handler);
}

class RadioWidgetState extends State<RadioWidget> {

  RadioWidgetState({this.handler});

  int selectedRadioTile;
  Function handler;

  @override
  void initState() {
    super.initState();
    selectedRadioTile = 0;
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
      handler(val, "experience");
    });
  }

  @override
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
      ),]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RadioListTile(
            value: 5,
            groupValue: selectedRadioTile,
            title: Text("Beginner"),
            onChanged: (val) {
              setSelectedRadioTile(val);
            },
            activeColor: Colors.green,
            selected: selectedRadioTile == 5,
          ),
          RadioListTile(
            value: 3,
            groupValue: selectedRadioTile,
            title: Text("Intermediate"),
            onChanged: (val) {
              setSelectedRadioTile(val);
              //submitHandler(val);
            },
            activeColor: Colors.green,
            selected: selectedRadioTile == 3,
          ),
          RadioListTile(
            value: 1,
            groupValue: selectedRadioTile,
            title: Text("Expert"),
            onChanged: (val) {
              setSelectedRadioTile(val);
              //submitHandler(val);
            },
            activeColor: Colors.green,
            selected: selectedRadioTile == 1,
          ),
        ],
      ),
    );
  }
}

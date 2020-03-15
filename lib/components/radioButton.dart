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
    });
  }

  void submitHandler(value){
    handler(value, "expertise");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              submitHandler(val);
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
              submitHandler(val);
            },
            activeColor: Colors.green,
            selected: selectedRadioTile == 1,
          ),
        ],
      ),
    );
  }
}

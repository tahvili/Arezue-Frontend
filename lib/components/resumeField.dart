import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arezue/utils/colors.dart';

class ResumeField extends StatefulWidget {

  @override
  ResumeField(
      {@required this.title,
        this.endpoint,
        this.list,
        this.original,
        this.handler}
      );
  final String title; // this goes before the textfield, i.e. what textfield is this.
  final String endpoint; // api endpoint, send the whole URL for now but we'll need to generalize this
  final List list;
  final List original;
  Function handler;
  _ResumeField createState() => _ResumeField(title: title, endpoint: endpoint, list: list, original: original, handler: handler);
}

class _ResumeField extends State<ResumeField> {

  @override
  _ResumeField(
      {@required this.title,
        this.endpoint,this.list,this.original,this.handler}
      );
  final String title; // this goes before the textfield, i.e. what textfield is this.
  final String endpoint;
  final List list;
  final List original;
  Function handler;
  //Constructor of the child widget
  List<bool> itemsBoolSelect = [];
  //created a texteditting controll so that we can modify the text on init of this widget if need be.
  var controller = TextEditingController();

  //keyboard map
  final Map <String, TextInputType>keyboards = {"numeric": TextInputType.numberWithOptions(decimal: true), "text": TextInputType.text};

  List<String> getList(){
    List<String> list = new List<String>();
    for (int i=0;i<original.length;i++){
      if(itemsBoolSelect[i]==true){
        list.add(original[i]);
      }
    }
    return list;
  }
  // child handler that calls the API and then the parent handler.
  void submitHandler(text) {
    // Handle PUT request to the api here
    print("child handler triggered: $text");
  }

  Widget saveButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width-100,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          handler(endpoint, getList());
          print(getList());
          Navigator.pop(context);
        },
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
        color: ArezueColors.outSecondaryColor,
        child: Text("Save", style: TextStyle(color: ArezueColors.outPrimaryColor)),
      ),
    );
  }

  // The actual object iself.
  Widget build(BuildContext context) {
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
      body: Center(
        child: ListView(
            children: <Widget>[
              Column(
          children: listWidgets(original),
        ),
              saveButton(),
      ],
        ),
      ),
    );
  }

  Widget selectChip(String text, int i) {

    return RawChip(
      padding: EdgeInsets.all(2.0),
      label: Text(text),
      labelStyle: TextStyle(
        color: ArezueColors.secondaryColor,
      ),
      selected: itemsBoolSelect[i],
      onSelected:(bool isSelected){
        setState((){
          itemsBoolSelect[i] = isSelected;
        });
      },
      showCheckmark: true,//this is what happens when the x is pressed
    );
  }

  List<Widget> listWidgets(List<String> minilist) {
    List<Widget> widgetlist = new List<Widget>();
    for (int i=0;i<minilist.length;i++){
      if(list.contains(original[i])) {
        itemsBoolSelect.add(true);
      }
      else{
        itemsBoolSelect.add(false);
      }
      widgetlist.add(selectChip(minilist[i], i));
    }
    return widgetlist;
  }

}
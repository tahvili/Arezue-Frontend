import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arezue/utils/colors.dart';

class ResumeField extends StatefulWidget {

  @override
  ResumeField(
      {@required this.title,
        this.endpoint}
      );
  final String title; // this goes before the textfield, i.e. what textfield is this.
  final String endpoint; // api endpoint, send the whole URL for now but we'll need to generalize this
  _ResumeField createState() => _ResumeField(title: title,endpoint: endpoint);
}

class _ResumeField extends State<ResumeField> {

  @override
  _ResumeField(
      {@required this.title,
        this.endpoint}
      );
  final String title; // this goes before the textfield, i.e. what textfield is this.
  final String endpoint;
  //Constructor of the child widget

  List<String> items_to_select = ["something1","something2","something3","something4","something5"];
  List<bool> items_bool_select = [];
  //created a texteditting controll so that we can modify the text on init of this widget if need be.
  var controller = TextEditingController();

  //keyboard map
  final Map <String, TextInputType>keyboards = {"numeric": TextInputType.numberWithOptions(decimal: true), "text": TextInputType.text};

  // child handler that calls the API and then the parent handler.
  void submitHandler(text) {
    // Handle PUT request to the api here
    print("child handler triggered: $text");
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
        child: Column(
          children: listWidgets(items_to_select),
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
      selected: items_bool_select[i],
      onSelected:(bool isSelected){
        setState((){
          items_bool_select[i] = isSelected;
        });
      },
      showCheckmark: true,//this is what happens when the x is pressed
    );
  }

  List<Widget> listWidgets(List<String> list) {
    List<Widget> widgetlist = new List<Widget>();
    for (int i=0;i<list.length;i++){
      items_bool_select.add(false);
      widgetlist.add(selectChip(list[i], i));
    }
    return widgetlist;
  }

}
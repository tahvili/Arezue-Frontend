/// inputChip used in Resume creation/edit
///
/// Used for picking skills from a list of skills &...

import 'package:arezue/jobseeker/information.dart';
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
      this.handler});
  final String title;
  final String endpoint;
  final List<dynamic> list;
  final List<dynamic> original;
  final Function handler;
  _ResumeField createState() => _ResumeField(
      title: title,
      endpoint: endpoint,
      list: list,
      original: original,
      handler: handler);
}

class _ResumeField extends State<ResumeField> {
  @override
  _ResumeField(
      {@required this.title,
      this.endpoint,
      this.list,
      this.original,
      this.handler});
  final String title;
  final String endpoint;
  final List<dynamic> list;
  final List<dynamic> original;
  Function handler;
  List<bool> itemsBoolSelect = [];
  var controller = TextEditingController();

  final Map<String, TextInputType> keyboards = {
    "numeric": TextInputType.numberWithOptions(decimal: true),
    "text": TextInputType.text
  };

  List<String> getList() {
    List<String> miniList = new List<String>();
    for (int i = 0; i < original.length; i++) {
      if (itemsBoolSelect[i] == true) {
        if (endpoint == "/education") {
          miniList.add(original[i].edId);
        } else if (endpoint == "/exp") {
          miniList.add(original[i].expId);
        } else if (endpoint == "/certification") {
          miniList.add(original[i].cId);
        } else {
          miniList.add(original[i]);
        }
      }
    }
    return miniList;
  }

  Widget saveButton() {
    // save button to be able to exit
    return Padding(
      padding: EdgeInsets.fromLTRB(50, 20, 50, 25),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          handler(endpoint, getList());
          Navigator.pop(context);
        },
        padding: EdgeInsets.fromLTRB(25, 12, 25, 12),
        color: ArezueColors.secondaryColor,
        child: Text("Save", style: TextStyle(color: ArezueColors.primaryColor)),
      ),
    );
  }

  Widget build(BuildContext context) {
    // the build function for the page
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
          padding: EdgeInsets.fromLTRB(50, 25, 50, 25),
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
    // selector of chips
    return RawChip(
      padding: EdgeInsets.all(2.0),
      label: Text(text),
      labelStyle: TextStyle(
        color: ArezueColors.secondaryColor,
      ),
      selected: itemsBoolSelect[i],
      onSelected: (bool isSelected) {
        setState(() {
          itemsBoolSelect[i] = isSelected;
        });
      },
      showCheckmark: true,
    );
  }

  Widget selectButton(Object object, int i) {
    String buttonText;
    if (endpoint == "/education") {
      buttonText =
          "${(object as Education).schoolName}\n\n${(object as Education).startDate} - ${(object as Education).gradDate}\n\n${(object as Education).program}";
    } else if (endpoint == "/exp") {
      buttonText =
          "${(object as Experience).title}\n\n${(object as Experience).startDate} - ${(object as Experience).endDate}\n\n${(object as Experience).description}";
    } else if (endpoint == "/certification") {
      buttonText =
          "${(object as Certification).name}\n\n${(object as Certification).startDate} - ${(object as Certification).endDate}\n\n${(object as Certification).issuer}";
    }
    if (itemsBoolSelect[i]) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
        child: RaisedButton(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () => setState(() {
            itemsBoolSelect[i] = false;
          }),
          padding: EdgeInsets.fromLTRB(22, 15, 22, 15),
          color: ArezueColors.highGreyColor,
          child: Text(buttonText,
              style:
                  TextStyle(color: ArezueColors.secondaryColor, fontSize: 14)),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
      child: RaisedButton(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () => setState(() {
          itemsBoolSelect[i] = true;
        }),
        padding: EdgeInsets.fromLTRB(22, 15, 22, 15),
        color: ArezueColors.primaryColor,
        child: Text(buttonText,
            style: TextStyle(color: ArezueColors.secondaryColor, fontSize: 14)),
      ),
    );
  }

  List<Widget> listWidgets(List<dynamic> minilist) {
    // listing all options based on endpoint
    List<Widget> widgetlist = new List<Widget>();
    if (endpoint == "/education") {
      for (int i = 0; i < minilist.length; i++) {
        if (list.contains(original[i].edId)) {
          itemsBoolSelect.add(true);
        } else {
          itemsBoolSelect.add(false);
        }
        widgetlist.add(selectButton(minilist[i], i));
      }
    } else if (endpoint == "/exp") {
      for (int i = 0; i < minilist.length; i++) {
        if (list.contains(original[i].expId)) {
          itemsBoolSelect.add(true);
        } else {
          itemsBoolSelect.add(false);
        }
        widgetlist.add(selectButton(minilist[i], i));
      }
    } else if (endpoint == "/certification") {
      for (int i = 0; i < minilist.length; i++) {
        if (list.contains(original[i].cId)) {
          itemsBoolSelect.add(true);
        } else {
          itemsBoolSelect.add(false);
        }
        widgetlist.add(selectButton(minilist[i], i));
      }
    } else {
      for (int i = 0; i < minilist.length; i++) {
        if (list.contains(original[i])) {
          itemsBoolSelect.add(true);
        } else {
          itemsBoolSelect.add(false);
        }
        widgetlist.add(selectChip(minilist[i], i));
      }
    }
    return widgetlist;
  }
}

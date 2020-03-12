import 'dart:ui';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';

class Formm extends StatelessWidget {
  //Constructor of the child widget
  @override
  Formm(
      {@required this.title,
      });

//  final String uid;
  final String
  title;


  // The actual object iself.
  Widget build(BuildContext context) {
    //controller.text = this.fieldData as String;
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
      body: RaisedButton(
        onPressed: (){},
        child: Text(
          "Submit", style: TextStyle(color: ArezueColors.outPrimaryColor)
        ),
        ),
    );
  }
}

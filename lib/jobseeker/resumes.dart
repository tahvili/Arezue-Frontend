import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/jobseeker/resumeForm.dart';

class ResumePage extends StatefulWidget {
  ResumePage({this.auth});
  final BaseAuth auth;
  @override
  _ResumePageState createState() => new _ResumePageState ();
}
class _ResumePageState extends State<ResumePage>{

  Widget createButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResumeFormPage(
                  auth: widget.auth,
                  resumeId: null,
                )),
          );
        },
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
        color: ArezueColors.outSecondaryColor,
        child: Text('Create a New Resume',
            style: TextStyle(color: ArezueColors.outPrimaryColor)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ArezueColors.secondaryColor,
        title: Text('My Resumes'),
        actions: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.help, color: Colors.white),
            onPressed: null,
          )
        ],
      ),
    body: Center(
        child: createButton(),
    ),
    );
  }}

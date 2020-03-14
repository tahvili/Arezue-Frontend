import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/jobseeker/resumeForm.dart';
import 'package:arezue/jobseeker/information.dart';
import 'package:arezue/services/http.dart';
import '../loading.dart';

class ResumePage extends StatefulWidget {
  ResumePage({this.auth});
  final BaseAuth auth;
  @override
  _ResumePageState createState() => new _ResumePageState ();
}
class _ResumePageState extends State<ResumePage>{

  Map<String, dynamic> data;
  Requests request = new Requests();
  Map<String,dynamic> minidata;
  List<String> resumeData;

  Future<JobseekerInfo> FetchData() async {
    minidata = await request.resumeGetList(widget.auth.currentUser());
    return await request.profileGetRequest(widget.auth.currentUser());
  }

  Widget selectResume(String resumeID, Map<String,dynamic> Data, String uid) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
        },
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
        color: ArezueColors.outSecondaryColor,
        child: Text(resumeID,
            style: TextStyle(color: ArezueColors.outPrimaryColor)),
      ),
    );
  }

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
    return FutureBuilder<JobseekerInfo>(
        future: FetchData(),
    builder: (context, snapshot) {
    if (snapshot.hasData) {
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
      child: ListView(
        children: <Widget>[
          Column(
            children: listWidgets(snapshot.data.jobseeker.uid),
          ),
          createButton(),
        ],
      ),
    ),
    );
    } else if (snapshot.hasError) {
      return Text("${snapshot.error}");
    } else {
      return Loading();
    }
    },
    );
  }

  List<Widget> listWidgets(String uid) {

    List<Widget> widgetlist = new List<Widget>();
    var keys;
    for(keys in minidata.keys){
      widgetlist.add(selectResume(minidata[keys]['name'], minidata[keys]['resume'], uid));
    }
    return widgetlist;
  }
}


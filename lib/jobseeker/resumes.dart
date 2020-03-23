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

  Widget selectResume(String resumeID, String Name, Map<String,dynamic> Data, String uid) {
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
                    resumeId: resumeID,
                    resumeName: Name,
                    uid: uid
                )),
          );
        },
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
        color: ArezueColors.outSecondaryColor,
        child: Text(Name,
            style: TextStyle(color: ArezueColors.outPrimaryColor)),
      ),
    );
  }

  Widget createButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResumeFormPage(
                  auth: widget.auth,
                  resumeId: null,
                  resumeName: '',
                  uid: null
              )),
        );
      },
      child: Icon(Icons.add),
      backgroundColor: ArezueColors.secondaryColor,
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
            body: bodyContent(snapshot.data.jobseeker.uid),
            floatingActionButton: createButton(),
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
    int counter=0;
    for(keys in minidata.keys){
      widgetlist.add(selectResume(keys, minidata[keys]['name'], minidata[keys], uid));
      counter++;
    }
    return widgetlist;
  }

  bodyContent(String uid) {
    List<Widget> list = listWidgets(uid);
    if(list.length==0){
      return Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Text(
            "You have no resumes on your account! Press the + button to add a new resume.",
            style: TextStyle(
              color: ArezueColors.outPrimaryColor,
              fontSize: 20,
              fontFamily: 'Arezue',
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Center(
      child: ListView(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
        children: <Widget>[
          Column(
            children: list,
          ),
        ],
      ),
    );
  }
}
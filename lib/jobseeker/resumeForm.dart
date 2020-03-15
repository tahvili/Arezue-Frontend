import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/jobseeker/information.dart';
import 'package:arezue/components/resumeField.dart';
import '../loading.dart';

class ResumeFormPage extends StatefulWidget {
  @override
  ResumeFormPage({this.auth, this.resumeId, this.resumeName, this.uid});
  final BaseAuth auth;
  final String resumeId;
  final String uid;
  final String resumeName;

  @override
  _ResumeFormPageState createState() => new _ResumeFormPageState ();
}
class _ResumeFormPageState extends State<ResumeFormPage>{

  Map<String, dynamic> data;
  Requests request = new Requests();
  Future<JobseekerInfo> uData;
  List<String> dream_career = [];
  var resumeNameController = TextEditingController();
  final regExp = new RegExp(r'(?:\[)?(\[[^\]]*?\](?:,?))(?:\])?');

  void updateHandler(String endpoint, List list){
    if(endpoint=="/dream_career") {
      dream_career = list;
    }
  }

  @override
  void dispose() {
    resumeNameController.dispose();
    super.dispose();
  }

  Future<JobseekerInfo> FetchData() async {
    if(widget.resumeId!=null){
      data = await request.resumeGetData(widget.uid, widget.resumeId);
      dream_career =
          regExp.allMatches(data['resume']['dream_career']).map((m) =>
              m.group(1)).map((String item) =>
              item.replaceAll(new RegExp(r'[\[\],]'), ''))
              .map((m) => m)
              .toList();
    }

    return await request.profileGetRequest(widget.auth.currentUser());
  }

  Widget resumeButton(String title, String endpoint, List original, List list) {
    return SizedBox(
      width: MediaQuery.of(context).size.width-100,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResumeField(
                    title: title,
                    endpoint: endpoint,
                    list: list,
                    original: original,
                    handler: updateHandler
                )),
          );
        },
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
        color: ArezueColors.outSecondaryColor,
        child: Text(title,
            style: TextStyle(color: ArezueColors.outPrimaryColor)),
      ),
    );
  }

  Widget saveButton(String uid, String resumeId) {
    return SizedBox(
      width: MediaQuery.of(context).size.width-100,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () async {
          var finalData = {"name":resumeNameController.text,"dream_career": dream_career.toString()};
          if(resumeId!=null){
            Future<int> result = request.resumePutRequest(uid, resumeId, finalData);
            if ((await result) == 200){
              Navigator.pop(context);
            }
          }
          else{
            Future<int> result = request.resumePostRequest(uid,finalData);
            if ((await result) == 200){
              Navigator.pop(context);
            }
          }

        },
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
        color: ArezueColors.outSecondaryColor,
        child: Text("Save", style: TextStyle(color: ArezueColors.outPrimaryColor)),
      ),
    );
  }

  Widget deleteButton(String uid, String resumeId) {
    if(resumeId==null){
      return SizedBox(width: MediaQuery.of(context).size.width-100,);
    }
    else{
      return SizedBox(
        width: MediaQuery.of(context).size.width-100,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () async {
            //List<List<String>> finalData = new List<List<String>>();
            Future<int> result = request.resumeDeleteRequest(uid,resumeId);
            if ((await result) == 200){
              Navigator.pop(context);
            }
          },
          padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
          color: ArezueColors.outSecondaryColor,
          child: Text("Delete", style: TextStyle(color: ArezueColors.outPrimaryColor)),
        ),
      );
    }
  }

  Widget resumeName() {
    return Container(
        padding: EdgeInsets.fromLTRB(15,1, 15,1),
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
        child: Row(
          children: <Widget>[
            Text('Name it:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 20),
            Expanded(child:
            TextField(
              controller: resumeNameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter something",
              ),
            ),
            ),
          ],
        )
    );
  }

  @override
  void initState() {
    super.initState();
    uData = FetchData();
    resumeNameController = TextEditingController(text: widget.resumeName);
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
            body: Container(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
              child: Column(
                children: <Widget>[
                  //Make objects of the parent using the custom child widget created.
                  Text(
                    "Build your perfect resume!",
                    style: TextStyle(
                      color: ArezueColors.outPrimaryColor,
                      fontSize: 20,
                      fontFamily: 'Arezue',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 18,),
                  resumeName(),
                  resumeButton("Choose Your Career","/dream_career", List<String>.from(
                      snapshot.data.jobseeker.information.dreamCareer.careers), dream_career),
                  //resumeButton("Companies in the field","/dream_companies"),
                  //resumeButton("Skills you have for this","/skills"),
                  //resumeButton("Experiences you bring","/exp"),
                  saveButton(snapshot.data.jobseeker.uid, widget.resumeId),
                  deleteButton(snapshot.data.jobseeker.uid, widget.resumeId),
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
}
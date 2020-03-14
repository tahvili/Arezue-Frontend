import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/jobseeker/information.dart';
import 'package:arezue/components/resumeField.dart';
import '../loading.dart';

class ResumeFormPage extends StatefulWidget {
  ResumeFormPage({this.auth, this.resumeId});
  final BaseAuth auth;
  final String resumeId;
  @override
  _ResumeFormPageState createState() => new _ResumeFormPageState ();
}
class _ResumeFormPageState extends State<ResumeFormPage>{
  Map<String, dynamic> data;
  Requests request = new Requests();
  Future<JobseekerInfo> uData;
  List<String> dream_career = [];
  final resumeNameController = TextEditingController();

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

  Widget saveButton(String uid) {
    return SizedBox(
      width: MediaQuery.of(context).size.width-100,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () async {
          //List<List<String>> finalData = new List<List<String>>();
          var finalData = {"name":resumeNameController.text,"career": dream_career.toString()};
          Future<int> result = request.resumePostRequest(uid,finalData);

          if ((await result) == 200){
            Navigator.pop(context);
          }
        },
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
        color: ArezueColors.outSecondaryColor,
        child: Text("Save", style: TextStyle(color: ArezueColors.outPrimaryColor)),
      ),
    );
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
    print("Profile init, this is where we make the API call /profile");
    setState(()
    {data = {"acceptance_wage": 100, "relocate": "Yes"};}
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
            saveButton(snapshot.data.jobseeker.uid),
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

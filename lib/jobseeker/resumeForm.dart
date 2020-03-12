import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/components/resumeField.dart';

class ResumeFormPage extends StatefulWidget {
  ResumeFormPage({this.auth, this.resumeId});
  final BaseAuth auth;
  final String resumeId;
  @override
  _ResumeFormPageState createState() => new _ResumeFormPageState ();
}
class _ResumeFormPageState extends State<ResumeFormPage>{
  Map<String, dynamic> data;

  Widget ResumeButton(String title, String endpoint) {
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

  Widget ResumeName() {
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
    print("Profile init, this is where we make the API call /profile");
    setState(()
    {data = {"acceptance_wage": 100, "relocate": "Yes"};}
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
            ResumeName(),
            ResumeButton("Careers to apply to","/dream_careers"),
            ResumeButton("Companies in the field","/dream_companies"),
            ResumeButton("Skills you have for this","/skills"),
            ResumeButton("Experiences you bring","/exp"),
          ],
        ),
      ),
    );
  }}

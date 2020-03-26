import 'package:arezue/Settings.dart';
import 'package:arezue/employer/employer.dart';
import 'package:arezue/employer/searchIntroduction.dart';
import 'package:arezue/employer/job.dart';
import 'package:arezue/loading.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arezue/jobseeker/jobseeker.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/components/searchPage.dart';
import 'package:arezue/utils/texts.dart';
import 'package:http/http.dart' as http;

import '../jobseeker/resumes.dart';

class EmployerHomePage extends StatefulWidget {
  EmployerHomePage({this.auth, this.onSignOut, this.formType});
  final BaseAuth auth;
  final FormType4 formType;
  final VoidCallback onSignOut;

  @override
  _EmployerPageState createState() => new _EmployerPageState(formType: this.formType, auth: this.auth);
}

enum FormType4 { employer, jobseeker }

class _EmployerPageState extends State<EmployerHomePage> {
  FormType4 formType;

  _EmployerPageState({this.formType, this.auth});

  Future<Jobseeker> futureUser;
  final BaseAuth auth;
  Future<Employer> futureEmployer;
  Requests request = new Requests();
  bool activelyHiring = false;
  Requests serverRequest = new Requests();

  @override
  void initState() {
    //calling the appropriate http get request
    super.initState();
    if (this.formType == FormType4.jobseeker) {
      futureUser = request.jobseekerGetRequest(widget.auth.currentUser());
    } else {
      futureEmployer = request.employerGetRequest(widget.auth.currentUser());
    }
  }

  Widget _getProfile() {
    return FutureBuilder<Employer>(
      future: futureEmployer,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var companyName = snapshot.data.name.split(" ");
          if (snapshot.data.profilePicture == null) {
            return CircleAvatar(
              backgroundColor: ArezueColors.primaryColor,
              foregroundColor: ArezueColors.secondaryColor,
              radius: 50,
              child: Text(companyName[0][0] + companyName[companyName.length - 1][0],
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            );
          } else {
            return CircleAvatar(
              backgroundColor: ArezueColors.primaryColor,
              foregroundColor: ArezueColors.secondaryColor,
              radius: 50,
              child: ClipOval(
                child: new SizedBox(
                  width: 130,
                  height: 130,
                  child: new Image.asset(snapshot.data.profilePicture,
                      fit: BoxFit.cover),
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return Loading();
      },
    );
  }

  Widget companyProfile() {
    return FutureBuilder<Employer>(
      future: futureEmployer,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: Container(
              child: _getProfile(),
              width: 140.0,
              height: 140.0,
              decoration: new BoxDecoration(
                border: Border.all(
                  color: ArezueColors
                      .greenColor, //                   <--- border color
                  width: 4.0,
                ),
                color: ArezueColors.primaryColor, // border color
                shape: BoxShape.circle,
              ),
            ),
            width: 155.0,
            height: 155.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: ArezueColors
                    .primaryColor, //                   <--- border color
                width: 4.0,
              ),
              color: ArezueColors.primaryColor, // border color
              shape: BoxShape.circle,
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
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
  final middleSectionEmployer = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: ArezueColors.primaryColor,
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
      child: Column(
        children: <Widget>[
          Text("0",style: TextStyle(
            color: ArezueColors.outPrimaryColor,
            fontSize: 20,
            fontFamily: 'Arezue',
            fontWeight: FontWeight.w400,
          ), textAlign: TextAlign.center),
          Text("accepted interview requests", textAlign: TextAlign.center),
        ],
      ));
  final leftSectionEmployer = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(10),
            bottomLeft: const Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          Text("0",style: TextStyle(
            color: ArezueColors.outPrimaryColor,
            fontSize: 20,
            fontFamily: 'Arezue',
            fontWeight: FontWeight.w400,
          ), textAlign: TextAlign.center),
          Text("successful job searches made", textAlign: TextAlign.center),
        ],
      ));
  final rightSectionEmployer = Container(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    decoration: BoxDecoration(
      borderRadius: new BorderRadius.only(
          topRight: const Radius.circular(10),
          bottomRight: const Radius.circular(10)),
    ),
    child: Column(
      children: <Widget>[
        Text("0",style: TextStyle(
          color: ArezueColors.outPrimaryColor,
          fontSize: 20,
          fontFamily: 'Arezue',
          fontWeight: FontWeight.w400,
        ), textAlign: TextAlign.center),
        Text("interview requests sent", textAlign: TextAlign.center),
      ],
    ),
  );
  final activityBox = Container(

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
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("We can't find your resume"),
            addNowButton,
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("What are your dream companies?"),
            addNowButton,
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("What wage are you looking for?"),
            addNowButton,
          ],
        ),
      ],
    ),
  );
  final activityBoxEmployer = Container(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
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
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("What's your company's logo?"),
            addNowButton,
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Company's address?"),
            addNowButton,
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Have a website?"),
            addNowButton,
          ],
        ),
      ],
    ),
  );

  static final addNowButton = RaisedButton(
    child: Text('Add now!'),
    onPressed: () {},
  );

  List<Widget> submitWidgets(){
        return [
          ListView(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(
                    right: 50, left: 50, bottom: 20, top: 230),
                alignment: Alignment.center,
                child: FutureBuilder<Employer>(
                  future: futureEmployer,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var fullName = snapshot.data.name.split(" ");
                      var name = "";
                      for (int i = 0; i < fullName.length;i++){
                        if(fullName[i].length>0) {
                          name += " ";
                          name += fullName[i];
                        }
                      }
                      return Text(
                        "Hey," + name + "!",
                        style: TextStyle(
                          color: ArezueColors.outPrimaryColor,
                          fontSize: 25,
                          fontFamily: 'Arezue',
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    } // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.only(
                    right: 50, left: 50, bottom: 20, top: 0),
                height: 125,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(child: leftSectionEmployer),
                    Expanded(child: middleSectionEmployer),
                    Expanded(child: rightSectionEmployer),
                  ],
                ),
              ),
              activityBoxEmployer,
            ],
          ),
          new Container(
            color: ArezueColors.appBarColor,
            height: 150,
          ),
          new Positioned(
            top: (155 / 2) + 10,
            left: 15,
            child: IconButton(
              color: Colors.white,
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchIntro(
                      auth: widget.auth,
                    )),
                );
              },
            ),
          ),new Positioned(
            top: (155 / 2) + 10,
            left: 65,
            child: IconButton(
              color: Colors.white,
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => JobPage(auth: this.auth,
                    ))
                );
              },
            ),
          ),
          new Positioned(
            top: (155 / 2) + 10,
            left: MediaQuery.of(context).size.width - 115,
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.layers, color: Colors.white),
              onPressed: () {},
            ),
          ),
          new Positioned(
            top: (155 / 2) + 10,
            left: MediaQuery.of(context).size.width - 65,
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsPage(
                            auth: widget.auth,
                            onSignOut: widget.onSignOut,
                            formType: FormType2.employer,
                          ),
                  ),
                );
              },
            ),
          ),
          new Positioned(
            top: (155 / 2),
            left: (MediaQuery.of(context).size.width / 2) - (155 / 2),
            height: 155,
            width: 155,
            child: Center(child: companyProfile()),
          ),
        ];
    }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          overflow: Overflow.visible,
          children: submitWidgets(),
        ),
      ),
    );
  }
}

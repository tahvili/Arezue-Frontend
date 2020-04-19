/// Employer's Home Page
///
/// Here is the user dashboard, where they may navigate to any section that they want

import 'package:arezue/Settings.dart';
import 'package:arezue/employer/employer.dart';
import 'package:arezue/employer/searchIntroduction.dart';
import 'package:arezue/employer/job.dart';
import 'package:arezue/loading.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arezue/services/auth.dart';

class EmployerHomePage extends StatefulWidget {
  EmployerHomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  //final FormType4 formType;
  final VoidCallback onSignOut;

  @override
  _EmployerPageState createState() => new _EmployerPageState(auth: this.auth);
}

class _EmployerPageState extends State<EmployerHomePage> {
  _EmployerPageState({this.auth});

  final BaseAuth auth;
  Future<Object> futureEmployer;
  Requests request = new Requests();
  String name = "";
  String initial = "";
  String userUid = "";
  String profilePicture = "";
  Requests serverRequest = new Requests();

  @override
  void initState() {
    //calling the appropriate http get request
    super.initState();
    futureEmployer =
        (request.getRequest(widget.auth.currentUser(), 'employer'));
  }

  Widget _getProfile() {
    // Profile picture
    if (profilePicture == null) {
      return CircleAvatar(
        backgroundColor: ArezueColors.primaryColor,
        foregroundColor: ArezueColors.secondaryColor,
        radius: 50,
        child: Text(initial,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
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
            child: new Image.asset(profilePicture, fit: BoxFit.cover),
          ),
        ),
      );
    }
  }

  Widget companyProfile() {
    // Profile area + border
    return Container(
      child: Container(
        child: _getProfile(),
        width: 140.0,
        height: 140.0,
        decoration: new BoxDecoration(
          border: Border.all(
            color:
                ArezueColors.greenColor, //                   <--- border color
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
          color:
              ArezueColors.primaryColor, //                   <--- border color
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
              0.0,
              0.0,
            ),
          ),
        ],
      ),
    );
  }

  final middleSectionEmployer = Container(
      // mid section of the tri-section
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 25.0),
      decoration: BoxDecoration(
        color: ArezueColors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: ArezueColors.shadowColor,
            blurRadius: 10.0,
            spreadRadius: 5.0,
            offset: Offset(
              0.0,
              0.0,
            ),
          ),
        ],
      ),
      child: Wrap(
        children: <Widget>[
          Center(
            child: Text("0",
                style: TextStyle(
                  color: ArezueColors.outPrimaryColor,
                  fontSize: 20,
                  fontFamily: 'Arezue',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center),
          ),
          Text("accepted interview requests", textAlign: TextAlign.center),
        ],
      ));
  final leftSectionEmployer = Container(
      // left section of the tri-section
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(10),
            bottomLeft: const Radius.circular(10)),
      ),
      child: Wrap(
        children: <Widget>[
          Center(
            child: Text("0",
                style: TextStyle(
                  color: ArezueColors.outPrimaryColor,
                  fontSize: 20,
                  fontFamily: 'Arezue',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center),
          ),
          Text("successful job searches made", textAlign: TextAlign.center),
        ],
      ));
  final rightSectionEmployer = Container(
    // right section of the tri-section
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    decoration: BoxDecoration(
      borderRadius: new BorderRadius.only(
          topRight: const Radius.circular(10),
          bottomRight: const Radius.circular(10)),
    ),
    child: Wrap(
      children: <Widget>[
        Center(
          child: Text("0",
              style: TextStyle(
                color: ArezueColors.outPrimaryColor,
                fontSize: 20,
                fontFamily: 'Arezue',
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center),
        ),
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
            0.0,
            0.0,
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
    // activity box of latest changes
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
            0.0,
            0.0,
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

  List<Widget> submitWidgets() {
    return [
      ListView(
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(
                  right: 50, left: 50, bottom: 20, top: 230),
              alignment: Alignment.center,
              child: Text(
                "Hey," + name + "!",
                style: TextStyle(
                  color: ArezueColors.outPrimaryColor,
                  fontSize: 25,
                  fontFamily: 'Arezue',
                  fontWeight: FontWeight.w400,
                ),
              )),
          Container(
            margin:
                const EdgeInsets.only(right: 50, left: 50, bottom: 20, top: 0),
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
                    0.0,
                    0.0,
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
      ),
      new Positioned(
        top: (155 / 2) + 10,
        left: 65,
        child: IconButton(
          color: Colors.white,
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => JobPage(
                          auth: this.auth,
                        )));
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
    return FutureBuilder<Object>(
      future: (request.getRequest(widget.auth.currentUser(), 'employer')),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          setData((snapshot.data as Employer));
          return Scaffold(
            body: Container(
              child: Stack(
                overflow: Overflow.visible,
                children: submitWidgets(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return Loading();
      },
    );
  }

  void setData(Employer data) {
    userUid = data.uid;
    profilePicture = data.profilePicture;
    name = "";
    initial = "";
    var fullName = data.name.split(" ");
    for (int i = 0; i < fullName.length; i++) {
      if (fullName[i].length > 0) {
        name += " ";
        name += fullName[i];
        initial += fullName[i][0];
      }
    }
  }
}

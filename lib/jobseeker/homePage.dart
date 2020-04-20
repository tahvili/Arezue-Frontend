/// Jobseeker's Home Page
///
/// Here is the user dashboard, where they may navigate to any section that they want

import 'package:arezue/Settings.dart';
import 'package:arezue/jobseeker/profile.dart';
import 'package:arezue/jobseeker/resumes.dart';
import 'package:arezue/loading.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arezue/jobseeker/jobseeker.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/utils/texts.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  //final FormType3 formType;
  final VoidCallback onSignOut;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();
  Requests request = new Requests();
  bool activelyLooking = true;
  String name = "";
  String initial = "";
  String userUid = "";
  String profilePicture = "";
  Requests serverRequest = new Requests();

  @override
  void initState() {
    //calling the appropriate http get request
    super.initState();
  }

  Widget lookingButton() {
    //checking if they still want a job
    if (activelyLooking) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: RaisedButton(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                bottomLeft: const Radius.circular(10)),
          ),
          onPressed: () {},
          padding: EdgeInsets.fromLTRB(22, 15, 22, 15),
          color: ArezueColors.greenColor,
          child: Text(ArezueTexts.lookingForJob,
              style:
                  TextStyle(color: ArezueColors.secondaryColor, fontSize: 14)),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: RaisedButton(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                bottomLeft: const Radius.circular(10)),
          ),
          onPressed: () async {
            if (await changeStatus(userUid)) {
              setState(() {});
            }
          },
          padding: EdgeInsets.fromLTRB(22, 15, 22, 15),
          color: ArezueColors.primaryColor,
          child: Text(ArezueTexts.lookingForJob,
              style:
                  TextStyle(color: ArezueColors.secondaryColor, fontSize: 14)),
        ),
      );
    }
  }

  Widget notLookingButton() {
    // checking to see if they are not looking for a job
    if (activelyLooking) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: RaisedButton(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: const Radius.circular(10),
                bottomRight: const Radius.circular(10)),
          ),
          padding: EdgeInsets.fromLTRB(22, 15, 22, 15),
          color: ArezueColors.primaryColor,
          onPressed: () async {
            if (await changeStatus(userUid)) {
              setState(() {});
            }
          },
          child: Text(ArezueTexts.notLookingAnymore,
              style:
                  TextStyle(color: ArezueColors.secondaryColor, fontSize: 14)),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: RaisedButton(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: const Radius.circular(10),
                bottomRight: const Radius.circular(10)),
          ),
          padding: EdgeInsets.fromLTRB(22, 15, 22, 15),
          onPressed: () {},
          color: ArezueColors.yellowColor,
          child: Text(ArezueTexts.notLookingAnymore,
              style:
                  TextStyle(color: ArezueColors.secondaryColor, fontSize: 14)),
        ),
      );
    }
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

  Color getColor() {
    if (activelyLooking) {
      return ArezueColors.greenColor;
    }
    return ArezueColors.yellowColor;
  }

  Widget userProfile() {
    // Borders of the profile picture
    return Container(
      child: Container(
        child: _getProfile(),
        width: 140.0,
        height: 140.0,
        decoration: new BoxDecoration(
          border: Border.all(
            color: getColor(), //                  <--- border color
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

  final middleSection = Container(
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
            child: Text(
              "0",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ArezueColors.outPrimaryColor,
                fontSize: 20,
                fontFamily: 'Arezue',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text("pending interview requests", textAlign: TextAlign.center),
        ],
      ));
  final leftSection = Container(
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
            child: Text(
              "0",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ArezueColors.outPrimaryColor,
                fontSize: 20,
                fontFamily: 'Arezue',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Text("employers scanned your account", textAlign: TextAlign.center),
        ],
      ));
  final rightSection = Container(
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
          child: Text(
            "0",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ArezueColors.outPrimaryColor,
              fontSize: 20,
              fontFamily: 'Arezue',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text("employers viewed your resume ", textAlign: TextAlign.center),
      ],
    ),
  );

  final activityBox = Container(
    // latest changes to the account
    margin: const EdgeInsets.only(right: 50, left: 50, bottom: 20, top: 0),
    //height: 200,
    padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
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
            Text("Let's add your resume!"),
            addNowButton,
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Your dream companies?"),
            addNowButton,
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Your ideal wage?"),
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
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(right: 50, left: 50, bottom: 20, top: 0),
            child: Row(
              children: <Widget>[
                Expanded(child: lookingButton()),
                Expanded(child: notLookingButton()),
              ],
            ),
          ),
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
                Expanded(child: leftSection),
                Expanded(child: middleSection),
                Expanded(child: rightSection),
              ],
            ),
          ),
          activityBox,
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
            Icons.create,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Profile(
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
            Icons.center_focus_strong,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ),
      new Positioned(
        top: (155 / 2) + 10,
        left: MediaQuery.of(context).size.width - 115,
        child: IconButton(
          color: Colors.white,
          icon: Icon(Icons.layers, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResumePage(
                        auth: widget.auth,
                      )),
            );
          },
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
                        formType: FormType2.jobseeker,
                      )),
            );
          },
        ),
      ),
      new Positioned(
        top: (155 / 2),
        left: (MediaQuery.of(context).size.width / 2) - (155 / 2),
        height: 155,
        width: 155,
        child: Center(
          child: userProfile(),
        ),
      ),
    ];
  }

  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: (request.getRequest(widget.auth.currentUser(), 'jobseeker')),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          setData((snapshot.data as Jobseeker));
          activelyLooking = (snapshot.data as Jobseeker).activeStates;
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

  Future<bool> changeStatus(String uid) async {
    activelyLooking = !activelyLooking;
    if (await request.putRequest("jobseeker/$uid", "x-www-form-urlencoded",
            {"active_States": activelyLooking.toString()}, false) ==
        200) {
      return true;
    }
    return false;
  }

  void setData(Jobseeker data) {
    activelyLooking = data.activeStates;
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

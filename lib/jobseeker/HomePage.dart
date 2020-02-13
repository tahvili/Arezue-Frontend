import 'package:arezue/Settings.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:arezue/user.dart';
import 'package:arezue/jobseeker/jobseeker.dart';
import 'package:arezue/auth.dart';
import 'package:arezue/utils/texts.dart';

var user = new User();
var fullName = user.getName().split(" ");


class JobseekerHomePage extends StatefulWidget {
  JobseekerHomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  @override
  _HomePageState createState() => new _HomePageState();
}


Widget lookingButton() {
  if(user.activeStates=='true') {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: RaisedButton(
        elevation:5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: const Radius.circular(10),
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
  }
  else {
    return Padding(

      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: RaisedButton(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: const Radius.circular(10),
              bottomLeft: const Radius.circular(10)),
        ),
        onPressed: () {user.changeStatus();},
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
  if(user.isActive()=='true') {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: RaisedButton(
        elevation:5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: const Radius.circular(10),
              bottomRight: const Radius.circular(10)),
        ),
        onPressed: () {user.changeStatus();},
        padding: EdgeInsets.fromLTRB(22, 15, 22, 15),
        color: ArezueColors.primaryColor,
        child: Text(ArezueTexts.notLookingAnymore,
            style:
            TextStyle(color: ArezueColors.secondaryColor, fontSize: 14)),
      ),
    );
  }
  else {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      child: RaisedButton(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: const Radius.circular(10),
              bottomRight: const Radius.circular(10)),
        ),
        onPressed: () {},
        padding: EdgeInsets.fromLTRB(22, 15, 22, 15),
        color: ArezueColors.greenColor,
        child: Text(ArezueTexts.notLookingAnymore,
            style:
            TextStyle(color: ArezueColors.secondaryColor, fontSize: 14)),
      ),
    );
  }
}

CircleAvatar _getProfile(){
  if(user.getProfilePicture()==null){
    return CircleAvatar(
      backgroundColor: ArezueColors.primaryColor,
      foregroundColor: ArezueColors.secondaryColor,
      radius:50,
      child: Text(fullName[0][0]+fullName[fullName.length-1][0], style: TextStyle(fontWeight: FontWeight.bold,fontSize:20.0)),
    );
  }
  else{
    return CircleAvatar(
      backgroundColor: ArezueColors.primaryColor,
      foregroundColor: ArezueColors.secondaryColor,
      radius:50,
      child: ClipOval(
        child: new SizedBox(
          width:130,
          height:130,
          child: new Image.asset(user.getProfilePicture(),fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _HomePageState extends State<JobseekerHomePage> {

  final userProfile = Container(
      child: Container(
              child: _getProfile(),
              width: 140.0,
              height: 140.0,
              decoration: new BoxDecoration(
                border: Border.all(
                  color: ArezueColors.greenColor, //                   <--- border color
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
          color: ArezueColors.primaryColor, //                   <--- border color
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

  final middleSection = Container(
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
          Text("0", textAlign: TextAlign.center),
          Text("pending interview requests", textAlign: TextAlign.center),
        ],
      ));
  final leftSection = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(10),
            bottomLeft: const Radius.circular(10)
        ),
      ),
      child: Column(
        children: <Widget>[
          Text("0", textAlign: TextAlign.center),
          Text("employers scanned your account", textAlign: TextAlign.center),
        ],
      ));
  final rightSection = Container(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    decoration: BoxDecoration(
      borderRadius: new BorderRadius.only(
          topRight: const Radius.circular(10),
          bottomRight: const Radius.circular(10)
      ),
    ),
    child: Column(
      children: <Widget>[
        Text(
          "0",
          textAlign: TextAlign.center,
        ),
        Text("employers viewed your resume ", textAlign: TextAlign.center),
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

  static final addNowButton = RaisedButton(
    child: Text('Add now!'),
    onPressed: () {},
  );


  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:
        Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                        right: 50, left: 50, bottom: 20, top: 230),
                    alignment: Alignment.center,
                    child: Text(
                      "Hey, " + user.getName() + "!",
                      style: TextStyle(
                        color: ArezueColors.outPrimaryColor,
                        fontSize: 25,
                        fontFamily: 'Arezue',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
//                  Container(
//                    margin: const EdgeInsets.only(
//                        right: 50, left: 50, bottom: 20, top: 0),
//                    width: 50,
//                    height: 50,
//                    color: Colors.redAccent,
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      children: <Widget>[
//                        Text("Your account is incomplete!"),
//                        RaisedButton(
//                          child: Text('Fix it!'),
//                          onPressed: () {},
//                        ),
//                      ],
//                    ),
//                  ),
                Container (
                  margin: const EdgeInsets.only(
                        right: 50, left: 50, bottom: 20, top: 0),
                  child: Row(
                    children: <Widget>[
                      lookingButton(),
                      notLookingButton(),
                    ],
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
                        Expanded(child: leftSection),
                        Expanded(child: middleSection),
                        Expanded(child: rightSection),
                      ],
                    ),
                  ),
                  activityBox,
                ],
              ),
              new Container(color:ArezueColors.appBarColor,height:150,),
              new Positioned(

                top:(155/2)+10,
                left:15,

                child: IconButton(
                  color: Colors.white,
                  icon: Icon(
                    Icons.create,
                    color: Colors.white,
                  ),
                  onPressed: null,
                ),
              ),

              new Positioned(
                top:(155/2)+10,
                left:MediaQuery.of(context).size.width-65,
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage(
                        auth: widget.auth,
                        onSignOut: widget.onSignOut,
                      )),
                    );
                  },
                ),
              ),

              new Positioned(
                top:(155/2),
                left:(MediaQuery.of(context).size.width/2)-(155/2),
                height:155,
                width: 155,
                child: Center(child:userProfile),
              ),

            ]
        ),
      ),
    );
  }
}

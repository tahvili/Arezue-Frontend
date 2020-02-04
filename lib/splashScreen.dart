import 'package:arezue/auth.dart';
import 'package:arezue/introduction.dart';
import 'package:arezue/jobseeker/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:arezue/utils/colors.dart';
import 'package:arezue/utils/images.dart';
import 'package:arezue/utils/texts.dart';
import 'package:arezue/utils/navigate.dart';
import 'dart:async';

void splashScreen() => runApp(MaterialApp(
      home: Splash(),
    ));

class Splash extends StatefulWidget {

  Splash({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _SplashScreenState extends State<Splash> {

  AuthStatus authStatus = AuthStatus.notSignedIn;
  @override
  void initState() {
    super.initState();

    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus = userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
        print(authStatus);
      });
    });

    Timer(Duration(seconds: 5), () => {
      check()
    });

    //Timer(Duration(seconds: 5), () => Navigate.intro(context));
//    Timer(Duration(seconds: 5), () => Navigator.push(context, building(context) ));
//    Timer(Duration(seconds: 5), () => Navigate.intro(context));
  }

  Widget check(){
    switch (authStatus) {
        case AuthStatus.notSignedIn:
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => Intro(
              auth: widget.auth,
              onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
            ), fullscreenDialog: true),
          );
          break;

        case AuthStatus.signedIn:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => JobseekerHomePage(
              auth: widget.auth,
              onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn)
              ), fullscreenDialog: true),
          );
          break;
      }
  }


  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

//  Widget building(BuildContext context){
//    switch (authStatus) {
//      case AuthStatus.notSignedIn:
//        return new Intro(
//          auth: widget.auth,
//          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
//        );
//      case AuthStatus.signedIn:
//        return new JobseekerHomePage(
//            auth: widget.auth,
//            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn)
//        );
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return view();

  }


    Widget view() {
      return new Scaffold(
        backgroundColor: ArezueColors.outPrimaryColor,
        body: Center(
            child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ArezueImages.logo,
                    Text(ArezueTexts.companyNameLowerCase,
                        style: new TextStyle(
                          color: ArezueColors.outSecondaryColor,
                          fontSize: 50,
                          fontFamily: 'Arezue',
                          fontWeight: FontWeight.w300,
                        )),

                  ],
                ))),
      );

    }

}

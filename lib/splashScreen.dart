/// Splash Screen
///
/// The purpose of this page is to check if there is any form of internet connection.
/// Then it will check to see if user is already logged in or not, and act accordingly.

import 'package:arezue/services/auth.dart';
import 'package:arezue/introduction.dart';
import 'package:arezue/jobseeker/homePage.dart';
import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:connectivity/connectivity.dart';
import 'package:arezue/utils/colors.dart';
import 'package:arezue/utils/images.dart';
import 'package:arezue/utils/texts.dart';
import 'dart:async';

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

enum ConnectivityStatus { Wifi, Cell, Offline }

class _SplashScreenState extends State<Splash> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  StreamSubscription<DataConnectionStatus> listener;
  Timer timer;
  @override
  void initState() {
    super.initState();

    widget.auth.currentUser().then((userId) async {
      bool flag = (await widget.auth.checkEmailVerification()) == true;
      setState(() {
        authStatus = (userId != null) && flag
            ? AuthStatus.signedIn
            : AuthStatus
                .notSignedIn; // Checks to see if a user is logged in or not
      });
    });
    timer = new Timer(
        Duration(seconds: 5),
        () =>
            _checkNetwork()); // Waits for 5 seconds and checks the network connection
  }

  @override
  void dispose() {
    super.dispose();
    listener.cancel();
    timer.cancel();
  }

  void check() {
    // Based on the user status the program will send them to the corresponding pages
    switch (authStatus) {
      case AuthStatus
          .notSignedIn: // If user is not logged in, they will get sent to [Intro]
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Intro(
                    auth: widget.auth,
                    onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
                  ),
              fullscreenDialog: true),
        );
        break;

      case AuthStatus
          .signedIn: // If user is logged in and it is the jobseeker, they will get sent to [HomePage]
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    auth: widget.auth,
                    onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn),
                  ),
              fullscreenDialog: true),
        );
        break;
    }
  }

  _checkInternet() async {
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        // actively listen for status updates
        // this will cause DataConnectionChecker to check periodically
        // with the interval specified in DataConnectionChecker().checkInterval
        // until listener.cancel() is called
        case DataConnectionStatus.connected:
          break;
        case DataConnectionStatus.disconnected:
          break;
      }
    });

    return await DataConnectionChecker().connectionStatus;
  }

  _checkNetwork() async {
    var result = await Connectivity().checkConnectivity();
    var connectionStatus = _getStatus(result);

    DataConnectionStatus intStatus = await _checkInternet();

    if (connectionStatus == ConnectivityStatus.Offline) {
      _showDialog('No Internet', "No connection to internat established");
    } else if (connectionStatus == ConnectivityStatus.Wifi) {
      if (intStatus == DataConnectionStatus.connected) {
        check();
      } else {
        _showDialog("No Internet", "Cannot reach database");
      }
    } else if (connectionStatus == ConnectivityStatus.Cell) {
      if (intStatus == DataConnectionStatus.connected) {
        check();
      } else {
        _showDialog("No Internet", "Cannot reach database");
      }
    }
  }

  _showDialog(title, text) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('Try Again'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _checkNetwork();
                },
              )
            ],
          );
        });
  }

  ConnectivityStatus _getStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cell;

      case ConnectivityResult.wifi:
        return ConnectivityStatus.Wifi;

      case ConnectivityResult.mobile:
        return ConnectivityStatus.Offline;

      default:
        return ConnectivityStatus.Offline;
    }
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return view();
  }

  Widget view() {
    // The view of the splash screen
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

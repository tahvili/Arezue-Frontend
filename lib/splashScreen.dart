import 'package:arezue/services/auth.dart';
import 'package:arezue/introduction.dart';
import 'package:arezue/jobseeker/HomePage.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:arezue/utils/colors.dart';
import 'package:arezue/utils/images.dart';
import 'package:arezue/utils/texts.dart';
import 'package:provider/provider.dart';
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

enum ConnectivityStatus{
  Wifi,
  Cell,
  Offline
}

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
        authStatus =
        (userId != null) && flag ? AuthStatus.signedIn : AuthStatus.notSignedIn;
        print(authStatus);
      });
    });
    timer = new Timer(Duration(seconds: 5), () => _check_network());
  }

  @override
  void dispose() {
    listener.cancel();
    timer.cancel();
  }

  Widget check() {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        Navigator.pop(context);
        Navigator.push(context,
          MaterialPageRoute(builder: (context) =>
              Intro(
                auth: widget.auth,
                onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
              ), fullscreenDialog: true),
        );
        break;

      case AuthStatus.signedIn:
        Navigator.pop(context);
        Navigator.push(context,
          MaterialPageRoute(builder: (context) =>
              JobseekerHomePage(
                auth: widget.auth,
                onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn),
              ), fullscreenDialog: true),
        );
        break;
    }
  }

  _check_internet() async {

    print("The statement 'this machine is connected to the Internet' is: ");
    print(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum value instead of a bool
    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    // prints either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    print("Last results: ${DataConnectionChecker().lastTryResults}");


    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {// actively listen for status updates
      // this will cause DataConnectionChecker to check periodically
      // with the interval specified in DataConnectionChecker().checkInterval
      // until listener.cancel() is called
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          break;
      }
    });

    return await DataConnectionChecker().connectionStatus;
  }

  _check_network() async {
    var result = await Connectivity().checkConnectivity();
    var connectionStatus = _getStatus(result);

    DataConnectionStatus int_status = await _check_internet();

    if (connectionStatus == ConnectivityStatus.Offline) {
      _showDialog('No Internet',
                  "No connection to internat established");
    } else if (connectionStatus == ConnectivityStatus.Wifi) {

      if (int_status == DataConnectionStatus.connected){
        check();
      }else {
        _showDialog("No Internet",
                    "Cannot reach database");
      }
    } else if (connectionStatus == ConnectivityStatus.Cell) {
      if(int_status == DataConnectionStatus.connected) {
        check();
      }
      else {
        _showDialog("No Internet",
            "Cannot reach database");
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
                  _check_network();
                },
              )
            ],
          );
        }
    );
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
//    return MaterialApp(
//      initialRoute: '/',
//      routes: <String, WidgetBuilder>{
//        '/': (context) => view(),
//        '/account': (context) => JobseekerHomePage(auth: widget.auth,onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn)),
//        '/carousel': (context) => Intro(
//          auth: widget.auth,
//          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
//        ),
//      },
//    );
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

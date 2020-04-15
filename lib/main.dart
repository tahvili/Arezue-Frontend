/// Main file of the program that gets ran on launch
///
/// The purpose of this page is to redirect user to the Splash screen for verification

import 'package:flutter/material.dart';
import 'package:arezue/utils/colors.dart';
import 'package:arezue/splashScreen.dart';
import 'package:arezue/services/auth.dart';

bool leading = true;

void main() => runApp(Launcher()); // Launches the program

class Launcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: ArezueColors.outPrimaryColor,
          accentColor: ArezueColors.outSecondaryColor),
      home: Splash(auth: new Auth()), // Sending user to Splash Screen
    );
  }
}

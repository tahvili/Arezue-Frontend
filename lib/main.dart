import 'package:flutter/material.dart';
import 'package:arezue/utils/colors.dart';
import 'package:arezue/splashScreen.dart';
import 'package:arezue/services/auth.dart';

bool leading = true;

void main() => runApp(Launcher());

class Launcher extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          theme: ThemeData(
              primaryColor: ArezueColors.outPrimaryColor,
              accentColor: ArezueColors.outSecondaryColor),
          debugShowCheckedModeBanner: false,
          home: Splash(auth: new Auth()),
    );

  }

}

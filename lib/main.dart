import 'package:flutter/material.dart';
import 'package:arezue/utils/colors.dart';
import 'package:arezue/splashScreen.dart';
import 'package:arezue/introduction.dart';

bool leading = true;

void main() => runApp(Launcher());

var routes = <String, WidgetBuilder>{
  "/intro": (BuildContext context) => Intro(),
};

class Launcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: ArezueColors.outPrimaryColor,
            accentColor: ArezueColors.outSecondaryColor),
        debugShowCheckedModeBanner: false,
        home: Splash(),
        routes: routes);
  }
}

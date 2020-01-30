import 'package:flutter/material.dart';
import 'package:arezue/utils/colors.dart';
import 'package:arezue/splashScreen.dart';
import 'package:arezue/introduction.dart';
import 'package:arezue/provider.dart';
import 'package:arezue/auth.dart';

bool leading = true;

void main() => runApp(Launcher());

var routes = <String, WidgetBuilder>{
  "/intro": (BuildContext context) => Intro(),
};

class Launcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: Auth() ,
      child: MaterialApp(
          theme: ThemeData(
              primaryColor: ArezueColors.outPrimaryColor,
              accentColor: ArezueColors.outSecondaryColor),
          debugShowCheckedModeBanner: false,
          home: Splash(),
          routes: routes),
    );
  }
}

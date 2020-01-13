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
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),() => Navigate.Intro(context));
  }
  @override
  Widget build(BuildContext context){
    return new Scaffold(
        backgroundColor: ArezueColors.IntroBackgroundColor,
        body: Center(
            child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ArezueImages.Logo,
                    Text(ArezueTexts.CompanyNameLowerCase,
                        style: new TextStyle(
                          color: ArezueColors.IntroTextColor,
                          fontSize: 50,
                          fontFamily: 'Arezue',
                          fontWeight: FontWeight.w300,
                        )),
                  ],
                )))
    );
  }
}
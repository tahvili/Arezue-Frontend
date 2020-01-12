import 'package:flutter/material.dart';
import 'package:arezue/utils/colors.dart';
import 'package:arezue/utils/images.dart';
import 'package:arezue/utils/texts.dart';

bool leading = true;

void main() {
  runApp(Launcher());
}

class Launcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                  ))
            ],
          )))),
    );
  }
}

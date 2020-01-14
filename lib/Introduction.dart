import 'package:arezue/jobseeker/Registration.dart';
import 'package:arezue/login_page.dart';
import 'package:arezue/utils/images.dart';
import 'package:arezue/utils/texts.dart';
import 'package:flutter/material.dart';
import 'package:arezue/utils/navigate.dart';
import 'package:arezue/utils/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:arezue/utils/navigate.dart';

final List<String> Slides = [
  '',
  ArezueTexts.Slide01,
  ArezueTexts.Slide02,
  ArezueTexts.Slide03,
  ArezueTexts.Slide04
];

final List<String> SlideTexts = [
  ArezueTexts.Slide00_Text,
  ArezueTexts.Slide01_Text,
  ArezueTexts.Slide02_Text,
  ArezueTexts.Slide03_Text,
  ArezueTexts.Slide04_Text
];

final Widget placeholder = Container(color: ArezueColors.IntroBackgroundColor);

final List child = map<Widget>(
  Slides,
  (index, i) {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(i),
            Padding(
              padding: new EdgeInsets.fromLTRB(40, 30, 40, 0),
              child: Text(
                SlideTexts[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ArezueColors.IntroTextColor,
                  fontSize: 24,
                  fontFamily: 'Arezue',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ]),
    );
  },
).toList();

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}

class CarouselWithIndicator extends StatefulWidget {
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      CarouselSlider(
        items: child,
        autoPlay: true,
        viewportFraction: 1.0,
        height: MediaQuery.of(context).size.height - 40,
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        scrollDirection: Axis.horizontal,
        autoPlayInterval: Duration(seconds: 6),
        pauseAutoPlayOnTouch: Duration(seconds: 20),
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
      Positioned(
        bottom: 100,
        child: new Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: map<Widget>(
              Slides,
              (index, url) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(255, 255, 255, 1.0)
                          : Color.fromRGBO(255, 255, 255, 0.5)),
                );
              },
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 20,
        child: new Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: ArezueColors.IntroTextColor),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmployeeRegistration()),
                  );
                },
                padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                color: ArezueColors.IntroBackgroundColor,
                child: Text(ArezueTexts.CreateAccount,
                    style: TextStyle(
                      color: ArezueColors.IntroTextColor,
                      fontSize: 18,
                      fontFamily: 'Arezue',
                      fontWeight: FontWeight.w400,
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: ArezueColors.IntroTextColor),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                color: ArezueColors.IntroTextColor,
                child: Text(ArezueTexts.Signin,
                    style: TextStyle(
                      color: ArezueColors.IntroBackgroundColor,
                      fontSize: 18,
                      fontFamily: 'Arezue',
                      fontWeight: FontWeight.w400,
                    )),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Manually operated Carousel

    return MaterialApp(
      home: Scaffold(
        backgroundColor: ArezueColors.IntroBackgroundColor,
        body: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Column(children: [
                  CarouselWithIndicator(),
                ])),
          ],
        ),
      ),
    );
  }
}

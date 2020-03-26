import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';

class SliderWidget extends StatefulWidget {
  SliderWidget({this.numExperience, this.handler});

  final Function handler;
  final int numExperience;
  @override
  SliderWidgetState createState() => SliderWidgetState(
      numExperience: this.numExperience, handler: this.handler);
}

class SliderWidgetState extends State<SliderWidget> {
  SliderWidgetState({this.numExperience, this.handler});

  Function handler;
  int numExperience;
  double _value = 0.0;

  @override
  void initState() {
    if (this.numExperience == null) {
      _value = 0.0;
    } else {
      _value = numExperience.toDouble();
    }
    super.initState();
  }

  void submitHandler(int value) {
    handler(value, "experience");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //color: Colors.white,
        //padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
        margin: const EdgeInsets.only(right: 50, left: 50, bottom: 20, top: 0),
        width: MediaQuery.of(context).size.width - 100,
        child: Column(
          children: <Widget>[

            Center(child:Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0)),
                  color:ArezueColors.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: ArezueColors.shadowColor,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                      offset: Offset(
                        0.0, // horizontal, move right 10
                        0.0, // vertical, move down 10
                      ),
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 7),
                child: Text(
                  "Years of Experience",
                  style: TextStyle(
                    backgroundColor: ArezueColors.primaryColor,
                    color: ArezueColors.secondaryColor,
                    fontSize: 18,
                    fontFamily: 'Arezue',
                    fontWeight: FontWeight.w600,
                  ),
                ))),


    Center(child:Container(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.only(
    topRight: Radius.circular(10.0),
    topLeft: Radius.circular(10.0),
    bottomRight: Radius.circular(10.0),
    bottomLeft: Radius.circular(10.0)),
    color:ArezueColors.primaryColor,
    boxShadow: [
    BoxShadow(
    color: ArezueColors.shadowColor,
    blurRadius: 10.0,
    spreadRadius: 5.0,
    offset: Offset(
    0.0, // horizontal, move right 10
    0.0, // vertical, move down 10
    ),
    ),
    ],
    ),child:FluidSlider(
      value: _value,
      onChanged: (value) {
        setState(() {
          _value = value;
        });
        submitHandler(value.toInt());
      },
      min: 0.0,
      max: 10.0,
      sliderColor: ArezueColors.secondaryColor,
      thumbColor: ArezueColors.primaryColor,
      start: Text("0",
        style: TextStyle(
          color: ArezueColors.primaryColor,
          fontSize: 24,
          fontFamily: 'Arezue',
          fontWeight: FontWeight.w600,
        ),),
      end: Text("10",
        style: TextStyle(
          color: ArezueColors.primaryColor,
          fontSize: 24,
          fontFamily: 'Arezue',
          fontWeight: FontWeight.w600,
        ),),
    )
    )),

          ],
        ));
  }
}

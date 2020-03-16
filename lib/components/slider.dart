import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';

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
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
        margin: const EdgeInsets.only(right: 50, left: 50, bottom: 20, top: 0),
        width: MediaQuery.of(context).size.width - 100,
        child: Column(
          children: <Widget>[
            Text(
              "Experience",
              style: TextStyle(
                color: ArezueColors.outPrimaryColor,
                fontSize: 18,
                fontFamily: 'Arezue',
                fontWeight: FontWeight.w600,
              ),
            ),
            Material(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.red[700],
                  inactiveTrackColor: Colors.red[100],
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 4.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  thumbColor: Colors.redAccent,
                  overlayColor: Colors.red.withAlpha(32),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                  tickMarkShape: RoundSliderTickMarkShape(),
                  activeTickMarkColor: Colors.red[700],
                  inactiveTickMarkColor: Colors.red[100],
                  valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: Colors.redAccent,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Slider(
                  min: 0,
                  max: 10,
                  divisions: 10,
                  value: _value,
                  label: '$_value',
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                    submitHandler(value.toInt());
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DatePickerField extends StatefulWidget {
  final String date;
  final String title;
  final TextEditingController controller;
  DatePickerField(this.title, this.date, this.controller);
  @override
  _DatePickerState createState() =>
      _DatePickerState(this.title, this.date, this.controller);
}

class _DatePickerState extends State<DatePickerField> {
  _DatePickerState(this.title, this._date, this.controller);
  String title;
  String _date;
  TextEditingController controller;

  @override
  void initState() {
    if (_date == "") {
      _date = "Not set";
    }
    if (this.controller == null) {
      this.controller = TextEditingController();
    }
    controller.text = _date;
    super.initState();
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
      margin: const EdgeInsets.only(right: 50, left: 50, bottom: 20, top: 0),
      decoration: BoxDecoration(
        color: ArezueColors.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: ArezueColors.shadowColor,
            blurRadius: 10.0,
            spreadRadius: 5.0,
            offset: Offset(
              0.0,
              0.0,
            ),
          ),
        ],
      ),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Row(children: <Widget>[
        Icon(
          Icons.date_range,
          size: 18.0,
          color: Colors.black87,
        ),
        SizedBox(width: 10),
        Text("${this.title}:"),
        SizedBox(width: 15),
        Expanded(
            child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
          ),
          onTap: () {
            DatePicker.showDatePicker(context,
                theme: DatePickerTheme(
                  containerHeight: 210.0,
                ),
                showTitleActions: true,
                minTime: DateTime(1975, 1, 1),
                maxTime: DateTime(2050, 12, 31), onConfirm: (date) {
              print('confirm $date');
              _date = '${date.year}-${date.month}-${date.day}';
              controller.text = _date;
              setState(() {});
              //submitHandler(_date);
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
        )),
      ]),
    );
  }
}

import 'package:flutter/material.dart';

class Navigate {

  static void Home(BuildContext context) {
    Navigator.pushNamed(context, "/home");
  }

  static void Intro(BuildContext context) {
    Navigator.pushNamed(context, "/intro");
  }
}
import 'package:flutter/material.dart';

class Navigate {
  static void home(BuildContext context) {
    Navigator.pushNamed(context, "/home");
  }

  static void intro(BuildContext context) {
    Navigator.pushNamed(context, "/intro");
  }
}

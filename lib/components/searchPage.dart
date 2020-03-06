import 'package:arezue/services/auth.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget{

  //SearchPage((this.auth));
  final BaseAuth auth;
  final String title;
  final String description;


  @override
  _SearchPageState createState() => new _SearchPageState();
  }

  class _SearchPageState extends State<SearchPage>{

  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea (
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar(),
        ),
      ),
    );
  }
}
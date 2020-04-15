/// Search page when clicked on searching for anything, except the main candidate search

import 'package:arezue/services/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate<String> {
  Search({
    this.handler,
    this.fieldId,
    this.category,
    this.uid
  });

  Function handler;
  final String uid;
  final String fieldId;
  final String category;
  Requests serverRequest = new Requests();
  final List<String> nonSearchList = [];
  List<String> suggestionList;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

   getList() async{
    this.suggestionList = List<String>.from(await serverRequest.searchListGetRequest(this.uid, this.category, query));
    if(this.suggestionList.isEmpty && query.isNotEmpty){
      this.suggestionList.add(query);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty){
      this.suggestionList = [];
    }
    return FutureBuilder(
      future: getList(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return ListView.builder(
          itemBuilder: (context, index) => ListTile(
            onTap: () {
              //when the user selects the option
              close(context, suggestionList[index]);
            },
            leading: Icon(Icons.business_center),
            title: RichText(
                text: TextSpan(
                  text: suggestionList[index],
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.normal),
//          children: [
//            TextSpan(
//              text: suggestionList[index].substring(suggestionList[index].indexOf(query),
//                  suggestionList[index].indexOf(query) + query.length),
//              style: TextStyle(color: Colors.black),
//            ),
//            TextSpan(
//              text: suggestionList[index].substring(suggestionList[index].
//              indexOf(query) + query.length),
//              style: TextStyle(color: Colors.grey),
//            ),
//          ],
                )),
          ),
          itemCount: suggestionList.length,
        );
      }
    );

  }
}


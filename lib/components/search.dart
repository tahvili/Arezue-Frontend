import 'package:arezue/services/http.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate<String> {
  Search({
    this.handler,
    this.fieldId,
  });

  Function handler;
  final String fieldId;
  Requests serverRequest = new Requests();
  final List<String> list = [
    "App Dev",
    "Software Dev",
    "Program Manager",
    "Data Analyst",
    "Business Analyst"
  ];
  final List<String> nonSearchList = [];

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
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList = query.isEmpty
        ? nonSearchList
        : list.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          //when the user selects the option
//          showResults(context);
          close(context, suggestionList[index]);
          //handler(suggestionList[index], 'ranking', "add");
        },
        leading: Icon(Icons.business_center),
        title: RichText(
            text: TextSpan(
          text: suggestionList[index].substring(0, query.length),
          style: TextStyle(
              color: ArezueColors.secondaryColor, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: suggestionList[index].substring(query.length),
              style: TextStyle(color: Colors.grey),
            )
          ],
        )),
      ),
      itemCount: suggestionList.length,
    );
  }
}

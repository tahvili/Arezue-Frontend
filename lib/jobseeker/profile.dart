import 'package:arezue/components/textfield.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/jobseeker/jobseeker.dart';
import 'package:arezue/utils/colors.dart';
import 'package:arezue/components/inputChip.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }

}

class _ProfilePageState extends State<Profile> {
  Future<Jobseeker> futureUser;
  Requests request = new Requests();
  //State variable
  Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    print("Profile init, this is where we make the API call /profile");
//    futureUser = request.jobseekerGetRequest(widget.auth.currentUser());
//    futureUser.then((user){
//      setState(()
//      {data = {"acceptance_wage": 100, "relocate": "Yes"};}
//      );
//    });
    setState(()
    {data = {"acceptance_wage": 100, "goal_wage": 140, "relocate": "Yes",
      "skills": ["Java", "Python", "Algorithm Analysis"] };}
    );
  }

  //This handler is passed into the stateless widgets of the profile page.
  //The reason we create a handler in the parent (stateful class) and pass it down to the children
  // is so that when the child changes, this method will be triggere which then updates state by calling
  // setState()...
  void textFieldHandler(text, fieldId) {
    print("Parent got: ${text} from ${fieldId}, set state here.");
    setState(() {data[fieldId]=text;});
  }

  void textFieldHandler2(text, fieldId, command) {
    if(command == "add"){
      setState(() {data[fieldId].add(text);});
    }else {
      setState(() {data[fieldId].remove(text);});
    }
    print("Parent got: ${text} from ${fieldId}, set state here.");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ArezueColors.secondaryColor,
          centerTitle: true,
          title: Text('Edit your Profile'),
          actions: <Widget>[
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.help, color: Colors.white),
              onPressed: null,
            )
          ],
    ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30,),
          MyTextField(endpoint: "/api/jobseeker", title: "Acceptance Wage: ",
            fieldId: "acceptance_wage", fieldType: "numeric",
            fieldData: data["acceptance_wage"].toString(), handler: textFieldHandler,),
          MyTextField(endpoint: "/api/jobseeker", title: "Your Goal Wage: ",
            fieldId: "goal_wage", fieldType: "text", fieldData: data["goal_wage"].
            toString(),handler: textFieldHandler,),
          MyTextField(endpoint: "/api/jobseeker", title: "Open to Relocate?",
            fieldId: "relocate", fieldType: "text", fieldData: data["relocate"].
            toString(),handler: textFieldHandler,),
          inputChip(endpoint: "/api/jobseeker", title: "Skills: ",
            fieldId: "skills", fieldType: "text", fieldData: data["skills"]
            ,handler: textFieldHandler2,),
        ],
      ),
    );
  }
}
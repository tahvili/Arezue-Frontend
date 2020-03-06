import 'package:arezue/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
bool leading = true;

void main() => runApp(Launcher());

class Launcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Components',
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      home: Profile()
    );
  }  
}

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
  
}

class ProfileState extends State<Profile> {



  //State variable
  Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    print("Profile init, this is where we make the API call /profile");
    setState(()
    {data = {"acceptance_wage": 100, "relocate": "Yes"};}
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

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: <Widget>[
        ]
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              //Make objects of the parent using the custom child widget created.
              MyTextField(endpoint: "/api/jobseeker", title: "Wage", fieldId: "acceptance_wage", fieldType: "numeric", fieldData: data["acceptance_wage"].toString(), handler: textFieldHandler,),
              SizedBox(height: 8,),
              MyTextField(endpoint: "/api/jobseeker", title: "Reolcate", fieldId: "relocate", fieldType: "text", fieldData: data["relocate"].toString(),handler: textFieldHandler,),
              ],
          ),
        ),
    );
  }
}

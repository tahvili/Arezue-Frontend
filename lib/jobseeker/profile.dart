import 'package:arezue/components/inputChip2.dart';
import 'package:arezue/components/inputChip3.dart';
import 'package:arezue/components/switchTextField.dart';
import 'package:arezue/components/textfield.dart';
import 'package:arezue/jobseeker/information.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/utils/colors.dart';
import 'package:arezue/components/inputChip.dart';
import 'package:flutter/material.dart';
import '../loading.dart';

class Profile extends StatefulWidget {
  Profile({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<Profile> {
  Requests request = new Requests();

  //State variable
  Map<String, dynamic> data;
  Future<JobseekerInfo> uData;

  @override
  void initState() {
    super.initState();
  }

  Future<JobseekerInfo> fetchData() async {
    return await request.profileGetRequest(widget.auth.currentUser());
  }

  //This handler is passed into the stateless widgets of the profile page.
  //The reason we create a handler in the parent (stateful class) and pass it down to the children
  // is so that when the child changes, this method will be triggere which then updates state by calling
  // setState()...
  void textFieldHandler(text, fieldId) {
    setState(() {
      build(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<JobseekerInfo>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
            body: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: ListView(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 50),
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  MyTextField(
                    endpoint: "/api/jobseeker",
                    title: "Acceptance Wage: ",
                    uid: snapshot.data.jobseeker.uid,
                    fieldId: "acceptance_wage",
                    fieldType: "numeric",
                    fieldData: snapshot
                        .data.jobseeker.information.acceptanceWage
                        .toString(),
                    handler: textFieldHandler,
                  ),
                  MyTextField(
                    endpoint: "/api/jobseeker",
                    title: "Your Goal Wage: ",
                    uid: snapshot.data.jobseeker.uid,
                    fieldId: "goal_wage",
                    fieldType: "numeric",
                    fieldData:
                        snapshot.data.jobseeker.information.goalWage.toString(),
                    handler: textFieldHandler,
                  ),
                  MySwitchTextField(
                    endpoint: "/api/jobseeker",
                    title: "Open to Relocate?",
                    uid: snapshot.data.jobseeker.uid,
                    fieldId: "open_relocation",
                    fieldType: "text",
                    fieldData:
                        snapshot.data.jobseeker.information.openRelocation,
                    handler: textFieldHandler,
                  ),
                  InputChipBuilder(
                    endpoint: "/api/jobseeker",
                    uid: snapshot.data.jobseeker.uid,
                    title: "Dream Careers: ",
                    fieldId: "dream_career",
                    fieldType: "text",
                    fieldData: List<String>.from(snapshot
                        .data.jobseeker.information.dreamCareer.careers),
                    handler: textFieldHandler,
                  ),
                  InputChipBuilder(
                    endpoint: "/api/jobseeker",
                    uid: snapshot.data.jobseeker.uid,
                    title: "Dream Companies: ",
                    fieldId: "dream_company",
                    fieldType: "text",
                    fieldData: List<String>.from(snapshot
                        .data.jobseeker.information.dreamCompany.companies),
                    handler: textFieldHandler,
                  ),
                  InputChipBuilder2(
                    endpoint: "/api/jobseeker",
                    uid: snapshot.data.jobseeker.uid,
                    title: "Skills ",
                    fieldId: "skill",
                    fieldType: "text",
                    fieldData: snapshot.data.jobseeker.information.skills,
                    handler: textFieldHandler,
                  ),
                  InputChipBuilder3(
                    endpoint: "/api/jobseeker",
                    uid: snapshot.data.jobseeker.uid,
                    title: "Education ",
                    fieldId: "education",
                    fieldType: "text",
                    fieldData: snapshot.data.jobseeker.information.education,
                    handler: textFieldHandler,
                  ),
                  InputChipBuilder3(
                    endpoint: "/api/jobseeker",
                    uid: snapshot.data.jobseeker.uid,
                    title: "Experience ",
                    fieldId: "experience",
                    fieldType: "text",
                    fieldData: snapshot.data.jobseeker.information.experience,
                    handler: textFieldHandler,
                  ),
                  InputChipBuilder3(
                    endpoint: "/api/jobseeker",
                    uid: snapshot.data.jobseeker.uid,
                    title: "Certification ",
                    fieldId: "certification",
                    fieldType: "text",
                    fieldData:
                        snapshot.data.jobseeker.information.certification,
                    handler: textFieldHandler,
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          return Loading();
        }
      },
    );
  }
}

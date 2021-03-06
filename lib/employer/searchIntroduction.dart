/// Candidate search section's main page
///
/// contains a list of all jobs that the employer can pick from to be able to start the search.

import 'package:arezue/components/searchPage.dart';
import 'package:arezue/employer/jobForm.dart';
import 'package:arezue/employer/jobInformation.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/services/http.dart';
import '../loading.dart';
import 'employer.dart';

class SearchIntro extends StatefulWidget {
  SearchIntro({
    this.auth,
  });
  final BaseAuth auth;
  @override
  _JobPageState createState() => new _JobPageState(this.auth);
}

class _JobPageState extends State<SearchIntro> {
  _JobPageState(this.auth);

  final BaseAuth auth;
  String uid;
  Map<String, dynamic> sendList = new Map<String, dynamic>();
  Map<String, dynamic> data;
  Requests request = new Requests();
  List<String> resumeData;
  String companyName;
  Future<Object> futureEmployer;

  @override
  void initState() {
    super.initState();
  }

  Future<Job> fetchData() async {
    // Fetch jobs openings from employer account
    uid = await (widget.auth.currentUser());
    this.futureEmployer = (request.getRequest(widget.auth.currentUser(), 'employer'));
    return await request.jobGetRequest(uid);
  }

//  getCompanyName() async {
//    return ((await futureEmployer) as Employer).companyID;
//  }

  Widget selectJob(JobData job) {
    // Goes to search page with the selected job
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          //sendList = sendEditListGenerator(job);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchPage(
                      auth: widget.auth,
                      uid: uid,
                      jobId: job.jobId,
                    )
            ),
          );
        },
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
        color: ArezueColors.outSecondaryColor,
        child: Text(job.title,
            style: TextStyle(color: ArezueColors.outPrimaryColor)),
      ),
    );
  }

  Map<String, dynamic> sendListGenerator() {
    Map<String, dynamic> sendList = {
      "Title": "",
      //"Position": "",
      "Wage": "",
      "Hours": "",
      "Location": "",
      "Status": "",
      "Description": "",
      "Maximum Candidates": "",
      //"company_name": "",
    };
    return sendList;
  }

  Map<String, dynamic> sendEditListGenerator(JobData job) {
    Map<String, dynamic> sendList = {
      "Title": job.title,
      //"Position": job.position,
      "Wage": job.wage,
      "Hours": job.hours,
      "Location": job.location,
      "Status": job.status,
      "Description": job.description,
//      "date_posted": job.datePosted,
//      "Expiry Date": job.expiryDate,
      "Maximum Candidates": job.maxCandidate,
//      "company_name": job.companyName,
    };
    return sendList;
  }

  Widget createButton() {
    // Add a new job posting
    return FloatingActionButton(
      onPressed: () async {
        String c = ((await futureEmployer) as Employer).companyID.toString();
        sendList = sendListGenerator();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => JobForm(
                    auth: widget.auth,
                    uid: this.uid,
                    objectList: this.sendList,
                    isNew: true,
                    companyName: c,
                    title: "Add a new Job Posting",
                  )),
        );
      },
      child: Icon(Icons.add),
      backgroundColor: ArezueColors.secondaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Main build function for the page
    return FutureBuilder<Job>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: ArezueColors.secondaryColor,
              title: Text('Job Search'),
              actions: <Widget>[
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.help, color: Colors.white),
                  onPressed: null,
                )
              ],
            ),
            body: bodyContent(snapshot.data.jobData),
            floatingActionButton: createButton(),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          return Loading();
        }
      },
    );
  }

  List<Widget> listWidgets(List<JobData> listJobs) {
    List<Widget> widgetList = new List<Widget>();
    if (listJobs == null) {
      widgetList = [];
    } else {
      for (JobData job in listJobs) {
        widgetList.add(selectJob(job));
      }
    }
    return widgetList;
  }

  bodyContent(List<JobData> listJobs) {
    // When there is no jobs available
    List<Widget> list = listWidgets(listJobs);
    if (list.length == 0) {
      return Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Text(
            "You have no job postings on your account! Press the + button to add a new job posting.",
            style: TextStyle(
              color: ArezueColors.outPrimaryColor,
              fontSize: 20,
              fontFamily: 'Arezue',
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Center(
      child: ListView(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 15),
              child: Text(
                "Please select a job to start the search...",
                style: TextStyle(
                  color: ArezueColors.outPrimaryColor,
                  fontSize: 16,
                  fontFamily: 'Arezue',
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Column(
            children: list,
          ),
        ],
      ),
    );
  }
}

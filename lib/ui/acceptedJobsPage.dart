import 'dart:async';

import 'package:atmonitor/handlers/jobsHandle.dart';
import 'package:atmonitor/ui/masterDrawer.dart';
import 'package:atmonitor/ui/onGoingJobDetailsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcceptedJobsPage extends StatefulWidget {
  @override
  _AcceptedJobsPageState createState() => _AcceptedJobsPageState();
}

class _AcceptedJobsPageState extends State<AcceptedJobsPage> {
  JobsHandle jobsHandle = JobsHandle();
  String id = "";
  String role = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pekerjaan Aktif"),
        centerTitle: true,
      ),
      drawer: MasterDrawer(1),
      body: StreamBuilder(
          stream: role == "Teknisi PKT"
              ? jobsHandle.getAcceptedJobs(id)
              : jobsHandle.getAcceptedJobsVendor(id),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Center();
            List<DocumentSnapshot> jobs = snapshot.data.documents;
            return ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (BuildContext context, int position) {
//                  if (snapshot.connectionState != ConnectionState.done) {
//                    return Center(child: CircularProgressIndicator());
//                  }
                  String location = jobs[position].data["location"].toString();
                  String problem =
                      jobs[position].data["problemDesc"].toString();
                  return Card(
                    child: Container(
                      child: ListTile(
                        title: Text("$location"),
                        subtitle: Text("$problem"),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          pressDetailShow(jobs, position);
                        },
                        onLongPress: longPressDetailShow(),
                      ),
                    ),
                  );
                });
          }),
    );
  }

  //on press, go to detail page
  pressDetailShow(List<DocumentSnapshot> jobs, int position) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OnGoingJobDetailsPage(
                  jobs,
                  position,
                )));
  }

  //on long press show... nothing for the time being...
  longPressDetailShow() {}

  //get user id
  Future<Null> getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString("userid");
      role = prefs.getString("role");
    });
  }
}

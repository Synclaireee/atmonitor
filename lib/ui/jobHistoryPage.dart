import 'package:atmonitor/handlers/historyHandle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JobHistoryPage extends StatefulWidget {
  final List<DocumentSnapshot> jobs;
  final int position;

  JobHistoryPage(this.jobs, this.position);

  @override
  _JobHistoryPageState createState() => _JobHistoryPageState();
}

class _JobHistoryPageState extends State<JobHistoryPage> {
  @override
  Widget build(BuildContext context) {
    HistoryHandle historyHandle = HistoryHandle(widget.jobs, widget.position);
    return Scaffold(
        appBar: AppBar(
          title: Text("Data Historik"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: historyHandle.getMachineHistory(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) return Center();
            List<DocumentSnapshot> jobs = snapshot.data.documents;
            return ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (BuildContext context, int position) {
                  String date = DateFormat("dd-MM-yyyy hh:mm")
                      .format(jobs[position].data["finishedTime"])
                      .toString();
                  String problem =
                      jobs[position].data["problemDesc"].toString();
                  String solution = jobs[position].data["solution"].toString();
                  String ticketNum =
                      jobs[position].data["ticketNum"].toString();
                  List parts = jobs[position].data["partsName"];
                  return ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      Card(
                        child: Container(
                          child: ListTile(
                            title: ExpansionTile(
                              initiallyExpanded: false,
                              title: Text("$date"),
                              children: <Widget>[
                                ListTile(
                                  title: Text("Detil Masalah"),
                                  subtitle: Text("$problem"),
                                ),
                                Divider(),
                                ListTile(
                                  title: Text("Solusi"),
                                  subtitle: Text("$solution"),
                                ),
                                Divider(),
                                ListTile(
                                  title: Text("APTRA ID"),
                                  subtitle: Text("$ticketNum"),
                                ),
                                Divider(),
                                parts == null
                                    ? ListTile(
                                        title: Text(
                                            "Tidak Ada Suku Cadang Yang Diganti"),
                                      )
                                    : ExpansionTile(
                                        title: Text("Suku Cadang Yang Diganti"),
                                        children: <Widget>[
                                          ListView.builder(
                                              physics: ClampingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: parts.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int position) {
                                                return ListTile(
                                                  title: Text(
                                                      "${position + 1}: ${parts[position]}\n"),
                                                );
                                              }),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          },
        ));
  }
}

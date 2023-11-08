import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:scan_o_matic/data/database.dart';
import 'package:scan_o_matic/data/scan_dto.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

class Scans extends StatefulWidget {
  const Scans({super.key, required this.title});
  final String title;

  @override
  State<Scans> createState() => _ScansState();
}

class _ScansState extends State<Scans> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            FutureBuilder<List<SavedScan>>(
                future: DatabaseHelper.instance.getScans(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<SavedScan>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return snapshot.data!.isEmpty
                      ? const Text("No Scans Yet. Save some!")
                      : Expanded(
                          child: ListView(
                            children: snapshot.data!.map(
                              (ss) {
                                return Slidable(
                                    endActionPane: ActionPane(
                                      motion: const StretchMotion(),
                                      children: <Widget>[
                                        SlidableAction(
                                          backgroundColor: Colors.red,
                                          icon: Icons.delete,
                                          onPressed: ((context) {
                                            DatabaseHelper.instance
                                                .deleteScan(ss.sid);
                                            setState(() {});
                                          }),
                                        ),
                                      ],
                                    ),
                                    startActionPane: ActionPane(
                                      motion: const StretchMotion(),
                                      children: <Widget>[
                                        SlidableAction(
                                          backgroundColor: Colors.green,
                                          icon: Icons.copy,
                                          onPressed: ((context) =>
                                              Clipboard.setData(
                                                ClipboardData(text: ss.scan),
                                              )),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(title: Text(ss.scan)));
                                //return ListTile(title: Text(sc));
                              },
                            ).toList(),
                          ),
                        );
                }),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scan_o_matic/src/application/scanner_model.dart';
import 'package:scan_o_matic/src/domain/entities/scan_entity.dart';
import 'package:provider/provider.dart';

class SavedScansPage extends StatelessWidget {
  const SavedScansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerModel>(builder: (context, value, child) {
      if (value.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (value.isError) {
        return Center(child: Text(value.failure!.message));
      }
      return Column(
        children: [
          Expanded(
            child: value.scans.isEmpty
                ? const Center(child: Text("No saved scans."))
                : ListView.builder(
                    itemCount: value.scans.length,
                    itemBuilder: (context, index) {
                      ScanEntity scan = value.scans[index];
                      return Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              icon: Icons.copy,
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              onPressed: (context) => value.copyToClip(),
                            ),
                          ],
                        ),
                        endActionPane:
                            ActionPane(motion: const ScrollMotion(), children: [
                          SlidableAction(
                              icon: Icons.delete,
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                              onPressed: (context) async =>
                                  value.deleteScan(index))
                        ]),
                        child: ListTile(
                          title: Text(scan.value),
                        ),
                      );
                    }),
          ),
        ],
      );
    });
  }
}

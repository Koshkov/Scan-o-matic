import 'package:flutter/material.dart';
import 'package:scan_o_matic/src/application/scanner_model.dart';
import 'package:provider/provider.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerModel>(
      builder: (context, value, child) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: value.decoded != "-1" && value.decoded.isNotEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          value.decoded,
                          style:
                              const TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                        onTap: () => Uri.parse(value.decoded).host.isEmpty
                            ? null
                            : value.openUri,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: value.copyToClip,
                              child: const Text("Copy"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: value.clicked ? null : value.saveScan,
                              child: const Text("Save"),
                            ),
                          ]),
                    ],
                  )
                : const Text("Please Scan Something"),
          ),
        ],
      ),
    );
  }
}

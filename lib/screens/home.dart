import 'package:flutter/material.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scan_o_matic/screens/about_page.dart';
import 'package:scan_o_matic/screens/scans_page.dart';

import 'package:flutter/services.dart';
import 'package:scan_o_matic/data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String decoded = "";
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    Widget mainDrawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Text("Scan-o-matic", style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text("Scans"),
            onTap: () {
              if (mounted) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Scans(title: "Scans")));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: const Text("About"),
            onTap: () {
              if (mounted) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const About(title: "About")));
              }
            },
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Center(
          child: decoded != "-1" && decoded.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      decoded,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: (() async => await Clipboard.setData(
                                ClipboardData(text: decoded))),
                            child: const Text("Copy"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: clicked
                                ? null
                                : (() async {
                                    setState(() {
                                      clicked = true;
                                    });
                                    DatabaseHelper.instance.addScan(decoded);
                                  }),
                            child: const Text("Save"),
                          ),
                        ]),
                  ],
                )
              : const Text("Please Scan Something"),
        ),
      ),
      drawer: mainDrawer,
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        FloatingActionButton(
            tooltip: 'Scan QR Code',
            heroTag: 'QR',
            child: const Icon(Icons.qr_code),
            onPressed: () async {
              String result = await FlutterBarcodeScanner.scanBarcode(
                  "#ff6666", "Cancel", true, ScanMode.QR);
              setState(() {
                decoded = result;
                clicked = false;
              });
            }),
        const SizedBox(
          height: 10,
        ),
        FloatingActionButton(
            tooltip: 'Scan Barcode',
            heroTag: 'BAR',
            child: const Icon(Icons.barcode_reader),
            onPressed: () async {
              String result = await FlutterBarcodeScanner.scanBarcode(
                  "#ff6666", "Cancel", true, ScanMode.BARCODE);
              setState(() {
                decoded = result;
                clicked = false;
              });
            }),
      ]),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:scan_o_matic/boxes.dart';
import 'package:scan_o_matic/scan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Current dispalyed [Widget]
  int _selectedIndex = 0;

  /// Stores result from [FlutterBarcodeScanner]
  String _decoded = "";

  /// Whether or not user saved [Scan] to internal storage
  bool _clicked = false;

  /// Changes dispalyed [Widget]
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Copies from QR scan to system clipboard
  void _copyToClip(String data) async {
    await Clipboard.setData(ClipboardData(text: data));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Copied to clipboard!"),
        ),
      );
    }
  }

  /// Opens given [Uri] in default browser
  void _launchUrl(Uri url) async {
    try {
      await launchUrl(url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: const Text("Failed to open URL!"),
          ),
        );
      }
    }
  }

  /// Deletes [Scan] given a index
  void _deleteScan(int index) async {
    try {
      await boxScans.deleteAt(index);
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: const Text("Failed to delete scan!"),
          ),
        );
      }
    }
  }

  /// Launches [FlutterBarcodeScanner] and  changes state of [_decoded],
  /// [_clicked], and [_selectedIndex]
  void _getScan() async {
    try {
      String result = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      setState(() {
        _decoded = result;
        _clicked = false;
        _selectedIndex = 0;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: const Text("Failed to open scanner!"),
          ),
        );
      }
    }
  }

  /// Saves [Scan] to [boxScans]
  void _saveScan() async {
    try {
      await boxScans.put('key_$_decoded', Scan(scan: _decoded));
      setState(() {
        _clicked = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: const Text("Failed to save scan!"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget scanPage = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: _decoded != "-1" && _decoded.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        _decoded,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                      onTap: () => Uri.parse(_decoded).host.isEmpty
                          ? null
                          : _launchUrl(Uri.parse(_decoded)),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () => _copyToClip(_decoded),
                            child: const Text("Copy"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed:
                                _clicked ? null : () async => _saveScan(),
                            child: const Text("Save"),
                          ),
                        ]),
                  ],
                )
              : const Text("Please Scan Something"),
        ),
      ],
    );

    Widget scanList = Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: boxScans.length,
              itemBuilder: (context, index) {
                Scan scan = boxScans.getAt(index);
                return Slidable(
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        icon: Icons.copy,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        onPressed: (context) => _copyToClip(scan.scan),
                      ),
                    ],
                  ),
                  endActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                        icon: Icons.delete,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        onPressed: (context) async => _deleteScan(index))
                  ]),
                  child: ListTile(
                    title: Text(scan.scan),
                  ),
                );
              }),
        ),
      ],
    );

    List<Widget> widgetOptions = [
      scanPage,
      scanList,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan-o-matic"),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Scans',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Scan QR Code',
        heroTag: 'QR',
        child: const Icon(Icons.qr_code),
        onPressed: () => _getScan(),
      ),
    );
  }
}

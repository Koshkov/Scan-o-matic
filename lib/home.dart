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
  int selectedIndex = 0;

  /// Stores result from [FlutterBarcodeScanner]
  String decoded = "";

  /// Whether or not user saved [Scan] to internal storage
  bool clicked = false;

  /// Changes dispalyed [Widget]
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  /// Copies from QR scan to system clipboard
  void copyToClip() async {
    await Clipboard.setData(ClipboardData(text: decoded));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Copied to clipboard!"),
        ),
      );
    }
  }

  /// Opens given [Uri] in default browser
  void openUri(Uri url) async {
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
  void deleteScan(int index) async {
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

  /// Launches [FlutterBarcodeScanner] and  changes state of [decoded],
  /// [clicked], and [selectedIndex]
  void getScan() async {
    try {
      String result = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      setState(() {
        decoded = result;
        clicked = false;
        selectedIndex = 0;
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
  void saveScan() async {
    try {
      await boxScans.put('key_$decoded', Scan(scan: decoded));
      setState(() {
        clicked = true;
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
  Widget build(BuildContext context) => _HomePageView(this);
}

class _HomePageView extends StatelessWidget {
  const _HomePageView(this.state);
  final _HomePageState state;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      _ScanPage(state),
      _SavedScansPage(state),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Scan-o-matic")),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: widgetOptions.elementAt(state.selectedIndex),
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
        currentIndex: state.selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: state.onItemTapped,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Scan QR Code',
        heroTag: 'QR',
        child: const Icon(Icons.qr_code),
        onPressed: () => state.getScan(),
      ),
    );
  }
}

class _SavedScansPage extends StatelessWidget {
  const _SavedScansPage(this.state);
  final _HomePageState state;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        onPressed: (context) => state.copyToClip(),
                      ),
                    ],
                  ),
                  endActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                        icon: Icons.delete,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        onPressed: (context) async => state.deleteScan(index))
                  ]),
                  child: ListTile(
                    title: Text(scan.scan),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class _ScanPage extends StatelessWidget {
  const _ScanPage(this.state);
  final _HomePageState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: state.decoded != "-1" && state.decoded.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        state.decoded,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                      onTap: () => Uri.parse(state.decoded).host.isEmpty
                          ? null
                          : state.openUri(Uri.parse(state.decoded)),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: state.copyToClip,
                            child: const Text("Copy"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: state.clicked ? null : state.saveScan,
                            child: const Text("Save"),
                          ),
                        ]),
                  ],
                )
              : const Text("Please Scan Something"),
        ),
      ],
    );
  }
}

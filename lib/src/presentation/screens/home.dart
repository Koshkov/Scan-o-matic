import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:scan_o_matic/src/application/scanner_model.dart';

import 'package:scan_o_matic/src/presentation/screens/scan_screen.dart';
import 'package:scan_o_matic/src/presentation/screens/saved_scans_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = [
      const ScanPage(),
      const SavedScansPage(),
    ];

    return Consumer<ScannerModel>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: const Text("Scan-o-matic")),
        body: Container(
          padding: const EdgeInsets.all(5),
          child: widgetOptions.elementAt(value.selectedIndex),
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
          currentIndex: value.selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: value.onItemTapped,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          tooltip: 'Scan QR Code',
          heroTag: 'QR',
          onPressed: value.getScan,
          child: const Icon(Icons.qr_code),
        ),
      ),
    );
  }
}

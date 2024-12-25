import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import 'package:scan_o_matic/core/error/failures.dart';
import 'package:scan_o_matic/src/domain/entities/scan_entity.dart';
import 'package:scan_o_matic/src/data/repos/scan_repo.dart';

class ScannerModel extends ChangeNotifier {
  final repo = ScanRepo();
  List<ScanEntity> scans = [];
  int selectedIndex = 0;
  String decoded = "";
  bool clicked = false;
  bool copied = false;
  bool isError = false;
  bool _isLoading = true;
  DatabaseFailure? failure;

  ScannerModel() {
    getScans();
  }

  set isLoading(bool isload) {
    _isLoading = isload;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  void _sendError(DatabaseFailure f) {
    isError = true;
    failure = f;
  }

  /// Changes dispalyed [Widget]
  void onItemTapped(int index) {
    selectedIndex = index;
    getScans();
  }

  /// Copies from QR scan to system clipboard
  void copyToClip() async {
    await Clipboard.setData(ClipboardData(text: decoded));
  }

  /// Opens given [Uri] in default browser
  void openUri(Uri url) async {
    await launchUrl(Uri.parse(decoded));
  }

  /// Deletes [Scan] given a index
  void deleteScan(int index) async {
    await repo.delete(index);
    getScans();
  }

  /// Launches [FlutterBarcodeScanner] and  changes state of [decoded],
  /// [clicked], and [selectedIndex]
  void getScan() async {
    isLoading = true;
    final res = await repo.takeScan();
    res.fold((l) => isError = true, (r) {
      decoded = r;
      clicked = false;
      selectedIndex = 0;
    });
    isLoading = false;
  }

  void getScans() async {
    isLoading = true;
    final res = await repo.selectAll();
    res.fold((l) => _sendError(l), (r) => scans = r);
    isLoading = false;
  }

  /// Saves [Scan] to [boxScans]
  void saveScan() async {
    isLoading = true;
    final res = await repo.insert(ScanEntity(scan: decoded));
    res.fold((l) => _sendError(l), (r) => clicked = true);
    isLoading = false;
  }
}

import 'package:scan_o_matic/src/data/dtos/scan.dart';
import 'package:scan_o_matic/src/data/datasrc/boxes.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanLocal {
  final _source = boxScans;

  Future<Scan> select(int id) async {
    final res = await boxScans.getAt(id);
    return Scan.fromMap(res);
  }

  Future<List<Scan>> selectAll() async {
    return _source.values.map((s) => Scan.fromMap(s)).toList();
  }

  Future<void> delete(int id) async {
    await _source.deleteAt(id);
  }

  Future<void> insert(Scan s) async {
    await _source.put('key_${s.value}', s.toMap());
  }

  Future<String> takeScan() async {
    final res = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.QR);
    return res;
  }
}

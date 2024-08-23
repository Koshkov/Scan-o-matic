import 'package:scan_o_matic/src/data/dtos/scan_dto.dart';
import 'package:scan_o_matic/src/data/datasrc/boxes.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanLocal {
  final _source = boxScans;

  Future<ScanDto> select(int id) async {
    final res = await boxScans.getAt(id);
    return ScanDto.fromMap(res);
  }

  Future<List<ScanDto>> selectAll() async {
    return _source.values.map((s) => ScanDto.fromMap(s)).toList();
  }

  Future<void> delete(int id) async {
    await _source.deleteAt(id);
  }

  Future<void> insert(ScanDto s) async {
    await _source.put('key_${s.value}', s.toMap());
  }

  Future<String> takeScan() async {
    final res = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.QR);
    return res;
  }
}

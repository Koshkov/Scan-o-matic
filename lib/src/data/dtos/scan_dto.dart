import 'package:scan_o_matic/src/data/datasrc/scan.dart';
import 'package:scan_o_matic/src/domain/entities/scan_entity.dart';

class ScanDto extends ScanEntity {
  ScanDto({
    required super.id,
    required super.value,
  });

  factory ScanDto.fromMap(Scan map) => ScanDto(
        id: map.hashCode,
        value: map.scan,
      );

  Scan toMap() {
    return Scan(scan: value);
  }
}

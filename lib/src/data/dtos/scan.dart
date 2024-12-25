import 'package:hive/hive.dart';

part 'scan.g.dart';

@HiveType(typeId: 1)
class Scan {
  Scan({required this.scan});

  @HiveField(0)
  String scan;

  factory Scan.fromMap(Map<String, dynamic> json) =>
      Scan(scan: json['scan'] ?? '');

  Map<String, dynamic> toMap() {
    return {'scan': scan};
  }
}

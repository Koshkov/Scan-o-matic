import 'package:hive/hive.dart';

part 'scan.g.dart';

@HiveType(typeId: 1)
class Scan {
  Scan({required this.scan});

  @HiveField(0)
  String scan;
}

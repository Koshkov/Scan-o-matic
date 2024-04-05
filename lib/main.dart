import 'package:flutter/material.dart';
import 'package:scan_o_matic/scan.dart';
import 'package:scan_o_matic/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'boxes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ScanAdapter());
  boxScans = await Hive.openBox<Scan>('scanBox');
  runApp(const ScannerApp());
}

class ScannerApp extends StatelessWidget {
  const ScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scan-o-matic',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      home: const HomePage(),
    );
  }
}

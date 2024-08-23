import 'package:flutter/material.dart';
import 'package:scan_o_matic/src/data/datasrc/scan.dart';
import 'package:scan_o_matic/src/presentation/screens/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/data/datasrc/boxes.dart';
import 'package:provider/provider.dart';
import 'package:scan_o_matic/src/application/scanner_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ScanAdapter());
  boxScans = await Hive.openBox<Scan>('scanBox');
  runApp(
    ChangeNotifierProvider(
      create: (_) => ScannerModel(),
      child: const ScannerApp(),
    ),
  );
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

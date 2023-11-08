import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Image.asset("assets/logo.png"),
            const Text(
                "Scan automatically without ads, trackers, or other annoying things."),
          ],
        ),
      ),
    );
  }
}

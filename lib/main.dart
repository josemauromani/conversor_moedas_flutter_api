import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(AppConversor());
}

class AppConversor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
    );
  }
}

import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.green[50],
      body: Center(
        child: Text("LUDO ADMIN PANEL WORKING ✅", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    ),
  ));
}
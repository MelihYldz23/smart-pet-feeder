import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(PetFeederApp());
}

class PetFeederApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akıllı Mama Makinesi',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';

class ResiduosScreen extends StatelessWidget {
  static String name = 'residuos';
  const ResiduosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis residuos'),),
    );
  }
}
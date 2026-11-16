import 'package:flutter/material.dart';
import 'metronome_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Afinador y Metrónomo',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const MetronomePage(),
    );
  }
}

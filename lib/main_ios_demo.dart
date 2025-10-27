import 'package:flutter/material.dart';
import 'features/test/drag_drop_demo.dart';

void main() {
  runApp(const IOSDemoApp());
}

class IOSDemoApp extends StatelessWidget {
  const IOSDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learniq iOS Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DragDropDemo(),
    );
  }
}

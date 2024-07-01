import 'package:flutter/material.dart';

class ExeminerScreen extends StatefulWidget {
  const ExeminerScreen({super.key});

  @override
  State<ExeminerScreen> createState() => _ExeminerScreenState();
}

class _ExeminerScreenState extends State<ExeminerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exeminer Screen'),
      ),
      body: const Center(
        child: Text(
          'Đây là màn hình của Exeminer',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CompetitorScreen extends StatefulWidget {
  const CompetitorScreen({super.key});

  @override
  State<CompetitorScreen> createState() => _CompetitorScreenState();
}

class _CompetitorScreenState extends State<CompetitorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exeminer Screen'),
      ),
      body: const Center(
        child: Text(
          'Đây là màn hình của Competitor',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

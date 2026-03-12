import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Your Result: 80%",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
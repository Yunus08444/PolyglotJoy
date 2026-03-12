import 'package:flutter/material.dart';

class TestQuestionPage extends StatelessWidget {
  const TestQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Question")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/result');
          },
          child: const Text("Finish"),
        ),
      ),
    );
  }
}
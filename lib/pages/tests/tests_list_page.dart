import 'package:flutter/material.dart';

class TestsListPage extends StatelessWidget {
  const TestsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tests")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/question');
          },
          child: const Text("Start"),
        ),
      ),
    );
  }
}
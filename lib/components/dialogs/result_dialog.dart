import 'package:flutter/material.dart';

class ResultDialog {
  static void show(BuildContext context, int score) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Test Result"),
          content: Text("Your score: $score"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }
}
import 'package:flutter/material.dart';

class LanguageCard extends StatelessWidget {
  final String language;
  final VoidCallback onTap;

  const LanguageCard({super.key, required this.language, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(title: Text(language), onTap: onTap),
    );
  }
}

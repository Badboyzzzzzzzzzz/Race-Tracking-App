import 'package:flutter/material.dart';

class BibCard extends StatelessWidget {
  final int index;
  const BibCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Center(
        child: Text(
          'Bib $index',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

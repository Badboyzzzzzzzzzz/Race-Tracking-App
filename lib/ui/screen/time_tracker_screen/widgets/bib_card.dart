import 'package:flutter/material.dart';

import '../../../../theme/theme.dart';

class BibCard extends StatelessWidget {
  final int index;
  const BibCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 59,
      width: 109,
      child: Card(
        color: TrackerTheme.grey,
        elevation: 2,
        child: Center(
          child: Text(
            '$index',
            style: AppTextStyles.button.copyWith(color: TrackerTheme.white),
          ),
        ),
      ),
    );
  }
}

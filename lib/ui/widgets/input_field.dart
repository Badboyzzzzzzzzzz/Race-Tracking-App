// lib/ui/widget/input_field.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:race_tracker/theme/theme.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool showBorder;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.showBorder = false,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Card styling
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: TrackerTheme.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: TrackerTheme.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border:
            showBorder ? Border.all(color: TrackerTheme.grey, width: 1) : null,
      ),
      // The actual TextField
      child: TextFormField(
        keyboardType: keyboardType,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: TrackerTheme.grey),
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

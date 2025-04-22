import 'package:flutter/material.dart';
import 'package:race_tracker/theme/theme.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color bgColor = isHovered
        ? widget.color.withOpacity(0.9) 
        : widget.color;

    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovered = true);
      },
      onExit: (_) {
        setState(() => isHovered = false);
      },
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
        ),
        onPressed: widget.onPressed,
        child: Text(
          widget.text,
          style: AppTextStyles.button.copyWith(
            color: TrackerTheme.white,
            fontWeight: FontWeight.bold,
            ),
        ),
      ),
    );
  }
}

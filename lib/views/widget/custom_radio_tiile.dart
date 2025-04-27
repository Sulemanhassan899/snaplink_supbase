import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/views/widget/custom_animated_row.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';

class CustomRadioTile extends StatelessWidget {
  final int value;
  final int groupValue;
  final String imagePath;
  final String text;
  final ValueChanged<int?> onChanged;

  const CustomRadioTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.imagePath,
    required this.text,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: () => onChanged(value),
      child: AnimatedRow(
        children: [
          _buildGradientRadio(),
          Image.asset(imagePath, height: 18),
          MyText(
            text: text,
            size: 14,
            paddingLeft: 6,
            weight: FontWeight.w500,
            color: kBlack,
          ),
        ],
      ),
    );
  }

  Widget _buildGradientRadio() {
    return ShaderMask(
      shaderCallback:
          (bounds) => const LinearGradient(
            colors: [Colors.blue, Colors.purple], // Gradient Colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
      child: Radio<int>(
        value: value,

        groupValue: groupValue,
        onChanged: onChanged,
        fillColor: WidgetStateProperty.resolveWith<Color>(
          (states) => Colors.white, // Keeps the radio clickable
        ),
      ),
    );
  }
}

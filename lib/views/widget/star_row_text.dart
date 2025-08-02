import 'package:flutter/material.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/constants/app_fonts.dart';
import 'package:snaplink/views/widget/custom_animated_row.dart';

class StarRowText extends StatelessWidget {
  final String text;

  const StarRowText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AnimatedRow(
      spacing: 6,
      children: [
        RichText(
          text: TextSpan(
            text: text,
            style: const TextStyle(
              fontSize: 22,
              fontFamily: AppFonts.Nunito,
              fontWeight: FontWeight.w500,
              color: kBlack,
            ),
            children: const [
              TextSpan(
                text: " \u002A",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: AppFonts.Nunito,
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

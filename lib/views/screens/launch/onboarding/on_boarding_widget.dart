
import 'package:flutter/material.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/constants/app_fonts.dart';
import 'package:snaplink/views/widget/custom_animated_column.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';

class OnBoardingWidget extends StatelessWidget {
  final String description;

  final Color? color;

  const OnBoardingWidget({
    super.key,

    //required this.image,
    required this.description,

    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedColumn(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MyText(
          textAlign: TextAlign.center,
          text: description,
          size: 24,
          paddingLeft: 20,
          paddingRight: 20,
          paddingTop: 30,
          letterSpacing: 1,
          fontFamily: AppFonts.Nunito,
          weight: FontWeight.bold,
        ),
      ],
    );
  }
}

// Dot indicator Widget
class DotIndicator extends StatelessWidget {
  final bool isActive;
  const DotIndicator({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      height: 14,
      width: isActive ? 14 : 14,
      decoration: BoxDecoration(
        color: isActive ? kTertiaryColor : kGreyColor2,

        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

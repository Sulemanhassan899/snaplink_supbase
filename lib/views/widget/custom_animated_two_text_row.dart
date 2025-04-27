import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:snaplink/constants/app_fonts.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';

class TwoTextAnimatedRow extends StatelessWidget {
  const TwoTextAnimatedRow({
    super.key,
    required this.text1,
    required this.text2,
    this.text1Color,
    this.text2Color,
    this.text1Size,
    this.text2Size,
    this.text1Weight,
    this.text2Weight,
    this.text1FontFamily,
    this.text2FontFamily,
    this.text1Align,
    this.text2Align,
    this.text1Decoration,
    this.text2Decoration,
    this.text1Overflow,
    this.text2Overflow,
    this.text1FontStyle,
    this.text2FontStyle,
    this.text1MaxLines,
    this.text2MaxLines,
    this.text1LineHeight,
    this.text2LineHeight,
    this.text1LetterSpacing,
    this.text2LetterSpacing,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize,
    this.spacing,
    this.textBaseline,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.animationDuration,
  });

  final String text1;
  final String text2;
  final Color? text1Color;
  final Color? text2Color;
  final double? text1Size;
  final double? text2Size;
  final FontWeight? text1Weight;
  final FontWeight? text2Weight;
  final String? text1FontFamily;
  final String? text2FontFamily;
  final TextAlign? text1Align;
  final TextAlign? text2Align;
  final TextDecoration? text1Decoration;
  final TextDecoration? text2Decoration;
  final TextOverflow? text1Overflow;
  final TextOverflow? text2Overflow;
  final FontStyle? text1FontStyle;
  final FontStyle? text2FontStyle;
  final int? text1MaxLines;
  final int? text2MaxLines;
  final double? text1LineHeight;
  final double? text2LineHeight;
  final double? text1LetterSpacing;
  final double? text2LetterSpacing;

  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final double? spacing;
  final CrossAxisAlignment? crossAxisAlignment;
  final int? animationDuration;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        MoveEffect(
          duration: Duration(milliseconds: animationDuration ?? 1000),
          begin: const Offset(20, 0), // Changed to horizontal animation
        ),
      ],
      child: Row(
        // Changed from Column to Row
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisSize: mainAxisSize ?? MainAxisSize.max,
        children: [
          MyText(
            text: text1,
            color: text1Color ?? Colors.white,
            size: text1Size ?? 18,
            lineHeight: text1LineHeight ?? 0.5,
            letterSpacing: text1LetterSpacing ?? 1,
            weight: text1Weight ?? FontWeight.w600,
            fontFamily: text1FontFamily,
            textAlign: text1Align ?? TextAlign.start,
            decoration: text1Decoration ?? TextDecoration.none,
            textOverflow: text1Overflow,
            fontStyle: text1FontStyle,
            maxLines: text1MaxLines,
          ),
          SizedBox(width: spacing ?? 10), // Changed from height to width
          MyText(
            text: text2,
            color: text2Color ?? Colors.white,
            size: text2Size ?? 18,
            lineHeight: text2LineHeight ?? 0.5,
            letterSpacing: text2LetterSpacing ?? 1,
            weight: text2Weight ?? FontWeight.w600,
            fontFamily: text2FontFamily ?? AppFonts.Nunito,
            textAlign: text2Align ?? TextAlign.start,
            decoration: text2Decoration ?? TextDecoration.none,
            textOverflow: text2Overflow,
            fontStyle: text2FontStyle,
            maxLines: text2MaxLines,
          ),
        ],
      ),
    );
  }
}

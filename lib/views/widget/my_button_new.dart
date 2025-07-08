import 'package:bounce/bounce.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/constants/app_fonts.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_row.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.height = 48,
    this.width,
    this.backgroundColor,
    this.fontColor,
    this.fontSize,
    this.outlineColor = Colors.transparent,
    this.radius = 10,
    this.svgIcon,
    this.haveSvg = false,
    this.choiceIcon,
    this.isleft = false,
    this.mhoriz = 0,
    this.hasicon = false,
    this.hasshadow = false,
    this.mBottom = 0,
    this.hasgrad = false,
    this.isactive = true,
    this.mTop = 0,
    this.fontWeight,
  });

  final String buttonText;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final double radius;
  final double? fontSize;
  final Color outlineColor;
  final bool hasicon, isleft, hasshadow, hasgrad, isactive;
  final Color? backgroundColor, fontColor;
  final String? svgIcon, choiceIcon;
  final bool haveSvg;
  final double mTop, mBottom, mhoriz;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 1000)),
        MoveEffect(curve: Curves.fastLinearToSlowEaseIn),
      ],
      child: Bounce(
        duration: Duration(milliseconds: isactive ? 100 : 0),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(
            top: mTop,
            bottom: mBottom,
            left: mhoriz,
            right: mhoriz,
          ),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color:
                isactive
                    ? backgroundColor ?? kWhite
                    : backgroundColor ??
                        const Color(0xff0E1A34).withOpacity(0.35),

            borderRadius: BorderRadius.circular(radius),
          ),
          child: Material(
            color: Colors.transparent,
            child: AnimatedRow(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasicon)
                  Padding(
                    padding:
                        isleft
                            ? const EdgeInsets.only(left: 20.0)
                            : const EdgeInsets.only(right: 10),
                    child: CommonImageView(imagePath: choiceIcon, height: 16),
                  ),
                MyText(
                  paddingLeft: hasicon ? 10 : 0,
                  text: buttonText,
                  fontFamily: AppFonts.Nunito,
                  size: fontSize ?? 16,
                  letterSpacing: 0.5,
                  color: fontColor ?? kBlack,
                  weight: fontWeight ?? FontWeight.w700,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyBorderButton extends StatelessWidget {
  MyBorderButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.height = 48,
    this.width,
    this.backgroundColor,
    this.fontColor,
    this.fontSize = 16,
    this.outlineColor,
    this.radius = 7,
    this.haveSvg = false,
    this.isleft = false,
    this.mhoriz = 0,
    this.child,
    this.hasicon = false,
    this.hasshadow = false,
    this.mBottom = 0,
    this.hasgrad = false,
    this.isactive = true,
    this.mTop = 0,
    this.fontWeight = FontWeight.w400,
    this.svgIcon,
    this.choiceIcon,
    this.rightpadding,
  });

  final String buttonText;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final String? svgIcon, choiceIcon;
  final double? rightpadding;
  final double radius;
  final double fontSize;
  final Color? outlineColor;
  final bool hasicon, isleft, hasshadow, hasgrad, isactive;
  final Color? backgroundColor, fontColor;
  final bool haveSvg;
  final double mTop, mBottom, mhoriz;
  final FontWeight fontWeight;

  FontWeight? weight;
  Widget? child;
  Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 1000)),
        MoveEffect(curve: Curves.fastLinearToSlowEaseIn),
      ],
      child: Bounce(
        duration: Duration(milliseconds: isactive ? 100 : 0),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(
            top: mTop,
            bottom: mBottom,
            left: mhoriz,
            right: mhoriz,
          ),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color:
                isactive
                    ? backgroundColor ?? kTransperentColor
                    : backgroundColor ??
                        const Color(0xff0E1A34).withOpacity(0.35),
            border: Border.all(color: outlineColor ?? kBorderColor),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Material(
            color: Colors.transparent,
            child: AnimatedRow(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasicon)
                  Padding(
                    padding:
                        isleft
                            ? const EdgeInsets.only(left: 0)
                            : const EdgeInsets.only(right: 0),
                    child: CommonImageView(imagePath: choiceIcon, height: 34),
                  ),
                MyText(
                  paddingLeft: hasicon ? 0 : 0,
                  text: buttonText,
                  fontFamily: AppFonts.Nunito,
                  size: 16,
                  paddingRight: rightpadding ?? 0,
                  letterSpacing: 0.5,
                  color: fontColor ?? kWhite,
                  weight: fontWeight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyBorderButtonwithWidth extends StatelessWidget {
  MyBorderButtonwithWidth({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.isactive = true,
    this.height = 48,
    this.Width,
    this.textSize,
    this.weight,
    this.child,
    this.radius,
    this.textColor,
    this.bgColor,
    this.kcontainerbgColor,
    this.fontFamily,
  });

  final String? fontFamily;

  final String buttonText;
  final VoidCallback onTap;
  double? height, Width, textSize;
  FontWeight? weight;
  Widget? child;
  double? radius;
  bool isactive;

  Color? bgColor, kcontainerbgColor, textColor;
  dynamic bgGradinetColor; // Allow both Color and Gradient

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 1000)),
        MoveEffect(curve: Curves.fastLinearToSlowEaseIn),
      ],
      child: Bounce(
        duration: Duration(milliseconds: isactive ? 100 : 0),
        child: Container(
          height: height,
          width: Width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 10),
            color: kcontainerbgColor ?? Colors.transparent,
            border: Border.all(width: 1.0, color: kPrimaryColor),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              splashColor: bgColor!.withOpacity(0.1),
              highlightColor: bgColor!.withOpacity(0.1),
              borderRadius: BorderRadius.circular(radius ?? 10),
              child:
                  child ??
                  Center(
                    child: MyText(
                      text: buttonText,
                      size: textSize ?? 16,
                      letterSpacing: 0.5,
                      weight: weight ?? FontWeight.w500,
                      color: textColor ?? kWhite,
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthButtons extends StatelessWidget {
  final String img;
  final String text;
  final bool isactive;
  final VoidCallback? onTap;

  const AuthButtons({
    super.key,
    this.onTap,
    required this.img,
    this.isactive = true,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 1000)),
        MoveEffect(curve: Curves.fastLinearToSlowEaseIn),
      ],
      child: Bounce(
        duration: Duration(milliseconds: isactive ? 100 : 0),
        onTap: onTap, // Fix: Pass the onTap callback here
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBorderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonImageView(imagePath: img, height: 21),
              MyText(
                text: text,
                size: 16,
                weight: FontWeight.w700,
                paddingLeft: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyGradientButton extends StatelessWidget {
  const MyGradientButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.height = 46,
    this.width,
    this.backgroundColor,
    this.gradient,
    this.fontColor,
    this.fontSize,
    this.outlineColor = Colors.transparent,
    this.radius = 12,
    this.svgIcon,
    this.haveSvg = false,
    this.choiceIcon,
    this.isleft = false,
    this.mhoriz = 0,
    this.hasicon = false,
    this.hasshadow = false,
    this.mBottom = 0,
    this.hasgrad = false,
    this.isactive = true,
    this.mTop = 0,
    this.fontWeight,
  });

  final String buttonText;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final double radius;
  final double? fontSize;
  final Color outlineColor;
  final bool hasicon, isleft, hasshadow, hasgrad, isactive;
  final Color? backgroundColor, fontColor;
  final LinearGradient? gradient;
  final String? svgIcon, choiceIcon;
  final bool haveSvg;
  final double mTop, mBottom, mhoriz;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 1000)),
        MoveEffect(curve: Curves.fastLinearToSlowEaseIn),
      ],
      child: Bounce(
        duration: Duration(milliseconds: isactive ? 100 : 0),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(
            top: mTop,
            bottom: mBottom,
            left: mhoriz,
            right: mhoriz,
          ),
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(Assets.imagesButtonbg2),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: outlineColor),
          ),
          child: AnimatedRow(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasicon)
                Padding(
                  padding:
                      isleft
                          ? const EdgeInsets.only(left: 20.0)
                          : const EdgeInsets.only(right: 10),
                  child: CommonImageView(imagePath: choiceIcon, height: 16),
                ),
              Center(
                child: MyText(
                  paddingLeft: hasicon ? 10 : 0,
                  text: buttonText,

                  fontFamily: AppFonts.Nunito,
                  size: fontSize ?? 16,
                  letterSpacing: 0.5,
                  color: fontColor ?? kWhite,
                  weight: fontWeight ?? FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyGradientButton2 extends StatelessWidget {
  const MyGradientButton2({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.height = 46,
    this.width,
    this.backgroundColor,
    this.gradient,
    this.fontColor,
    this.fontSize,
    this.outlineColor = Colors.transparent,
    this.radius = 12,
    this.svgIcon,
    this.haveSvg = false,
    this.choiceIcon,
    this.isleft = false,
    this.mhoriz = 0,
    this.hasicon = false,
    this.hasshadow = false,
    this.mBottom = 0,
    this.hasgrad = false,
    this.isactive = true,
    this.mTop = 0,
    this.fontWeight,
  });

  final String buttonText;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final double radius;
  final double? fontSize;
  final Color outlineColor;
  final bool hasicon, isleft, hasshadow, hasgrad, isactive;
  final Color? backgroundColor, fontColor;
  final LinearGradient? gradient;
  final String? svgIcon, choiceIcon;
  final bool haveSvg;
  final double mTop, mBottom, mhoriz;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 1000)),
        MoveEffect(curve: Curves.fastLinearToSlowEaseIn),
      ],
      child: Bounce(
        duration: Duration(milliseconds: isactive ? 100 : 0),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(
            top: mTop,
            bottom: mBottom,
            left: mhoriz,
            right: mhoriz,
          ),
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(Assets.imagesButtonbg2),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: outlineColor),
          ),
          child: AnimatedRow(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasicon)
                Padding(
                  padding:
                      isleft
                          ? const EdgeInsets.only(left: 20.0)
                          : const EdgeInsets.only(right: 10),
                  child: CommonImageView(imagePath: choiceIcon, height: 16),
                ),
              Center(
                child: MyText(
                  paddingLeft: hasicon ? 10 : 0,
                  text: buttonText,
                  paddingBottom: 6,
                  fontFamily: AppFonts.Nunito,
                  size: fontSize ?? 16,
                  letterSpacing: 0.5,
                  color: fontColor ?? kWhite,
                  weight: fontWeight ?? FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

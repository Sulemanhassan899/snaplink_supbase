import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/constants/app_fonts.dart';
import 'package:snaplink/views/widget/custom_animated_row.dart';

import 'my_text_widget.dart';

class CustomCheckbox extends StatefulWidget {
  final String? text;
  final String? text2;

  final Color? textcolor;
  final Function(bool) onChanged;

  const CustomCheckbox({
    super.key,
    this.text,
    this.text2,

    required this.onChanged,
    this.textcolor,
  });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
        widget.onChanged(_isChecked);
      },
      child: AnimatedRow(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4),
              color: _isChecked ? kPrimaryColor : kWhite,
              border: Border.all(
                color: _isChecked ? kPrimaryColor : kBorderColor,
                width: 1,
              ),
            ),
            child:
                _isChecked
                    ? const Icon(Icons.check, color: kWhite, size: 10)
                    : null,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: AnimatedRow(
              spacing: 4,
              children: [
                MyText(
                  text: widget.text ?? '',
                  size: 14,
                  letterSpacing: 0,
                  color: kSubText4,
                  fontFamily: AppFonts.Nunito,
                  weight: FontWeight.w500,
                ),
                MyText(
                  text: widget.text2 ?? '',
                  size: 14,
                  letterSpacing: 0,
                  fontFamily: AppFonts.Nunito,
                  weight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCheckbox2 extends StatefulWidget {
  final String? text;
  final String? text2;

  final Color? textcolor;
  final Function(bool) onChanged;

  const CustomCheckbox2({
    super.key,
    this.text,
    this.text2,

    required this.onChanged,
    this.textcolor,
  });

  @override
  State<CustomCheckbox2> createState() => _CustomCheckbox2State();
}

class _CustomCheckbox2State extends State<CustomCheckbox2> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
        widget.onChanged(_isChecked);
      },
      child: AnimatedRow(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(25),
              color: _isChecked ? kPrimaryColor : null,
              border: Border.all(
                color: _isChecked ? kPrimaryColor : kGreyColor4,
                width: 1,
              ),
            ),
            child:
                _isChecked
                    ? const Icon(Icons.check, color: kWhite, size: 10)
                    : null,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: AnimatedRow(
              spacing: 4,
              children: [
                MyText(
                  text: widget.text ?? '',
                  size: 14,
                  letterSpacing: 0,
                  color: kBlack,
                  fontFamily: AppFonts.Nunito,
                  weight: FontWeight.w500,
                ),
                MyText(
                  text: widget.text2 ?? '',
                  size: 14,
                  letterSpacing: 0,

                  fontFamily: AppFonts.Nunito,
                  weight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

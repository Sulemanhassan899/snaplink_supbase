import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/constants/app_fonts.dart';
import 'package:snaplink/generated/assets.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_row.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.bgColor,
    this.marginBottom,
    this.width,
    this.labelText,
  });

  final List<dynamic>? items;
  final String selectedValue;
  final ValueChanged<dynamic>? onChanged;
  final String hint;
  final String? labelText;
  final Color? bgColor;
  final double? marginBottom, width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom ?? 16),
      child: Animate(
        effects: const [
          MoveEffect(
            duration: Duration(milliseconds: 500),
            begin: Offset(20, 0),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (labelText != null)
              Animate(
                effects: const [
                  MoveEffect(
                    duration: Duration(milliseconds: 500),
                    begin: Offset(20, 0),
                  ),
                ],
                child: MyText(
                  paddingBottom: 10,
                  text: labelText!,
                  size: 16,
                  color: kBlack,
                  fontFamily: AppFonts.Nunito,
                  textAlign: TextAlign.start,
                  weight: FontWeight.w600,
                ),
              ),
            Animate(
              effects: const [
                MoveEffect(
                  duration: Duration(milliseconds: 500),
                  begin: Offset(20, 0),
                ),
              ],
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  items:
                      items!
                          .map(
                            (item) => DropdownMenuItem<dynamic>(
                              value: item,
                              child: MyText(
                                text: item,
                                size: 12,
                                color: kBlack,
                                weight: FontWeight.w400,
                                fontFamily: AppFonts.Nunito,
                              ),
                            ),
                          )
                          .toList(),
                  value: selectedValue == hint ? null : selectedValue,
                  hint: MyText(
                    text: hint,
                    size: 12,
                    color: kSubText,
                    fontFamily: AppFonts.Nunito,
                    textAlign: TextAlign.start,
                    weight: FontWeight.w400,
                  ),
                  onChanged: onChanged,
                  iconStyleData: const IconStyleData(icon: SizedBox()),
                  isDense: true,
                  isExpanded: true,
                  customButton: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 48,
                    decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(color: kBorderColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AnimatedRow(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: selectedValue == hint ? hint : selectedValue,
                          size: 14,
                          color: kSubText,
                          weight: FontWeight.w400,
                          fontFamily: AppFonts.Nunito,
                        ),
                        CommonImageView(
                          imagePath: Assets.imagesArrowDownDropdown,
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(height: 35),
                  dropdownStyleData: DropdownStyleData(
                    elevation: 6,
                    maxHeight: 300,
                    offset: const Offset(0, -5),
                    decoration: BoxDecoration(
                      border: Border.all(color: kBorderColor),
                      borderRadius: BorderRadius.circular(10),
                      color: kWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropDown2 extends StatelessWidget {
  const CustomDropDown2({
    super.key,
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.bgColor,
    this.marginBottom,
    this.width,
    this.labelText,
    this.textSize,
    this.textColor,
    this.textWeight,
    this.icon,
    this.iconSize,
    this.iconColor,
  });

  final List<dynamic>? items;
  final String selectedValue;
  final ValueChanged<dynamic>? onChanged;
  final String hint;
  final String? labelText;
  final Color? bgColor;
  final double? marginBottom, width;
  final double? textSize, iconSize;
  final Color? textColor, iconColor;
  final FontWeight? textWeight;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom ?? 16),
      child: Animate(
        effects: const [
          MoveEffect(
            duration: Duration(milliseconds: 500),
            begin: Offset(20, 0),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (labelText != null)
              Animate(
                effects: const [
                  MoveEffect(
                    duration: Duration(milliseconds: 500),
                    begin: Offset(20, 0),
                  ),
                ],
                child: MyText(
                  paddingBottom: 10,
                  text: labelText!,
                  size: 16,
                  color: kBlack,
                  fontFamily: AppFonts.Nunito,
                  textAlign: TextAlign.start,
                  weight: FontWeight.w700,
                ),
              ),
            Animate(
              effects: const [
                MoveEffect(
                  duration: Duration(milliseconds: 500),
                  begin: Offset(20, 0),
                ),
              ],
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  items:
                      items!
                          .map(
                            (item) => DropdownMenuItem<dynamic>(
                              value: item,
                              child: MyText(
                                text: item,
                                size: 12,
                                color: kBlack,
                                weight: FontWeight.w600,
                                fontFamily: AppFonts.Nunito,
                              ),
                            ),
                          )
                          .toList(),
                  value: selectedValue == hint ? null : selectedValue,
                  hint: MyText(
                    text: hint,
                    size: 12,
                    color: kSubText,
                    fontFamily: AppFonts.Nunito,
                    textAlign: TextAlign.start,
                    weight: FontWeight.w500,
                  ),
                  onChanged: onChanged,
                  iconStyleData: const IconStyleData(icon: SizedBox()),
                  isDense: true,
                  isExpanded: true,
                  customButton: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 48,
                    decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(color: kBorderColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AnimatedRow(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: selectedValue == hint ? hint : selectedValue,
                          size: 12,
                          color: kSubText,
                          weight: FontWeight.w600,
                          fontFamily: AppFonts.Nunito,
                        ),
                        CommonImageView(
                          imagePath: Assets.imagesArrowDownGrey,
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(height: 35),
                  dropdownStyleData: DropdownStyleData(
                    elevation: 6,
                    maxHeight: 300,
                    offset: const Offset(0, -5),
                    decoration: BoxDecoration(
                      border: Border.all(color: kBorderColor),
                      borderRadius: BorderRadius.circular(10),
                      color: kWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropDown3 extends StatelessWidget {
  const CustomDropDown3({
    super.key,
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.bgColor,
    this.marginBottom,
    this.width,
    this.labelText,
  });

  final List<dynamic>? items;
  final String selectedValue;
  final ValueChanged<dynamic>? onChanged;
  final String hint;
  final String? labelText;
  final Color? bgColor;
  final double? marginBottom, width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom ?? 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            MyText(
              paddingBottom: 10,
              text: labelText!,
              size: 16,
              color: kBlack,
              fontFamily: AppFonts.Nunito,
              textAlign: TextAlign.start,
              weight: FontWeight.w600,
            ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              items:
                  items!
                      .map(
                        (item) => DropdownMenuItem<dynamic>(
                          value: item,
                          child: MyText(
                            text: item,
                            size: 12,
                            color: kBlack,
                            weight: FontWeight.w400,
                            fontFamily: AppFonts.Nunito,
                          ),
                        ),
                      )
                      .toList(),
              value: selectedValue == hint ? null : selectedValue,
              hint: MyText(
                text: hint,
                size: 14,
                color: kWhite,
                fontFamily: AppFonts.Nunito,
                textAlign: TextAlign.start,
                weight: FontWeight.w400,
              ),
              onChanged: onChanged,
              iconStyleData: const IconStyleData(icon: SizedBox()),
              isDense: true,
              isExpanded: true,
              customButton: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                height: 48,
                decoration: BoxDecoration(
                  color: kTransperentColor,
                  border: const Border(
                    bottom: BorderSide(
                      color: kBlack150,
                      width: 1.0, // Adjust the width as needed
                    ),
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: selectedValue == hint ? hint : selectedValue,
                      size: 14,
                      color: kWhite,
                      weight: FontWeight.w400,
                      fontFamily: AppFonts.Nunito,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: CommonImageView(
                        imagePath: Assets.imagesArrowDownGrey,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(height: 35),
              dropdownStyleData: DropdownStyleData(
                elevation: 6,
                maxHeight: 300,
                offset: const Offset(0, -5),
                decoration: BoxDecoration(
                  border: Border.all(color: kBorderColor),
                  borderRadius: BorderRadius.circular(10),
                  color: kWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropDownFlag extends StatelessWidget {
  const CustomDropDownFlag({
    super.key,
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.bgColor,
    this.marginBottom,
    this.width,
    this.labelText,
  });

  final List<Map<String, String>>?
  items; // Updated to accept map without 'name'
  final String selectedValue;
  final ValueChanged<dynamic>? onChanged;
  final String hint;
  final String? labelText;
  final Color? bgColor;
  final double? marginBottom, width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom ?? 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            MyText(
              paddingBottom: 5,
              text: labelText!,
              size: 16,
              fontFamily: AppFonts.Nunito,
              textAlign: TextAlign.start,
              weight: FontWeight.w600,
            ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              items:
                  items!
                      .map(
                        (item) => DropdownMenuItem<dynamic>(
                          value: item['code'],
                          child: Row(
                            children: [
                              // Display only country flag emoji
                              Text(
                                item['flag'] ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              // Display only country code
                              MyText(
                                text: item['code'] ?? '',
                                size: 14,
                                color: kBlack,
                                fontFamily: AppFonts.Nunito,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
              value: selectedValue == hint ? null : selectedValue,
              hint: MyText(
                text: hint,
                size: 16,
                textAlign: TextAlign.start,
                weight: FontWeight.w600,
              ),
              onChanged: onChanged,
              iconStyleData: const IconStyleData(icon: SizedBox()),
              isDense: true,
              isExpanded: true,
              customButton: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: kGreyDividerColor, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Display selected flag and code in button
                        if (selectedValue != hint)
                          Text(
                            items!.firstWhere(
                                  (item) => item['code'] == selectedValue,
                                )['flag'] ??
                                "",
                            style: const TextStyle(fontSize: 14),
                          ),
                        const SizedBox(width: 8),
                        MyText(
                          text:
                              selectedValue == hint
                                  ? hint
                                  : items!.firstWhere(
                                        (item) => item['code'] == selectedValue,
                                      )['code'] ??
                                      '',
                          size: 14,
                          color: kBlack,
                          fontFamily: AppFonts.Nunito,
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(height: 35),
              dropdownStyleData: DropdownStyleData(
                elevation: 6,
                maxHeight: 300,
                offset: const Offset(0, -5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropDownFlag2 extends StatelessWidget {
  const CustomDropDownFlag2({
    super.key,
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.bgColor,
    this.marginBottom,
    this.width,
    this.labelText,
  });

  final List<Map<String, String>>?
  items; // Updated to accept map without 'name'
  final String selectedValue;
  final ValueChanged<dynamic>? onChanged;
  final String hint;
  final String? labelText;
  final Color? bgColor;
  final double? marginBottom, width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom ?? 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            MyText(
              paddingBottom: 5,
              text: labelText!,
              size: 16,
              fontFamily: AppFonts.Nunito,
              textAlign: TextAlign.start,
              weight: FontWeight.w600,
            ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              items:
                  items!
                      .map(
                        (item) => DropdownMenuItem<dynamic>(
                          value: item['code'],
                          child: Row(
                            children: [
                              // Display only country flag emoji
                              Text(
                                item['flag'] ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              // Display only country code
                              MyText(
                                text: item['code'] ?? '',
                                size: 14,
                                color: kBlack,
                                fontFamily: AppFonts.Nunito,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
              value: selectedValue == hint ? null : selectedValue,
              hint: MyText(
                text: hint,
                size: 16,
                textAlign: TextAlign.start,
                weight: FontWeight.w600,
              ),
              onChanged: onChanged,
              iconStyleData: const IconStyleData(icon: SizedBox()),
              isDense: true,
              isExpanded: true,
              customButton: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: kGreyDividerColor, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Display selected flag and code in button
                        if (selectedValue != hint)
                          Text(
                            items!.firstWhere(
                                  (item) => item['code'] == selectedValue,
                                )['flag'] ??
                                "",
                            style: const TextStyle(fontSize: 14),
                          ),
                        const SizedBox(width: 8),
                        MyText(
                          text:
                              selectedValue == hint
                                  ? hint
                                  : items!.firstWhere(
                                        (item) => item['code'] == selectedValue,
                                      )['code'] ??
                                      '',
                          size: 14,
                          color: kBlack,
                          fontFamily: AppFonts.Nunito,
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(height: 35),
              dropdownStyleData: DropdownStyleData(
                elevation: 6,
                maxHeight: 300,
                offset: const Offset(0, -5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

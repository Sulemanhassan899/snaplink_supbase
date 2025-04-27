import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_row.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';

class TabButton extends StatelessWidget {
  final String title;
  final String iconPath;
  final String selectedTab;
  final VoidCallback onTap;

  const TabButton({
    super.key,
    required this.title,
    required this.iconPath,
    required this.selectedTab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedTab == title;

    return Bounce(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient:
              isSelected
                  ? kContainerBackgroundGradeintColor
                  : const LinearGradient(colors: [kGreyColor6, kGreyColor6]),
        ),
        child: AnimatedRow(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonImageView(imagePath: iconPath, height: 16),
            MyText(
              text: title,
              size: 12,
              paddingRight: 6,
              color: isSelected ? kWhite : kBlack,
              textAlign: TextAlign.start,
              weight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}

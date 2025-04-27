import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/views/widget/common_image_view_widget.dart';
import 'package:snaplink/views/widget/custom_animated_row.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';

// class FliterChipCutom extends StatefulWidget {
//   final String img;
//   final String text;

//   const FliterChipCutom({super.key, required this.img, required this.text});

//   @override
//   State<FliterChipCutom> createState() => _FliterChipCutomState();
// }

// class _FliterChipCutomState extends State<FliterChipCutom> {
//   bool isSelected = false;

//   void _toggleSelection() {
//     setState(() {
//       isSelected = !isSelected;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _toggleSelection,
//       child: Container(
//         height: 40,
//         width: 130,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(50),
//           border: Border.all(color: isSelected ? kPrimaryColor : kBorderColor),
//           gradient: isSelected ? kContainerBackgroundGradeintColor : null,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CommonImageView(imagePath: widget.img, height: 20),
//             MyText(
//               text: widget.text,
//               color: isSelected ? kWhite : kBlack,
//               size: 12,
//               paddingLeft: 4,
//               textAlign: TextAlign.start,
//               weight: FontWeight.w500,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class FliterChipCutom extends StatefulWidget {
  final String img;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const FliterChipCutom({
    super.key,
    required this.img,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<FliterChipCutom> createState() => _FliterChipCutomState();
}

class _FliterChipCutomState extends State<FliterChipCutom> {
  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: widget.onTap,
      child: Container(
        height: 40,
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: widget.isSelected ? kPrimaryColor : kBorderColor,
          ),
          gradient:
              widget.isSelected ? kContainerBackgroundGradeintColor : null,
        ),
        child: AnimatedRow(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonImageView(imagePath: widget.img, height: 20),
            MyText(
              text: widget.text,
              color: widget.isSelected ? kWhite : kBlack,
              size: 12,
              paddingLeft: 4,
              textAlign: TextAlign.start,
              weight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}

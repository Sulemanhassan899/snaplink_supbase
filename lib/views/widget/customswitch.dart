import 'package:flutter/material.dart';
import 'package:snaplink/constants/app_colors.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 32,
        height: 20,
        decoration: BoxDecoration(
          border: Border.all(color: kBorderColor),
          borderRadius: BorderRadius.circular(9.5),
          color: value ? kPrimaryColor : kGreyColor5,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              left: value ? 14 : 2,
              top: 2,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class CustomSwitch2 extends StatelessWidget {
//   final bool value;
//   final ValueChanged<bool> onChanged;

//   const CustomSwitch2({
//     super.key,
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => onChanged(!value),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         width: 44,
//         height: 14,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: value ? kGreyColor6 : null, // Active & inactive colors
//         ),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             AnimatedPositioned(
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//               left: value ? 22 : 2, // Toggle button movement
//               child: Container(
//                 width: 20,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: kPrimaryColor,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 3,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CustomSwitch2 extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch2({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: SizedBox(
        width: 40, // Matches the image proportions
        height: 20,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: value ? kGreyColor6 : kGreyColor3,
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: value ? 20 : 2, // Adjusts knob position
              child: Container(
                width: 20,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue, // Knob color as in image
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSwitchSquare extends StatefulWidget {
  const CustomSwitchSquare({super.key});

  @override
  _CustomSwitchSquareState createState() => _CustomSwitchSquareState();
}

class _CustomSwitchSquareState extends State<CustomSwitchSquare> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOn = !isOn;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 30,
        height: 20,
        decoration: BoxDecoration(
          gradient: isOn ? kTexfeildGradeintColor2 : null,
          color: isOn ? null : Colors.grey[700],
          borderRadius: BorderRadius.circular(2), // Background color
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: isOn ? 16 : 2, // Moves toggle
              top: 2,
              child: Container(
                width: 12,
                height: 16,
                decoration: BoxDecoration(
                  color: isOn ? kWhite : Colors.grey[500], // Toggle color
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectableCircle extends StatefulWidget {
  const SelectableCircle({super.key});

  @override
  _SelectableCircleState createState() => _SelectableCircleState();
}

class _SelectableCircleState extends State<SelectableCircle> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: kBorderColor, width: 2),
          color: Colors.white,
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: kTexfeildGradeintColor2,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/constants/app_fonts.dart';
import 'package:snaplink/views/widget/custom_animated_row.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomWeeklyWeekPicker extends StatefulWidget {
  const CustomWeeklyWeekPicker({super.key});

  @override
  _CustomWeeklyWeekPickerState createState() => _CustomWeeklyWeekPickerState();
}

class _CustomWeeklyWeekPickerState extends State<CustomWeeklyWeekPicker> {
  final DateTime _currentDate = DateTime.now();
  int _selectedWeek = 2; // Example selected week
  final List<String> _months = [
    "January 2024",
    "February 2024",
    "March 2024",
    "April 2024",
    "May 2024",
    "June 2024",
    "July 2024",
    "August 2024",
    "September 2024",
    "October 2024",
    "November 2024",
    "December 2024",
  ];
  String _selectedMonth = "March 2024"; // Default selected month

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Weekly Selector
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBorderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      customButton: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AnimatedRow(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MyText(
                              text: _selectedMonth,
                              size: 16,
                              paddingRight: 10,
                              fontFamily: AppFonts.Nunito,
                              weight: FontWeight.w600,
                            ),
                            const Icon(Icons.arrow_drop_down, size: 30),
                          ],
                        ),
                      ),
                      value: _selectedMonth,

                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: kTransperentColor),
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedMonth = newValue!;
                        });
                      },
                      items:
                          _months.map((String month) {
                            return DropdownMenuItem<String>(
                              value: month,
                              child: Text(
                                month,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: AppFonts.Nunito,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
              AnimatedRow(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _weekButton(index + 1)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _weekButton(int weekNumber) {
    bool isSelected = _selectedWeek == weekNumber;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedWeek = weekNumber;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? kPrimaryColor
                  : Colors.grey.shade300, // Light brown or grey
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected
                    ? kPrimaryColor
                    : Colors.transparent, // Brown or transparent
          ),
        ),
        child: Column(
          children: [
            Text(
              "WEEK",
              style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.Nunito,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.brown : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "0$weekNumber",
              style: TextStyle(
                fontSize: 16,
                fontFamily: AppFonts.Nunito,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.brown : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

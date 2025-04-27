import 'package:flutter/material.dart';
import 'package:snaplink/constants/app_colors.dart';
import 'package:snaplink/views/widget/my_text_widget.dart';
import 'package:week_of_year/week_of_year.dart';
import "package:weekly_date_picker/datetime_apis.dart";

class CustomWeeklyDatePicker extends StatefulWidget {
  const CustomWeeklyDatePicker({
    super.key,
    required this.selectedDays,
    required this.changeDays,
    this.weekdays = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    this.backgroundColor = Colors.white,
    this.selectedDigitBackgroundColor = const Color(0xFF1a237e),
    this.selectedDigitBorderColor = Colors.transparent,
    this.selectedDigitColor = Colors.white,
    this.digitsColor = const Color(0xFF424242),
    this.weekdayTextColor,
    this.enableWeeknumberText = false,
    this.weeknumberColor = Colors.transparent,
    this.weeknumberTextColor = Colors.transparent,
    this.daysInWeek = 7,
  }) : assert(
         weekdays.length == daysInWeek,
         "weekdays must be of length $daysInWeek",
       );

  final Set<DateTime> selectedDays;
  final Function(Set<DateTime>) changeDays;
  final List<String> weekdays;
  final Color backgroundColor;
  final Color selectedDigitBackgroundColor;
  final Color selectedDigitBorderColor;
  final Color selectedDigitColor;
  final Color digitsColor;
  final Color? weekdayTextColor;
  final bool enableWeeknumberText;
  final Color weeknumberColor;
  final Color weeknumberTextColor;
  final int daysInWeek;

  @override
  _WeeklyDatePickerState createState() => _WeeklyDatePickerState();
}

class _WeeklyDatePickerState extends State<CustomWeeklyDatePicker> {
  late DateTime _currentDate;
  late PageController _controller;
  late DateTime _initialSelectedDay;
  late int _weeknumberInSwipe;
  final DateTime _todaysDateTime = DateTime.now();
  final int _weekIndexOffset = 5200;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _initialSelectedDay =
        widget.selectedDays.isNotEmpty
            ? widget.selectedDays.first
            : DateTime.now();

    // Calculate initial page based on the selected date's week
    int initialWeekDifference =
        _initialSelectedDay.difference(_todaysDateTime).inDays ~/ 7;
    _controller = PageController(
      initialPage: _weekIndexOffset + initialWeekDifference,
    );
    _weeknumberInSwipe = _initialSelectedDay.weekOfYear;

    // Set initial selection
    if (widget.selectedDays.isEmpty) {
      widget.selectedDays.add(_initialSelectedDay);
      widget.changeDays(widget.selectedDays);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateMonth(bool increment) {
    setState(() {
      // Clear previous selection
      widget.selectedDays.clear();

      // Update current date to new month
      if (increment) {
        _currentDate = DateTime(
          _currentDate.year,
          _currentDate.month + 1,
          _currentDate.day,
        );
      } else {
        _currentDate = DateTime(
          _currentDate.year,
          _currentDate.month - 1,
          _currentDate.day,
        );
      }

      // Update selected day to the same day in new month
      _initialSelectedDay = _currentDate;
      widget.selectedDays.add(_initialSelectedDay);
      widget.changeDays(widget.selectedDays);

      // Calculate new page index based on the week difference
      int weekDifference =
          _initialSelectedDay.difference(_todaysDateTime).inDays ~/ 7;
      int newPage = _weekIndexOffset + weekDifference;

      // Jump to the week containing the selected date
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.jumpToPage(newPage);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 80,
          color: widget.backgroundColor,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (int index) {
              setState(() {
                _weeknumberInSwipe =
                    _initialSelectedDay
                        .addDays(7 * (index - _weekIndexOffset))
                        .weekOfYear;
              });
            },
            padEnds: true,
            scrollDirection: Axis.horizontal,
            itemBuilder:
                (_, weekIndex) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _weekdays(weekIndex - _weekIndexOffset),
                ),
          ),
        ),
      ],
    );
  }

  List<Widget> _weekdays(int weekIndex) {
    List<Widget> weekdays = [];
    for (int i = 0; i < widget.daysInWeek; i++) {
      final int offset = i - _initialSelectedDay.weekday;
      final int daysToAdd = weekIndex * 7 + offset;
      final DateTime dateTime = _initialSelectedDay.addDays(daysToAdd);
      weekdays.add(_dateButton(dateTime));
    }
    return weekdays;
  }

  Widget _dateButton(DateTime dateTime) {
    final String weekday = widget.weekdays[dateTime.weekday % 7];
    final bool isSelected = widget.selectedDays.any(
      (date) => date.isSameDateAs(dateTime),
    );

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              widget.selectedDays.removeWhere(
                (date) => date.isSameDateAs(dateTime),
              );
            } else {
              widget.selectedDays.add(dateTime);
            }
            widget.changeDays(widget.selectedDays);
          });
        },
        child: Container(
          height: 61,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? widget.selectedDigitBackgroundColor : kWhite,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color:
                  isSelected
                      ? widget.selectedDigitBackgroundColor
                      : kDividerColor,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                text: weekday,
                size: 12,
                weight: FontWeight.w400,
                color: isSelected ? Colors.white : kSubText,
              ),
              const SizedBox(height: 4),
              MyText(
                text: '${dateTime.day}',
                size: 16,
                weight: FontWeight.w600,
                color: isSelected ? Colors.white : kSubText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

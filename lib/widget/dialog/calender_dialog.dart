import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/text_style.dart';
import '../../core/util/extension/date_extension.dart';
import '../../core/util/method/global_methods.dart';
import '../../gen/assets.gen.dart';
import '../button/btn_primary.dart';
import '../button/btn_secondary.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime? selectedDate;
  final DateTime firstDay;
  final DateTime lastDay;
  final bool showNoDate;
  final void Function(DateTime? date)? onSelect;
  const CustomCalendar({
    super.key,
    this.selectedDate,
    required this.firstDay,
    required this.lastDay,
    this.showNoDate = false,
    this.onSelect,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  final DateTime today = DateTime.now();
  late final DateTime nextMonday = today.next(DateTime.monday);
  late final DateTime nextTuesday = today.next(DateTime.tuesday);
  late final DateTime afterWeek = today.after(7);

  late final ValueNotifier<DateTime?> _focusedDay = ValueNotifier(widget.selectedDate);
  late final ValueNotifier<DateTime> _focusedMonth = ValueNotifier(widget.selectedDate ?? today);

  /// Do not dispose this, [TableCalendar] will dispose
  late PageController _pageController;

  bool get isToday => isSameDay(_focusedDay.value, today);
  bool get isNextMonday => isSameDay(_focusedDay.value, nextMonday);
  bool get isNextTuesday => isSameDay(_focusedDay.value, nextTuesday);
  bool get isAfterWeek => isSameDay(_focusedDay.value, afterWeek);

  @override
  void dispose() {
    _focusedDay.dispose();
    _focusedMonth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Buttons
          if (widget.showNoDate) topTwoButton() else ...topButtons(),

          ValueListenableBuilder<DateTime>(
            valueListenable: _focusedMonth,
            builder: (context, value, _) {
              return _CalendarHeader(
                date: value,
                onLeftArrowTap: isSameMonth(value, widget.firstDay)
                    ? null
                    : () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                onRightArrowTap: isSameMonth(value, widget.lastDay)
                    ? null
                    : () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
              );
            },
          ),
          _CalendarTable(
            firstDay: widget.firstDay,
            lastDay: widget.lastDay,
            today: today,
            focusedDay: _focusedDay,
            focusedMonth: _focusedMonth,
            onPageCreated: (controller) {
              _pageController = controller;
            },
            onDaySelected: (day) {
              setState(() {
                _focusedDay.value = day;
              });
            },
          ),
          const SizedBox(
            height: 24.0,
          ),
          const Divider(
            height: 1,
            color: ColorName.borderColor,
          ),
          const SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Assets.svgs.calendarIcon.svg(
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: ValueListenableBuilder<DateTime?>(
                    valueListenable: _focusedDay,
                    builder: (context, value, _) {
                      return Text(
                        value?.todMMMyyyy() ?? "No Date",
                        style: CustomTextStyles.k15,
                      );
                    },
                  ),
                ),
                BtnSecondary(
                  title: "Cancel",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  width: 16.0,
                ),
                BtnPrimary(
                  title: "Save",
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onSelect?.call(
                      _focusedDay.value,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget topTwoButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: BtnSecondary(
              title: "No Date",
              isSelected: _focusedDay.value == null,
              onPressed: () {
                onChangeDate(null);
              },
            ),
          ),
          const SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: BtnSecondary(
              title: "Today",
              isSelected: isToday,
              onPressed: () {
                onChangeDate(today);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> topButtons() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: BtnSecondary(
                title: "Today",
                isSelected: isToday,
                onPressed: () {
                  onChangeDate(today);
                },
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: BtnSecondary(
                title: "Next Monday",
                isSelected: isNextMonday,
                onPressed: () {
                  onChangeDate(nextMonday);
                },
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: BtnSecondary(
                title: "Next Tuesday",
                isSelected: isNextTuesday,
                onPressed: () {
                  onChangeDate(nextTuesday);
                },
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: BtnSecondary(
                title: "After 1 week",
                isSelected: isAfterWeek,
                onPressed: () {
                  onChangeDate(afterWeek);
                },
              ),
            ),
          ],
        ),
      ),
    ];
  }

  void onChangeDate(DateTime? date) {
    setState(() {
      _focusedDay.value = date;
    });
  }
}

class _CalendarTable extends StatelessWidget {
  final void Function(PageController controller) onPageCreated;
  final void Function(DateTime day) onDaySelected;
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime today;
  final ValueNotifier<DateTime?> focusedDay;
  final ValueNotifier<DateTime> focusedMonth;
  const _CalendarTable({
    required this.onPageCreated,
    required this.firstDay,
    required this.lastDay,
    required this.today,
    required this.focusedDay,
    required this.focusedMonth,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TableCalendar(
        onCalendarCreated: onPageCreated,
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: CustomTextStyles.k15,
          weekendStyle: CustomTextStyles.k15,
        ),
        firstDay: firstDay,
        lastDay: lastDay,
        focusedDay: focusedDay.value ?? today,
        headerVisible: false,
        onPageChanged: (date) {
          focusedMonth.value = date;
        },
        onDaySelected: (selectedDay, focusedDay) {
          onDaySelected(selectedDay);
        },
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, _) {
            final isSame = isSameDay(day, focusedDay.value);

            return _DayCell(date: day, isSelected: isSame);
          },
          todayBuilder: (context, day, _) {
            final isSame = isSameDay(day, focusedDay.value);
            return _DayCell(
              date: day,
              isSelected: isSame,
              isToday: true,
            );
          },
          outsideBuilder: (context, day, focusedDay) {
            return const SizedBox();
          },
          disabledBuilder: (context, day, focusedDay) {
            return _DayCell(
              date: day,
              isSelected: false,
              isToday: false,
              isDisabled: true,
            );
          },
        ),
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime date;
  final VoidCallback? onLeftArrowTap;
  final VoidCallback? onRightArrowTap;

  const _CalendarHeader({
    required this.date,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onLeftArrowTap,
            icon: RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.arrow_drop_down_rounded,
                size: 35,
                color: onLeftArrowTap == null ? ColorName.borderColor : ColorName.lightTextColor,
              ),
            ),
          ),
          Text(
            date.toMMMMyyyy(),
            style: CustomTextStyles.k18Medium,
          ),
          IconButton(
            onPressed: onRightArrowTap,
            disabledColor: ColorName.borderColor,
            icon: RotatedBox(
              quarterTurns: 3,
              child: Icon(
                Icons.arrow_drop_down_rounded,
                size: 35,
                color: onRightArrowTap == null ? ColorName.borderColor : ColorName.lightTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool isDisabled;
  const _DayCell({
    required this.date,
    required this.isSelected,
    this.isToday = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? ColorName.blueColor : Colors.transparent,
        border: isToday ? Border.all(width: 1, color: ColorName.blueColor) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          '${date.day}',
          style: CustomTextStyles.k15.copyWith(
            color: dateColor,
          ),
        ),
      ),
    );
  }

  Color get dateColor {
    if (isSelected) {
      return Colors.white;
    } else if (isToday) {
      return ColorName.blueColor;
    } else if (isDisabled) {
      return ColorName.lightTextColor;
    } else {
      return ColorName.textColor;
    }
  }
}

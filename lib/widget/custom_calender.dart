// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';

// class WeekCelendar extends StatefulWidget {
//   final void Function(DateTime) onDateChange;
//   final DateTime initialDate;
//   final DateTime firstDate;
//   final DateTime lastDate;
//   const WeekCelendar({
//     required this.initialDate,
//     required this.onDateChange,
//     required this.firstDate,
//     required this.lastDate,
//     super.key,
//   });

//   @override
//   State<WeekCelendar> createState() => _WeekCelendarState();
// }

// class _WeekCelendarState extends State<WeekCelendar> {
//   late final ValueNotifier<DateTime> _focusedDay =
//       ValueNotifier(widget.initialDate);

//   late PageController _pageController;

//   @override
//   void dispose() {
//     super.dispose();
//     _focusedDay.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ValueListenableBuilder<DateTime>(
//           valueListenable: _focusedDay,
//           builder: (context, value, _) {
//             return _CalendarHeader(
//               focusedDay: value,
//               onLeftArrowTap: () {
//                 _pageController.previousPage(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeOut,
//                 );
//               },
//               onRightArrowTap: () {
//                 _pageController.nextPage(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeOut,
//                 );
//               },
//             );
//           },
//         ),
//         TableCalendar(
//           calendarFormat: CalendarFormat.week,
//           headerStyle: const HeaderStyle(
//             decoration: BoxDecoration(color: ColorName.primaryColor),
//           ),
//           firstDay: widget.firstDate,
//           lastDay: widget.lastDate,
//           focusedDay: _focusedDay.value,
//           headerVisible: false,
//           daysOfWeekVisible: false,
//           onCalendarCreated: (controller) => _pageController = controller,
//           rowHeight: 60,
//           onDaySelected: (selectedDay, focusedDay) {
//             widget.onDateChange(selectedDay);
//             _focusedDay.value = selectedDay;
//             setState(() {});
//           },
//           calendarBuilders: CalendarBuilders(
//             defaultBuilder: (context, day, focusedDay) {
//               final isSame = isSameDay(day, _focusedDay.value);

//               return _DayCell(date: day, isSelected: isSame);
//             },
//             todayBuilder: (context, day, focusedDay) {
//               final isSame = isSameDay(day, _focusedDay.value);
//               return _DayCell(
//                 date: day,
//                 isSelected: isSame,
//                 isToday: true,
//               );
//             },
//             outsideBuilder: (context, day, focusedDay) {
//               final isSame = isSameDay(day, _focusedDay.value);
//               return _DayCell(
//                 date: day,
//                 isSelected: isSame,
//                 isToday: false,
//               );
//             },
//             disabledBuilder: (context, day, focusedDay) {
//               return _DayCell(
//                 date: day,
//                 isSelected: false,
//                 isToday: false,
//                 isDisabled: true,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _CalendarHeader extends StatelessWidget {
//   final DateTime focusedDay;
//   final VoidCallback onLeftArrowTap;
//   final VoidCallback onRightArrowTap;

//   const _CalendarHeader({
//     required this.focusedDay,
//     required this.onLeftArrowTap,
//     required this.onRightArrowTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           const SizedBox(width: 16.0),
//           Text(
//             focusedDay.toddMMM(),
//             style: CustomTextStyles.k18.copyWith(color: Colors.white),
//           ),
//           IconButton(
//             icon: const Icon(Icons.chevron_left, color: Colors.white),
//             onPressed: onLeftArrowTap,
//           ),
//           IconButton(
//             icon: const Icon(Icons.chevron_right, color: Colors.white),
//             onPressed: onRightArrowTap,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DayCell extends StatelessWidget {
//   final DateTime date;
//   final bool isSelected;
//   final bool isToday;
//   final bool isDisabled;
//   const _DayCell({
//     required this.date,
//     required this.isSelected,
//     this.isToday = false,
//     this.isDisabled = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DecoratedBox(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(6.0),
//         color: isSelected ? ColorName.yellow500 : Colors.transparent,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               date.toWeekDay2(),
//               style: CustomTextStyles.k16.copyWith(
//                 color: dateColor,
//               ),
//             ),
//             Text(
//               '${date.day}',
//               style: CustomTextStyles.k16.copyWith(
//                 color: dateColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color get dateColor {
//     if (isToday) {
//       return ColorName.primaryColor;
//     } else if (isDisabled) {
//       return ColorName.grey100;
//     } else {
//       return ColorName.white;
//     }
//   }
// }

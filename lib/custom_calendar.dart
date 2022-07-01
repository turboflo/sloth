import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar_field.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({Key? key}) : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  final todaysDate = DateTime.now();
  var _focusedCalendarDate = DateTime.now();
  final _initialCalendarDate = DateTime(2000);
  final _lastCalendarDate = DateTime(2050);
  DateTime? selectedCalendarDate;

  @override
  void initState() {
    selectedCalendarDate = _focusedCalendarDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              //
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) => CalendarField(
                  day: day,
                  focusedDay: focusedDay,
                ),
                selectedBuilder: (context, day, focusedDay) => CalendarField(
                  day: day,
                  focusedDay: focusedDay,
                ),
                todayBuilder: (context, day, focusedDay) => CalendarField(
                  day: day,
                  focusedDay: focusedDay,
                ),
                outsideBuilder: (context, day, focusedDay) => CalendarField(
                  day: day,
                  focusedDay: focusedDay,
                ),
              ),
              //
              focusedDay: _focusedCalendarDate,
              firstDay: _initialCalendarDate,
              lastDay: _lastCalendarDate,
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,

              selectedDayPredicate: (currentSelectedDate) {
                return (isSameDay(selectedCalendarDate!, currentSelectedDate));
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(selectedCalendarDate, selectedDay)) {
                  setState(() {
                    selectedCalendarDate = selectedDay;
                    _focusedCalendarDate = focusedDay;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
    ;
  }
}

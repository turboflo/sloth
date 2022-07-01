import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sloth/boxes.dart';
import 'package:sloth/model/event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

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
  final _lastCalendarDate = DateTime(DateTime.now().year + 2, 12);
  DateTime? selectedCalendarDate;

  @override
  void initState() {
    selectedCalendarDate = _focusedCalendarDate;
    // Boxes.getEvents().deleteAll(List.generate(20, (index) => index));
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  void addEvent(DateTime day) {
    final event = Event()
      ..title = '16:00 - 20:00'
      ..type = EventType.work.toString()
      ..day = DateUtils.dateOnly(day);

    final box = Boxes.getEvents();
    box.add(event);
  }

  showAddEventDialog(BuildContext context) {
    final con = TextEditingController();
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.pop(context),
    );
    Widget continueButton = TextButton(
      child: const Text("Add"),
      onPressed: () {
        addEvent(_focusedCalendarDate);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Add Event"),
      // content: TextField(
      //   controller: con,
      //   inputFormatters: [
      //     // FilteringTextInputFormatter.allow(
      //     //   RegExp(
      //     //     r'^(?:[01]?\d|2[0-3])(?::(?:[0-5]\d?)?)?$',
      //     //     caseSensitive: false,
      //     //     multiLine: false,
      //     //   ),
      //     // ),
      //   ],
      // ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showAddEventDialog(context),
      ),
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

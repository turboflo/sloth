import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sloth/boxes.dart';
import 'package:sloth/main.dart';
import 'package:sloth/model/event.dart';
import 'package:sloth/service/default_settings.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widget/calendar_field.dart';
import '../widget/time_range_field.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
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

  void addEvent({
    required String title,
    required String eventType,
    required DateTime day,
  }) {
    final event = Event(
      title: title,
      type: eventType,
      day: DateUtils.dateOnly(day),
    );
    ref.read(eventsProvider.notifier).add(event);
    final box = Boxes.getEvents();
    box.add(event);
  }

  String capitalize(String string) {
    return "${string[0].toUpperCase()}${string.substring(1).toLowerCase()}";
  }

  showAddEventDialog(BuildContext context) {
    final DefaultSettings defaultSettings = DefaultSettings();
    final startTimeCon = TextEditingController();
    final endTimeCon = TextEditingController();
    startTimeCon.text = defaultSettings.eventTitle.split('-').first.trim();
    endTimeCon.text = defaultSettings.eventTitle.split('-').last.trim();
    final items = [
      DropdownMenuItem(
        value: EventType.work.name,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Icon(eventIcons[EventType.work.name]),
              const SizedBox(width: 10),
              const Text('Arbeit'),
            ],
          ),
        ),
      ),
      DropdownMenuItem(
        value: EventType.vacation.name,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Icon(eventIcons[EventType.vacation.name]),
              const SizedBox(width: 10),
              const Text('Urlaub'),
            ],
          ),
        ),
      )
    ];
    final eventTypes = [
      EventType.work.name,
      EventType.holiday.name,
    ];
    String dropdownValue = eventTypes.first;

    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Abbrechen"),
      onPressed: () => Navigator.pop(context),
    );
    Widget continueButton = TextButton(
      child: const Text("Speichern"),
      onPressed: () {
        late String title;
        switch (dropdownValue) {
          case 'work':
            title = '${startTimeCon.text} - ${endTimeCon.text}';
            break;
          case 'vacation':
            title = 'Urlaub';
            break;
          default:
            title = '';
        }
        addEvent(
          title: title,
          eventType: dropdownValue,
          day: _focusedCalendarDate,
        );
        Navigator.pop(context);
      },
    );
    String title =
        '${_focusedCalendarDate.day}.${_focusedCalendarDate.month}.${_focusedCalendarDate.year}';
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          final colors = Theme.of(context).colorScheme;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colors.onBackground.withOpacity(0.5),
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                ),
                child: DropdownButton<String>(
                  underline: Container(),
                  value: dropdownValue,
                  isExpanded: true,
                  items: items,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              if (dropdownValue == EventType.work.name)
                TimeRangeField(
                    startTimeCon: startTimeCon, endTimeCon: endTimeCon),
            ],
          );
        },
      ),
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
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showAddEventDialog(context),
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'de_DE',
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
          Expanded(child: Container()),
          Row(
            children: [
              Icon(
                eventIcons[EventType.holiday.name],
                size: 15,
                color: colors.onBackground.withOpacity(0.5),
              ),
              Text(
                ' Feiertag',
                style: TextStyle(
                  fontSize: 15,
                  color: colors.onBackground.withOpacity(0.5),
                ),
              )
            ],
          ),
          const SizedBox(height: 9),
        ],
      ),
    );
    ;
  }
}

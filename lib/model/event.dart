import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:sloth/model/holiday.dart';

part 'event.g.dart';

@HiveType(typeId: 0)
class Event extends HiveObject {
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String type;
  @HiveField(2)
  late DateTime day;

  Event({required this.title, required this.type, required this.day});

  factory Event.fromHoliday(Holiday holiday) => Event(
        title: holiday.name,
        type: EventType.holiday.name,
        day: holiday.day,
      );

  @override
  String toString() {
    return 'Event($title, $type, $day)';
  }
}

class EventNotifier extends ChangeNotifier {
  final events = <Event>[];

  void replaceAll(List<Event> eventList) {
    events.clear();
    events.addAll(eventList);
    notifyListeners();
  }

  void addAll(List<Event> eventList) {
    events.addAll(eventList);
    notifyListeners();
  }

  void add(Event event) {
    events.add(event);
    notifyListeners();
  }

  void remove(Event event) {
    events.remove(event);
    notifyListeners();
  }
}

enum EventType {
  work,
  holiday,
  vacation,
}

final Map<String, IconData> eventIcons = {
  EventType.work.name: Icons.work_history,
  EventType.vacation.name: Icons.celebration,
  EventType.holiday.name: Icons.event,
};

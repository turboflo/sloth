import 'package:hive_flutter/hive_flutter.dart';

import '../model/event.dart';

class DefaultService {
  final box = Hive.box('settings');

  String get eventType => 'work';
  String get eventTitle =>
      box.get('defaultTitle', defaultValue: '16:00 - 20:00');

  List<int> get validWeekdays =>
      box.get('defaultWeekdays', defaultValue: <int>[1, 2, 3, 4, 5]);

  Event getEvent(DateTime day) =>
      Event(title: eventTitle, type: eventType, day: day);

  bool isDayValid(DateTime day) => validWeekdays.contains(day.weekday);
}

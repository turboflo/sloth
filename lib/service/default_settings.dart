import 'package:hive_flutter/hive_flutter.dart';

import '../model/event.dart';

class DefaultSettings {
  final box = Hive.box('settings');

  String get eventType => 'work';
  String get eventTitle => box.get('defaultTitle', defaultValue: '');

  List<dynamic> get validWeekdays =>
      box.get('defaultWeekdays', defaultValue: <int>[]);

  Event getEvent(DateTime day) =>
      Event(title: eventTitle, type: eventType, day: day);

  bool isDayValid(DateTime day) => validWeekdays.contains(day.weekday);

  void setEventTitle(String title) => box.put('defaultTitle', title);

  void setValidWeekdays(List<dynamic> validWeekdays) =>
      box.put('defaultWeekdays', validWeekdays);
}

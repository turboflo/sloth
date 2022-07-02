import 'package:hive/hive.dart';
import 'package:sloth/model/event.dart';

import '../boxes.dart';
import '../model/holiday.dart';
import 'holiday_api.dart';

class EventLoader {
  static final HolidayAPI _holidayAPI = HolidayAPI();
  final box = Hive.box('settings');

  Future<List<Event>> getAll() async => [
        ...await getFromBoxes(),
        ...await getHolidaysFromAPI(),
      ];

  Future<List<Event>> getFromBoxes() async {
    Box<Event> box = Boxes.getEvents();
    return box.values.toList().cast<Event>();
  }

  Future<List<Event>> getHolidaysFromAPI() async {
    List<Holiday> holidays = await _holidayAPI.fetchHolidays();
    String identifier = box.get('holidayIdentifier', defaultValue: 'allStates');
    return holidays
        .where((holiday) => holiday.isValid(identifier))
        .map((holiday) => Event.fromHoliday(holiday))
        .toList();
  }
}

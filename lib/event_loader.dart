import 'package:hive/hive.dart';
import 'package:sloth/holiday_api.dart';
import 'package:sloth/model/event.dart';

import 'boxes.dart';
import 'model/holiday.dart';

class EventLoader {
  static final HolidayAPI _holidayAPI = HolidayAPI();

  Future<List<Event>> loadAll() async => [
        ...await loadFromBoxes(),
        ...await loadHolidaysFromAPI(),
      ];

  Future<List<Event>> loadFromBoxes() async {
    Box<Event> box = Boxes.getEvents();
    return box.values.toList().cast<Event>();
  }

  Future<List<Event>> loadHolidaysFromAPI() async {
    List<Holiday> holidays = await _holidayAPI.fetchHolidays();
    return holidays.map((holiday) => Event.fromHoliday(holiday)).toList();
  }
}

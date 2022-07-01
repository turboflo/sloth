import 'package:sloth/model/holiday.dart';

class HolidayResponse {
  String? status;
  late List<Holiday> holidays;

  HolidayResponse({this.status, required this.holidays});

  HolidayResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    holidays = <Holiday>[];
    if (json['feiertage'] != null) {
      json['feiertage'].forEach((v) {
        holidays.add(Holiday.fromJson(v));
      });
    }
  }
}

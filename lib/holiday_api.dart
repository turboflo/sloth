import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sloth/model/holiday.dart';
import 'package:sloth/model/holiday_response.dart';

class HolidayAPI {
  static const String _uri = 'https://get.api-feiertage.de/';

  Future<List<Holiday>> fetchHolidays() async {
    final response = await http.get(Uri.parse(_uri));

    if (response.statusCode == 200) {
      return HolidayResponse.fromJson(jsonDecode(response.body)).holidays;
    } else {
      return [];
    }
  }
}

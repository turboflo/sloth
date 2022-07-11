import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sloth/service/default_settings.dart';

import '../main.dart';
import '../model/event.dart';

class PdfService {
  Future<void> exportMonth({
    required int month,
    required int year,
    required WidgetRef ref,
  }) async {
    final defaultSettings = DefaultSettings();
    final pdf = pw.Document();
    final List<Event> events = ref
        .read(eventsProvider)
        .events
        .where((event) => event.day.year == year && event.day.month == month)
        .toList();

    var currentDay = DateTime(year, month, 1);
    var maxWeekOfMonth = 0;

    List<List<pw.Column>> weekdayColumns = [[], [], [], [], [], [], []];

    for (var i = 0; i < currentDay.weekday - 1; i++) {
      weekdayColumns[i].add(generateColumn('/'));
    }

    while (currentDay.month == month) {
      final List<Event> currentEvents =
          events.where((event) => event.day.day == currentDay.day).toList();

      if (currentEvents.isNotEmpty) {
        weekdayColumns[currentDay.weekday - 1]
            .add(generateColumn(currentEvents.last.title));
      } else if (defaultSettings.isDayValid(currentDay)) {
        weekdayColumns[currentDay.weekday - 1]
            .add(generateColumn(defaultSettings.eventTitle));
      } else {
        weekdayColumns[currentDay.weekday - 1].add(generateColumn(''));
      }

      maxWeekOfMonth = currentDay.weekOfMonth;
      currentDay = currentDay.add(const Duration(days: 1));
    }

    //
    final headerColumn = pw.TableRow(children: [
      generateColumn('Mo'),
      generateColumn('Di'),
      generateColumn('Mi'),
      generateColumn('Do'),
      generateColumn('Fr'),
      generateColumn('Sa'),
      generateColumn('So'),
    ]);
    //

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text('Arbeitszeiten ($year-$month)'),
                pw.Container(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: List<pw.TableRow>.generate(
                    maxWeekOfMonth + 1,
                    (i) {
                      if (i == 0) {
                        return headerColumn;
                      } else {
                        return pw.TableRow(
                          children: List<pw.Column>.generate(
                            7,
                            (weekday) {
                              try {
                                return weekdayColumns[weekday][i - 1];
                              } catch (e) {
                                return generateColumn('/');
                              }
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    await _download(pdf: pdf, fileName: '$year-$month.pdf');
  }

  Future<void> _download(
      {required Document pdf, required String fileName}) async {
    final bytes = await pdf.save();
    await FileSaver.instance.saveFile(fileName, bytes, '');
  }

  pw.Column generateColumn(String text) => pw.Column(children: [
        pw.Text(text),
      ]);
}

extension DateTimeExtension on DateTime {
  int get weekOfMonth {
    var wom = 0;
    var date = this;

    while (date.month == month) {
      wom++;
      date = date.subtract(const Duration(days: 7));
    }

    return wom;
  }
}

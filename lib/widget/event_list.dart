import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../boxes.dart';
import '../main.dart';
import '../model/event.dart';
import '../service/default_settings.dart';

class EventList extends ConsumerWidget {
  final DateTime day;
  final DefaultSettings defaultSettings = DefaultSettings();
  final boxEvents = Boxes.getEvents();

  EventList({required this.day, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDefault = false;
    var items = [];
    final List<Event> events = ref
        .watch(eventsProvider)
        .events
        .where(
          (event) => DateUtils.dateOnly(day).isAtSameMomentAs(
            DateUtils.dateOnly(event.day),
          ),
        )
        .toList();
    items = events;
    if (events.isEmpty && defaultSettings.isDayValid(day)) {
      isDefault = true;
      items = [defaultSettings.getEvent(day)];
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: Icon(eventIcons[items[index].type]),
          title: Text(items[index].title),
        ),
      ),
    );
  }
}

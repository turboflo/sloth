import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sloth/main.dart';
import 'package:sloth/model/event.dart';

class CalendarField extends ConsumerWidget {
  final DateTime day;
  final DateTime focusedDay;

  const CalendarField({Key? key, required this.day, required this.focusedDay})
      : super(key: key);

  Widget getIndicator(Event event, bool isSelected, ColorScheme colors) =>
      Positioned(
        right: 5,
        bottom: 5,
        child: Row(
          children: [
            Icon(
              eventIcons[event.type],
              color: isSelected
                  ? colors.background
                  : colors.onBackground.withOpacity(0.5),
              size: 12,
            ),
            const SizedBox(width: 5),
            Text(
              event.title,
              style: TextStyle(
                color: isSelected
                    ? colors.background
                    : colors.onBackground.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final now = DateUtils.dateOnly(DateTime.now());
    final isSelected = day.day == focusedDay.day;
    final isInMonth = day.month == focusedDay.month;
    final isToday = DateUtils.dateOnly(day).isAtSameMomentAs(now);

    List<Event> events = ref
        .watch(eventsProvider)
        .events
        .where(
          (event) => DateUtils.dateOnly(day).isAtSameMomentAs(
            DateUtils.dateOnly(event.day),
          ),
        )
        .toList();

    if (!isInMonth) {
      return Center(
          child: Text(
        day.day.toString(),
        style: TextStyle(
          color: colors.onBackground.withOpacity(0.5),
        ),
      ));
    }

    return Card(
      elevation: 1.5,
      color: isSelected ? colors.primary : null,
      child: Stack(
        children: [
          if (isToday)
            Positioned(
              right: 5,
              top: 5,
              child: ClipOval(
                child: Container(
                  height: 5,
                  width: 5,
                  color: isSelected ? colors.background : colors.onBackground,
                ),
              ),
            ),
          Positioned(
            top: 5,
            left: 5,
            child: Text(
              day.day.toString(),
              style: TextStyle(
                color: isSelected ? colors.background : null,
              ),
            ),
          ),
          if (events.isNotEmpty) getIndicator(events.first, isSelected, colors)
        ],
      ),
    );
  }
}
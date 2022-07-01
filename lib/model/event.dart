import 'package:hive/hive.dart';

part 'event.g.dart';

@HiveType(typeId: 0)
class Event extends HiveObject {
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String type;
  @HiveField(2)
  late DateTime day;
}

enum EventType {
  work,
  holiday,
  vacation,
}

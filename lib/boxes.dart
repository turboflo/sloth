import 'package:hive/hive.dart';
import 'package:sloth/model/event.dart';

class Boxes {
  static Box<Event> getEvents() => Hive.box<Event>('events');
}

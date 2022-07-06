import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sloth/boxes.dart';
import 'package:sloth/service/default_settings.dart';
import 'package:sloth/widget/time_range_field.dart';

import '../main.dart';
import '../service/event_loader.dart';
import '../widget/setting_card.dart';

const int leftFlex = 1;
const int rightFlex = 4;

const Map<String, String> stateSettingMap = {
  'none': 'Keine Anzeigen',
  'allStates': 'Bundesweit',
  'bw': 'Baden-Württemberg',
  'by': 'Bayern',
  'be': 'Berlin',
  'bb': 'Brandenburg',
  'hb': 'Bremen',
  'hh': 'Hamburg',
  'he': 'hessen',
  'mv': 'Mecklenburg-Vorpommern',
  'ni': 'Niedersachsen',
  'nw': 'Nordrhein-Westfalen',
  'rp': 'Rheinland-Pfalz',
  'sl': 'Saarland',
  'sn': 'Sachsen',
  'st': 'Sachsen-Anhalt',
  'sh': 'Schleswig-Holstein',
  'th': 'Thüringen',
};

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final boxSettings = Boxes.getSettings();
  final boxEvents = Boxes.getEvents();
  final TextStyle _headerStyle = const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  final items = stateSettingMap.keys
      .map(
        (key) => DropdownMenuItem<String>(
          value: key,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(stateSettingMap[key]!),
          ),
        ),
      )
      .toList();

  @override
  void initState() {
    super.initState();
  }

  Future<void> reloadEvents() async {
    final eventLoader = EventLoader();
    ref.read(eventsProvider.notifier).replaceAll(await eventLoader.getAll());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  Text(
                    'Einstellungen',
                    style: _headerStyle,
                  ),
                  Expanded(child: Container()),
                  IconButton(
                    onPressed: () => showLicensePage(context: context),
                    splashRadius: 20,
                    icon: Icon(
                      Icons.info,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            holidaySettings(),
            const SizedBox(height: 7.5),
            const Divider(),
            const SizedBox(height: 7.5),
            defaultWeekdaySettings(),
            defaultWorktimeSettings(),
            const SizedBox(height: 7.5),
            const Divider(),
            const SizedBox(height: 7.5),
            deleteEventsButton(),
            resetSettingsButton(),
          ],
        ),
      ),
    );
  }

  SettingCard defaultWorktimeSettings() {
    DefaultSettings defaultSettings = DefaultSettings();
    TextEditingController startTimeCon = TextEditingController();
    TextEditingController endTimeCon = TextEditingController();
    startTimeCon.text = defaultSettings.eventTitle.split('-').first;
    endTimeCon.text = defaultSettings.eventTitle.split('-').last;
    return SettingCard(
      title: const Text('Standard Uhrzeit'),
      settingMenu: Flexible(
        child: Row(
          children: [
            Expanded(
              child: TimeRangeField(
                startTimeCon: startTimeCon,
                endTimeCon: endTimeCon,
                onChange: (_) => defaultSettings
                    .setEventTitle('${startTimeCon.text} - ${endTimeCon.text}'),
              ),
            ),
            Expanded(child: Container()),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  Widget deleteEventsButton() {
    return SettingCard(
      title: const Text('Alle Arbeitstage und Urlaub'),
      settingMenu: MaterialButton(
        color: Colors.redAccent,
        child: const Text(
          'Löschen',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          boxEvents.deleteAll(boxEvents.keys);
          reloadEvents();
        },
      ),
    );
  }

  Widget resetSettingsButton() {
    return SettingCard(
      title: const Text('Alle Einstellungen'),
      settingMenu: MaterialButton(
        color: Colors.redAccent,
        child: const Text(
          'Zurücksetzen',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          setState(() {
            boxSettings.deleteAll(boxSettings.keys);
          });
        },
      ),
    );
  }

  Widget defaultWeekdaySettings() {
    DefaultSettings defaultSettings = DefaultSettings();
    List<String> weekdayTitles = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    List<int> validWeekdays = defaultSettings.validWeekdays.cast();

    List<Widget> widgets = [];

    for (var i = 1; i <= weekdayTitles.length; i++) {
      widgets.add(Text(weekdayTitles.elementAt(i - 1)));
      widgets.add(Checkbox(
          value: validWeekdays.contains(i),
          onChanged: (bool? value) {
            setState(() {
              if (value == null) {
                //null
              } else if (value) {
                //true
                validWeekdays.add(i);
              } else {
                //false
                validWeekdays.remove(i);
              }
              defaultSettings.setValidWeekdays(validWeekdays);
            });
          }));
      widgets.add(const SizedBox(width: 10));
    }
    return SettingCard(
      title: const Text('Standard Arbeitstage'),
      settingMenu: Row(
        children: widgets,
      ),
    );
  }

  Widget holidaySettings() {
    String identifier =
        boxSettings.get('holidayIdentifier', defaultValue: 'allStates');

    return SettingCard(
      title: const Text('Feiertage anzeigen'),
      settingMenu: DropdownButton<String>(
        underline: Container(),
        value: identifier,
        items: items,
        onChanged: (String? newValue) {
          boxSettings.put('holidayIdentifier', newValue ?? 'allStates');
          reloadEvents();
          setState(() {
            identifier = newValue!;
          });
        },
      ),
    );
  }
}

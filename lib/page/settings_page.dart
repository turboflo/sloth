import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sloth/service/default_settings.dart';

import '../main.dart';
import '../service/event_loader.dart';

const int leftFlex = 1;
const int rightFlex = 4;

const Map<String, String> stateSettingMap = {
  'none': 'Keine Anzeigen',
  'allStates': 'Alle Bundesländer',
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
  final box = Hive.box('settings');
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

  Future<void> updateEvents() async {
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
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                'Einstellungen',
                style: _headerStyle,
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
            resetButton()
          ],
        ),
      ),
    );
  }

  SettingCard defaultWorktimeSettings() {
    DefaultSettings defaultSettings = DefaultSettings();
    TextEditingController con = TextEditingController();
    con.text = defaultSettings.eventTitle;
    return SettingCard(
      title: const Text('Standard Uhrzeit'),
      settingMenu: Flexible(
        child: TextField(
          controller: con,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              // gapPadding: 5,
              borderSide: BorderSide(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
              ),
            ),
            hintText: '00:00 - 00:00',
          ),
          onChanged: (_) {
            defaultSettings.setEventTitle(con.text);
          },
        ),
      ),
    );
  }

  Widget resetButton() {
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
            box.deleteAll(box.keys);
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
    String identifier = box.get('holidayIdentifier', defaultValue: 'allStates');

    return SettingCard(
      title: const Text('Feiertage anzeigen'),
      settingMenu: DropdownButton<String>(
        underline: Container(),
        value: identifier,
        items: items,
        onChanged: (String? newValue) {
          box.put('holidayIdentifier', newValue ?? 'allStates');
          updateEvents();
          setState(() {
            identifier = newValue!;
          });
        },
      ),
    );
  }
}

class SettingCard extends StatelessWidget {
  final Widget title;
  final Widget settingMenu;

  const SettingCard({
    Key? key,
    required this.title,
    required this.settingMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            title,
            const SizedBox(
              width: 20,
            ),
            settingMenu
          ],
        ),
      ),
    );
  }
}

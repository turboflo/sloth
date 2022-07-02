import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../event_loader.dart';
import '../main.dart';

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
  late String dropdownValue;
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
    String identifier = box.get('holidayIdentifier', defaultValue: 'allStates');
    dropdownValue = identifier;
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
            const SizedBox(height: 25),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const Text('Feiertage anzeigen'),
                    const SizedBox(
                      width: 20,
                    ),
                    DropdownButton<String>(
                      underline: Container(),
                      value: dropdownValue,
                      items: items,
                      onChanged: (String? newValue) {
                        box.put('holidayIdentifier', newValue ?? 'allStates');
                        updateEvents();
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

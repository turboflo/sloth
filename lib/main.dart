import 'dart:convert';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sloth/page/calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:sloth/model/event.dart';
import 'package:sloth/page/export_page.dart';
import 'package:sloth/page/settings_page.dart';

import 'service/event_loader.dart';
import 'widget/sidebar_button.dart';
import 'widget/version_card.dart';

final eventsProvider =
    ChangeNotifierProvider<EventNotifier>((ref) => EventNotifier());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DesktopWindow.setWindowSize(const Size(1000, 620));
  await DesktopWindow.setMinWindowSize(const Size(1000, 620));

  final themeStr = await rootBundle.loadString('assets/theme_light.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  final darkThemeStr = await rootBundle.loadString('assets/theme_dark.json');
  final darkThemeJson = jsonDecode(darkThemeStr);
  final darkTheme = ThemeDecoder.decodeThemeData(darkThemeJson)!;

  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  await Hive.openBox<Event>('events');
  await Hive.openBox('settings');

  initializeDateFormatting().then(
    (_) => runApp(
      ProviderScope(
        child: MyApp(
          theme: theme,
          darkTheme: darkTheme,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  final ThemeData darkTheme;

  const MyApp({Key? key, required this.theme, required this.darkTheme})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sloth',
      theme: theme,
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    const CalendarPage(),
    const ExportPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    Hive.box('settings').deleteFromDisk;
    loadEvents();
    super.initState();
  }

  Future<void> loadEvents() async {
    final eventLoader = EventLoader();
    ref.read(eventsProvider.notifier).addAll(await eventLoader.getAll());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            height: double.infinity,
            // width: double.infinity,
            color: Theme.of(context).colorScheme.background,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  SideBarButton(
                    iconData: Icons.calendar_month,
                    isSelected: _pageIndex == 0,
                    onPressed: () {
                      setState(() => _pageIndex = 0);
                    },
                  ),
                  SideBarButton(
                    iconData: Icons.picture_as_pdf,
                    isSelected: _pageIndex == 1,
                    onPressed: () {
                      setState(() => _pageIndex = 1);
                    },
                  ),
                  Expanded(child: Container()),
                  SideBarButton(
                    iconData: Icons.settings,
                    isSelected: _pageIndex == 2,
                    onPressed: () {
                      setState(() => _pageIndex = 2);
                    },
                  ),
                  const VersionCard(
                    title: 'pre-release',
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: 1,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _pages[_pageIndex],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sloth/event_loader.dart';
import 'package:sloth/widget/custom_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:sloth/model/event.dart';

final eventsProvider =
    ChangeNotifierProvider<EventNotifier>((ref) => EventNotifier());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString('assets/theme_light.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  final darkThemeStr = await rootBundle.loadString('assets/theme_dark.json');
  final darkThemeJson = jsonDecode(darkThemeStr);
  final darkTheme = ThemeDecoder.decodeThemeData(darkThemeJson)!;

  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  await Hive.openBox<Event>('events');

  runApp(
    ProviderScope(
      child: MyApp(
        theme: theme,
        darkTheme: darkTheme,
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
      title: 'Flutter Demo',
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
  bool _pageIsLoading = true;
  int _pageIndex = 0;
  final List<Widget> _pages = [
    const CustomCalendar(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  void initState() {
    loadEvents();
    super.initState();
  }

  Future<void> loadEvents() async {
    final eventLoader = EventLoader();
    ref.read(eventsProvider.notifier).addAll(await eventLoader.loadAll());
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventsProvider).events;
    print(events.where((e) => e.type == EventType.work.name));
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
                    iconData: Icons.event_repeat,
                    isSelected: _pageIndex == 1,
                    onPressed: () {
                      setState(() => _pageIndex = 1);
                    },
                  ),
                  SideBarButton(
                    iconData: Icons.picture_as_pdf,
                    isSelected: _pageIndex == 2,
                    onPressed: () {
                      setState(() => _pageIndex = 2);
                    },
                  ),
                  Expanded(child: Container()),
                  SideBarButton(
                    iconData: Icons.settings,
                    isSelected: _pageIndex == 3,
                    onPressed: () {
                      setState(() => _pageIndex = 3);
                      // EventLoader().loadAll().then((events) {
                      //   print(events);
                      // });
                    },
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

class SideBarButton extends StatelessWidget {
  final Function() onPressed;
  final IconData iconData;
  final bool isSelected;

  const SideBarButton({
    Key? key,
    required this.onPressed,
    required this.iconData,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: isSelected ? colors.primary : null,
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          onPressed: isSelected ? null : onPressed,
          icon: Icon(
            iconData,
            color: isSelected
                ? colors.background
                : colors.onBackground.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}

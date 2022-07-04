import 'package:flutter/material.dart';

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

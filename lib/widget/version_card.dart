import 'package:flutter/material.dart';

class VersionCard extends StatelessWidget {
  final String title;

  const VersionCard({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: colors.onBackground.withOpacity(0.2),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 9,
            color: colors.onBackground.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

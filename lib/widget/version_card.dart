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
    final color = colors.onBackground.withOpacity(0.3);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: color,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 9,
            color: color,
          ),
        ),
      ),
    );
  }
}

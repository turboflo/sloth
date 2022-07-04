import 'package:flutter/material.dart';

class TimeRangeField extends StatelessWidget {
  final TextEditingController startTimeCon;
  final TextEditingController endTimeCon;
  final Function(String)? onChange;

  const TimeRangeField({
    Key? key,
    required this.startTimeCon,
    required this.endTimeCon,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: TextField(
            onChanged: onChange,
            controller: startTimeCon,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: colors.onBackground.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
        const Text(' - '),
        Flexible(
          child: TextField(
            onChanged: onChange,
            controller: endTimeCon,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: colors.onBackground.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class MonthSwitchButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final bool isSelected;
  const MonthSwitchButton({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: colors.primary.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: MaterialButton(
          color: isSelected ? colors.primary : null,
          elevation: 0,
          onPressed: onPressed,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : null,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

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
      elevation: 2,
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

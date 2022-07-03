import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sloth/service/pdf_service.dart';

class ExportPage extends ConsumerWidget {
  const ExportPage({Key? key}) : super(key: key);
  static const List<String> months = [
    'Januar',
    'Februar',
    'März',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Dezember',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 6,
              childAspectRatio: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              children: List<Widget>.generate(
                12,
                ((index) => MonthButton(
                      title: months[index],
                      onPressed: () {},
                    )),
              ),
            ),
          ),
          MaterialButton(
            onPressed: (() =>
                PdfService().exportMonth(month: 6, year: 2022, ref: ref)),
            child: const Text('pdf erstellen'),
          ),
        ],
      ),
    );
  }
}

class MonthButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const MonthButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(4),
      ),
      child: MaterialButton(
        elevation: 0,
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}

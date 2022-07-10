import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sloth/service/pdf_service.dart';

import '../widget/month_switch_btn.dart';

const List<String> months = [
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

class ExportPage extends ConsumerStatefulWidget {
  const ExportPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExportPageState();
}

class _ExportPageState extends ConsumerState<ExportPage> {
  final PdfService pdfService = PdfService();
  late int selectedMonth;
  late ColorScheme colors;
  var exportStatusText = '';

  @override
  void initState() {
    selectedMonth = DateTime.now().month - 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 6,
                  childAspectRatio: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  children: List<Widget>.generate(
                    12,
                    ((index) => MonthSwitchButton(
                          title: months[index],
                          onPressed: () {
                            setState(() {
                              selectedMonth = index;
                            });
                          },
                          isSelected: index == selectedMonth,
                        )),
                  ),
                ),
              ),
            ),
          ),
          // const Divider(),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: Container()),
              getExportButton(),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            exportStatusText,
            style: TextStyle(color: colors.onBackground.withOpacity(0.3)),
          )
        ],
      ),
    );
  }

  MaterialButton getExportButton() {
    return MaterialButton(
      color: colors.primary,
      onPressed: (() async {
        await pdfService.exportMonth(
          month: selectedMonth + 1,
          year: 2022,
          ref: ref,
        );
        setState(() {
          exportStatusText =
              '2022-${selectedMonth + 1}.pdf in Downloads gespeichert';
        });
      }),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              'Als PDF exportieren ',
              style: TextStyle(color: colors.background),
            ),
            Icon(
              Icons.file_download,
              color: colors.background,
            )
          ],
        ),
      ),
    );
  }
}

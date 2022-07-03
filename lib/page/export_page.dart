import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sloth/service/pdf_service.dart';

class ExportPage extends ConsumerWidget {
  const ExportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: MaterialButton(
        onPressed: (() =>
            PdfService().exportMonth(month: 6, year: 2022, ref: ref)),
        child: const Text('pdf erstellen'),
      ),
    );
  }
}

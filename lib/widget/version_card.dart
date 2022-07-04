import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionCard extends StatelessWidget {
  const VersionCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _initialPackageInfo = PackageInfo(
      appName: 'Unknown',
      packageName: 'Unknown',
      version: 'Unknown',
      buildNumber: 'Unknown',
      buildSignature: 'Unknown',
    );
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
        child: FutureBuilder(
          future: PackageInfo.fromPlatform(),
          initialData: _initialPackageInfo,
          builder: (BuildContext context, AsyncSnapshot<PackageInfo> snap) {
            final packageInfo = snap.data!;
            return Text(
              ' v${packageInfo.version} ',
              style: TextStyle(
                fontSize: 9,
                color: colors.onBackground.withOpacity(0.3),
              ),
            );
          },
        ),
      ),
    );
  }
}

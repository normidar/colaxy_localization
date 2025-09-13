import 'dart:io';

import 'package:colaxy_localization/src/locale_unit.dart';

void main() {
  final appsDir = Directory('assets/localizations');
  for (final fse in appsDir.listSync()) {
    // read file as json
    if (fse is File) {
      LocaleUnit(locale: fse.path.split('/').last.split('.').first)
          .fitAllToFastlane();
    }
  }
  print('done');
}

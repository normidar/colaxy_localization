import 'dart:io';

import 'package:colaxy_localization/src/locale_unit.dart';

void main() {
  final appsDir = Directory('assets/localizations');
  for (final fse in appsDir.listSync()) {
    // read file as json
    if (fse is File) {
      final locale = fse.path.split('/').last.split('.').first;
      final lu = LocaleUnit(locale: locale);
      if (locale == 'en-US') {
        lu.isMainLocale = true;
      }
      lu.fitAllToFastlane();
    }
  }
  print('done');
}

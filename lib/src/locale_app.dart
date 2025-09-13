import 'dart:io';

import 'package:colaxy_localization/colaxy_localization.dart';
import 'package:yaml/yaml.dart' show loadYaml;

/// 一個のアプリのローカリゼーション、中に複数のLocaleUnitが存在する可能性がある
class LocaleApp {
  const LocaleApp();

  /// アプリのローカリゼーションのユニットを取得する
  List<LocaleUnit> getLocaleUnits() {
    const androidNameLocalization = AndroidNameLocalization();
    androidNameLocalization.updateManifestAppName();

    final appsDir = Directory('assets/localizations');
    if (!appsDir.existsSync()) {
      throw Exception('Error: ディレクトリが存在しません');
    }

    final localeUnits = <LocaleUnit>[];
    for (final fse in appsDir.listSync()) {
      final locale = fse.path.split('/').last.split('.').first;
      localeUnits.add(LocaleUnit(locale: locale));
    }

    // メインのロケールを設定する
    if (localeUnits.length == 1) {
      localeUnits.first.isMainLocale = true;
    } else {
      final mainLocale = localeUnits.firstWhere((e) => e.locale == 'en-US');
      mainLocale.isMainLocale = true;
    }

    const iosNameLocalization = IOSNameLocalization();
    iosNameLocalization
        .fitAppSupportLocales(localeUnits.map((e) => e.locale).toList());

    return localeUnits;
  }

  String? getMinimumVersion() {
    final pubspecYaml = File('pubspec.yaml');
    if (!pubspecYaml.existsSync()) {
      return null;
    }

    final pubspecYamlContent = pubspecYaml.readAsStringSync();
    final pubspecYamlMap = loadYaml(pubspecYamlContent);
    return pubspecYamlMap['minimum_version'] as String?;
  }

  static List<LocaleApp> getLocaleApps() {
    final appsDir = Directory('words_set/apps');
    if (!appsDir.existsSync()) {
      throw Exception('Error: words_set/appsディレクトリが存在しません');
    }

    final localeApps = <LocaleApp>[];
    for (final fse in appsDir.listSync()) {
      if (fse is Directory) {
        localeApps.add(const LocaleApp());
      }
    }
    return localeApps;
  }
}

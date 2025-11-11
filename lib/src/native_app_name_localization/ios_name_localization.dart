import 'dart:io' show File;

import 'package:xml/xml.dart';

class IOSNameLocalization {
  const IOSNameLocalization();

  static final _iosLocaleMap = {
    'zh-CN': 'zh-Hans',
    'zh-TW': 'zh-Hant',
    'ja-JP': 'ja',
  };

  String get resourceFolder => 'ios/Runner';

  void fitAppSupportLocales(List<String> locales) {
    final infoPlistPath = '$resourceFolder/Info.plist';
    final infoPlist = File(infoPlistPath);

    if (!infoPlist.existsSync()) {
      print('Info.plist file not found at: $infoPlistPath');
      return;
    }

    // InfoPlistのコンテンツを読み込む
    final infoPlistContent = infoPlist.readAsStringSync();

    // XMLとしてパース
    try {
      final document = XmlDocument.parse(infoPlistContent);
      final plist = document.rootElement;
      final dict = plist.findElements('dict').first;

      // CFBundleLocalizationsキーを探す
      final keys = dict.findElements('key').toList();
      var localizationsKeyIndex = -1;

      for (var i = 0; i < keys.length; i++) {
        if (keys[i].innerText == 'CFBundleLocalizations') {
          localizationsKeyIndex = i;
          break;
        }
      }

      // iOSのロケール形式に変換
      final iosLocales = locales
          .map((locale) => _iosLocaleMap[locale] ?? locale)
          .toList()
        ..sort();

      if (localizationsKeyIndex >= 0) {
        // 既存のCFBundleLocalizationsを更新
        final arrayElement = keys[localizationsKeyIndex].nextElementSibling;
        if (arrayElement != null && arrayElement.name.local == 'array') {
          // 既存の配列を削除して新しい配列で置き換える
          arrayElement.children.clear();

          // 各ロケールを配列に追加
          for (final locale in iosLocales) {
            arrayElement.children.add(XmlText('\n\t\t'));
            final stringElement = XmlElement(XmlName('string'));
            stringElement.innerText = locale;
            arrayElement.children.add(stringElement);
          }
          arrayElement.children.add(XmlText('\n\t'));
        }
      } else {
        // CFBundleLocalizationsキーが存在しない場合は追加する
        // 辞書の最後に追加
        dict.children.add(XmlText('\n\t'));

        final keyElement = XmlElement(XmlName('key'));
        keyElement.innerText = 'CFBundleLocalizations';
        dict.children.add(keyElement);

        dict.children.add(XmlText('\n\t'));

        final arrayElement = XmlElement(XmlName('array'));
        for (final locale in iosLocales) {
          arrayElement.children.add(XmlText('\n\t\t'));
          final stringElement = XmlElement(XmlName('string'));
          stringElement.innerText = locale;
          arrayElement.children.add(stringElement);
        }
        arrayElement.children.add(XmlText('\n\t'));

        dict.children.add(arrayElement);
        dict.children.add(XmlText('\n'));
      }

      // 更新されたXMLをファイルに書き込む
      infoPlist.writeAsStringSync(
          '${document.toXmlString(pretty: true, indent: '  ')}\n');
    } catch (e) {
      print('Error parsing or updating Info.plist: $e');
    }
  }

  /// iOSのアプリ名のローカリゼーションファイルを作成する
  void fitLocale({required String appName, String? locale}) {
    if (locale == null) {
      // デフォルトのアプリ名を設定（Info.plistに直接反映）
      updateInfoPlistAppName(appName);
      return;
    }

    final localeFolderName = _iosLocaleMap[locale] ?? locale;
    final localeFolder = '$resourceFolder/$localeFolderName.lproj';
    final localeFile = File('$localeFolder/InfoPlist.strings');

    if (!localeFile.existsSync()) {
      localeFile.createSync(recursive: true);
    }

    // InfoPlist.stringsファイルを作成して書き込む
    final content = '''CFBundleDisplayName = "$appName";
''';
    localeFile.writeAsStringSync(content);
  }

  void updateInfoPlistAppName(String appName) {
    final infoPlistPath = '$resourceFolder/Info.plist';
    final infoPlist = File(infoPlistPath);

    if (!infoPlist.existsSync()) {
      print('Info.plist file not found at: $infoPlistPath');
      return;
    }

    // InfoPlistのコンテンツを読み込む
    final infoPlistContent = infoPlist.readAsStringSync();

    // XMLとしてパース - Info.plistはXML形式
    try {
      final document = XmlDocument.parse(infoPlistContent);
      final plist = document.rootElement;
      final dict = plist.findElements('dict').first;

      // CFBundleDisplayNameキーを探す
      final keys = dict.findElements('key').toList();
      var displayNameKeyIndex = -1;

      for (var i = 0; i < keys.length; i++) {
        if (keys[i].innerText == 'CFBundleDisplayName') {
          displayNameKeyIndex = i;
          break;
        }
      }

      if (displayNameKeyIndex >= 0) {
        // 既存のCFBundleDisplayNameを更新
        // キーの後にある文字列要素を更新
        final stringElement = keys[displayNameKeyIndex].nextElementSibling;
        if (stringElement != null && stringElement.name.local == 'string') {
          stringElement.innerText = appName;
        }
      } else {
        // CFBundleNameの後にCFBundleDisplayNameを追加
        var bundleNameKeyIndex = -1;
        for (var i = 0; i < keys.length; i++) {
          if (keys[i].innerText == 'CFBundleName') {
            bundleNameKeyIndex = i;
            break;
          }
        }

        if (bundleNameKeyIndex >= 0) {
          // CFBundleNameキーの後の文字列要素の後に新しい要素を追加
          final bundleNameStringElement =
              keys[bundleNameKeyIndex].nextElementSibling;
          if (bundleNameStringElement != null) {
            final keyElement = XmlElement(XmlName('key'));
            keyElement.innerText = 'CFBundleDisplayName';

            final stringElement = XmlElement(XmlName('string'));
            stringElement.innerText = appName;

            // CFBundleName文字列の後に追加
            final insertIndex =
                dict.children.indexOf(bundleNameStringElement) + 1;
            dict.children.insert(insertIndex, XmlText('\n\t'));
            dict.children.insert(insertIndex + 1, keyElement);
            dict.children.insert(insertIndex + 2, XmlText('\n\t'));
            dict.children.insert(insertIndex + 3, stringElement);
          }
        }
      }

      // 更新されたXMLをファイルに書き込む
      infoPlist.writeAsStringSync(
          '${document.toXmlString(pretty: true, indent: '  ')}\n');
    } catch (e) {
      print('Error parsing or updating Info.plist: $e');
    }
  }
}

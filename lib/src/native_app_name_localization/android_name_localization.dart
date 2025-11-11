import 'dart:io' show File;

import 'package:xml/xml.dart';

class AndroidNameLocalization {
  const AndroidNameLocalization();

  static final _androidLocaleMap = {
    'zh-CN': 'zh-rCN',
    'zh-TW': 'zh-rTW',
    'ja-JP': 'ja',
    'tr-TR': 'tr',
    'pt-PT': 'pt-rPT',
    'es-ES': 'es-rES',
    'ko-KR': 'ko',
    'vi-VN': 'vi',
    'ru-RU': 'ru',
  };

  String get resFolder => '$srcFolder/res';

  String get srcFolder => 'android/app/src/main';

  /// Androidの名前のローカリゼーションファイルを作成する
  void fitLocale({required String appName, String? locale}) {
    var localeFile = File('$resFolder/values/strings.xml');
    if (locale != null) {
      print('locale: $locale');
      final localeFolderName = _androidLocaleMap[locale]!;
      localeFile = File('$resFolder/values-$localeFolderName/strings.xml');
    }

    if (!localeFile.existsSync()) {
      localeFile.createSync(recursive: true);
    }

    // xmlを作成して書き込む
    final xml = '''
<resources>
    <string name="app_name">$appName</string>
</resources>
''';
    localeFile.writeAsStringSync(xml);
  }

  void updateManifestAppName() {
    final manifestPath = '$srcFolder/AndroidManifest.xml';
    final manifest = File(manifestPath);
    final manifestContent = manifest.readAsStringSync();
    final manifestXml = XmlDocument.parse(manifestContent);

    // コメントを削除
    _removeComments(manifestXml);

    final manifestNode = manifestXml.findElements('manifest').first;
    manifestNode
        .findElements('application')
        .first
        .setAttribute('android:label', '@string/app_name');
    final updatedManifestContent = manifestXml.toXmlString(
      pretty: true,
      indent: '    ',
      indentAttribute: (attribute) =>
          attribute.name.toString() != 'android:name',
    );
    manifest.writeAsStringSync(updatedManifestContent);
  }

  void _removeComments(XmlDocument document) {
    final comments = document.descendants
        .where((node) => node.nodeType == XmlNodeType.COMMENT)
        .toList();
    for (final comment in comments) {
      comment.remove();
    }
  }
}

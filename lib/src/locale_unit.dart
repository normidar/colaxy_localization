import 'dart:convert';
import 'dart:io';

import 'package:colaxy_localization/colaxy_localization.dart';

/// 一個のローカリゼーションのユニット、これは一つのアプリの中にある一つの翻訳を示します。
class LocaleUnit {
  LocaleUnit({
    required this.locale,
  });

  static final iosLocaleMap = {
    'zh-CN': 'zh-Hans',
    'zh-TW': 'zh-Hant',
    'ja-JP': 'ja',
    'en-US': 'en-US',
    'tr-TR': 'tr',
    'pt-PT': 'pt-PT',
    'es-ES': 'es-ES',
  };

  bool isMainLocale = false;

  final String locale;

  late final Map<String, String> _json =
      (jsonDecode(_getJsonFile().readAsStringSync()) as Map<String, dynamic>)
          .cast<String, String>();

  String get metadataDir => 'fastlane/metadata';

  void fitAllToFastlane() {
    _fitAppNameToFastlane();
    _fitDescriptionToFastlane();
    _fitIosSubtitleToFastlane();
    _fitAndroidShortDescriptionToFastlane();
    _fitStoreReleaseNoteToFastlane();
    _fitStoreKeywordsToFastlane();
    _fitStorePromotionalTextToFastlane();
    _fitIosSupportUrlToFastlane();
    _fitIosPrivacyUrlToFastlane();
    _fitAppNameAndroid();
    _fitAppNameIos();
  }

  void _fitAndroidShortDescriptionToFastlane() {
    final shortDescription = _getAndroidShortDescription();
    final fastlaneAndroidShortDescriptionFile =
        File('$metadataDir/android/$locale/short_description.txt');

    fastlaneAndroidShortDescriptionFile.writeAsStringSync(shortDescription);
  }

  void _fitAppNameAndroid() {
    final appName = _getAppName();
    const androidNameLocalization = AndroidNameLocalization();
    if (isMainLocale) {
      androidNameLocalization.fitLocale(appName: appName);
    } else {
      androidNameLocalization.fitLocale(appName: appName, locale: locale);
    }
  }

  void _fitAppNameIos() {
    final appName = _getAppName();
    const iosNameLocalization = IOSNameLocalization();
    if (isMainLocale) {
      iosNameLocalization.fitLocale(appName: appName);
    } else {
      iosNameLocalization.fitLocale(appName: appName, locale: locale);
    }
  }

  void _fitAppNameToFastlane() {
    final appName = _getAppStoreName();

    final fastlaneAndroidAppNameFile =
        File('$metadataDir/android/$locale/title.txt');
    final fastlaneIosAppNameFile =
        File('$metadataDir/${iosLocaleMap[locale]!}/name.txt');

    fastlaneAndroidAppNameFile.createSync(recursive: true);
    fastlaneAndroidAppNameFile.writeAsStringSync(appName);
    fastlaneIosAppNameFile.createSync(recursive: true);
    fastlaneIosAppNameFile.writeAsStringSync(appName);
  }

  void _fitDescriptionToFastlane() {
    final description = _getDescription();
    var androidDescription = description;
    var iosDescription = description;
    final fastlaneAndroidDescriptionFile =
        File('$metadataDir/android/$locale/full_description.txt');
    final fastlaneIosDescriptionFile =
        File('$metadataDir/${iosLocaleMap[locale]!}/description.txt');

    final minimumVersion = const LocaleApp().getMinimumVersion();
    print('minimumVersion: $minimumVersion');

    if (minimumVersion != null) {
      androidDescription =
          '$androidDescription\n\n[Minimum supported app version: $minimumVersion]';
      iosDescription = '$iosDescription\n\n[:mav: $minimumVersion]';
    }

    fastlaneAndroidDescriptionFile.writeAsStringSync(androidDescription);
    fastlaneIosDescriptionFile.writeAsStringSync(iosDescription);
  }

  void _fitIosPrivacyUrlToFastlane() {
    final privacyUrl = _getIosPrivacyUrl();
    final fastlaneIosPrivacyUrlFile =
        File('$metadataDir/${iosLocaleMap[locale]!}/privacy_url.txt');

    fastlaneIosPrivacyUrlFile.writeAsStringSync(privacyUrl);
  }

  void _fitIosSubtitleToFastlane() {
    final subtitle = _getIosSubtitle();
    final fastlaneIosSubtitleFile =
        File('$metadataDir/${iosLocaleMap[locale]!}/subtitle.txt');

    fastlaneIosSubtitleFile.writeAsStringSync(subtitle);
  }

  void _fitIosSupportUrlToFastlane() {
    final supportUrl = _getIosSupportUrl();
    final fastlaneIosSupportUrlFile =
        File('$metadataDir/${iosLocaleMap[locale]!}/support_url.txt');

    fastlaneIosSupportUrlFile.writeAsStringSync(supportUrl);
  }

  void _fitStoreKeywordsToFastlane() {
    final storeKeywords = _getStoreKeywords();
    final fastlaneIosStoreKeywordsFile =
        File('$metadataDir/${iosLocaleMap[locale]!}/keywords.txt');

    fastlaneIosStoreKeywordsFile.writeAsStringSync(storeKeywords);
  }

  void _fitStorePromotionalTextToFastlane() {
    final promotionalText = _getStorePromotionalText();
    final fastlaneIosStorePromotionalTextFile =
        File('$metadataDir/${iosLocaleMap[locale]!}/promotional_text.txt');

    fastlaneIosStorePromotionalTextFile.writeAsStringSync(promotionalText);
  }

  void _fitStoreReleaseNoteToFastlane() {
    final storeReleaseNote = _getStoreReleaseNote();
    final fastlaneAndroidStoreReleaseNoteFile =
        File('$metadataDir/android/$locale/changelogs/default.txt');
    final fastlaneIosStoreReleaseNoteFile =
        File('$metadataDir/${iosLocaleMap[locale]!}/release_notes.txt');

    fastlaneAndroidStoreReleaseNoteFile.writeAsStringSync(storeReleaseNote);
    fastlaneIosStoreReleaseNoteFile.writeAsStringSync(storeReleaseNote);
  }

  String _getAndroidShortDescription() {
    final shortDescription = _json['store_android_short_description']!;
    if (shortDescription.length > 80) {
      throw Exception('$locale short_description is too long');
    }
    return shortDescription;
  }

  /// アプリの名前を取得します、これは30文字以内である必要があります。
  /// iOS、Androidの両方で使用されます。
  String _getAppName() {
    final appName = _json['app_name']!;
    if (appName.length > 30) {
      throw Exception('$locale app_name is too long');
    }
    return appName;
  }

  String _getAppStoreName() {
    final appStoreName = _json['store_app_name']!;
    if (appStoreName.length > 30) {
      throw Exception('$locale store_app_name is too long');
    }
    return appStoreName;
  }

  /// アプリの説明を取得します、これは4000文字以内である必要があります。
  /// iOS、Androidの両方で使用されます。
  String _getDescription() {
    final description = _json['store_description']!;
    if (description.length > 4000) {
      throw Exception('$locale description is too long');
    }
    return description;
  }

  String _getIosPrivacyUrl() {
    final privacyUrl = _json['store_ios_privacy_url']!;
    if (privacyUrl.length > 255) {
      throw Exception('$locale privacy_url is too long');
    }
    return privacyUrl;
  }

  String _getIosSubtitle() {
    final subtitle = _json['store_ios_subtitle']!;
    if (subtitle.length > 30) {
      throw Exception('$locale subtitle is too long');
    }
    return subtitle;
  }

  String _getIosSupportUrl() {
    final supportUrl = _json['store_ios_support_url']!;
    if (supportUrl.length > 255) {
      throw Exception('$locale support_url is too long');
    }
    return supportUrl;
  }

  File _getJsonFile() {
    final file = File('assets/localizations/$locale.json');
    if (!file.existsSync()) {
      throw Exception('$locale json file not found');
    }
    return file;
  }

  /// iOS側のキーワードを取得します、これは100文字以内である必要があります。
  String _getStoreKeywords() {
    final storeKeywords = _json['store_ios_keywords']!;
    if (storeKeywords.length > 100) {
      throw Exception('$locale store_keywords is too long');
    }
    if (storeKeywords.contains('google') ||
        storeKeywords.contains('apple') ||
        storeKeywords.contains('android') ||
        storeKeywords.contains('ios')) {
      throw Exception('$locale store_keywords contains blacklisted words');
    }
    return storeKeywords;
  }

  /// iOS側のプロモーションテキストを取得します、これは170文字以内である必要があります。
  String _getStorePromotionalText() {
    final promotionalText = _json['store_ios_promotional_text']!;
    if (promotionalText.length > 170) {
      throw Exception('$locale store_promotional_text is too long');
    }
    return promotionalText;
  }

  String _getStoreReleaseNote() => _json['store_release_note']!;
}

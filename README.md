# colaxy_localization

[![GitHub](https://img.shields.io/github/license/normidar/colaxy_localization.svg)](https://github.com/normidar/colaxy_localization/blob/main/LICENSE)
[![pub package](https://img.shields.io/pub/v/colaxy_localization.svg)](https://pub.dartlang.org/packages/colaxy_localization)
[![GitHub Stars](https://img.shields.io/github/stars/normidar/colaxy_localization.svg)](https://github.com/normidar/colaxy_localization/stargazers)
[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/normidar2.svg?style=social&label=Follow%20%40normidar2)](https://twitter.com/normidar2)
[![Github-sponsors](https://img.shields.io/badge/sponsor-30363D?logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://github.com/sponsors/normidar)

A comprehensive Flutter/Dart localization tool that automates the generation of app store metadata and native app name localizations for both iOS and Android platforms. Part of the Coin Galaxy (Colaxy) ecosystem.

## Features

- 🌍 **Multi-language Support**: Manages localizations for multiple languages including Chinese (Simplified/Traditional), Japanese, English, Turkish, Portuguese, Spanish, Korean, Vietnamese, and Russian
- 📱 **Native App Name Localization**: Automatically generates localized app names for both iOS (`InfoPlist.strings`) and Android (`strings.xml`)
- 🚀 **Fastlane Integration**: Generates all required metadata files for Fastlane deployment to App Store and Google Play
- ✅ **Validation**: Built-in character limit validation for all metadata fields
- 🔄 **Android Manifest Management**: Automatically updates `AndroidManifest.xml` to use localized app names
- 🍎 **iOS Info.plist Management**: Updates iOS `Info.plist` with supported locales and display names
- 📝 **Store Metadata Generation**: Generates app descriptions, release notes, keywords, promotional text, and more

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  colaxy_localization: ^0.1.0
```

Then run:

```bash
dart pub get
```

## Project Structure

Your Flutter/Dart project should have the following structure:

```
your_project/
├── assets/
│   └── localizations/
│       ├── en-US.json
│       ├── zh-CN.json
│       ├── ja-JP.json
│       └── ... (other locale files)
├── android/
│   └── app/
│       └── src/
│           └── main/
│               ├── AndroidManifest.xml
│               └── res/
│                   ├── values/
│                   │   └── strings.xml
│                   ├── values-zh-rCN/
│                   │   └── strings.xml
│                   └── ... (other locale folders)
├── ios/
│   └── Runner/
│       ├── Info.plist
│       ├── zh-Hans.lproj/
│       │   └── InfoPlist.strings
│       └── ... (other .lproj folders)
└── fastlane/
    └── metadata/
        ├── android/
        │   ├── en-US/
        │   ├── zh-CN/
        │   └── ...
        └── ios/ (or platform-specific)
            ├── en-US/
            ├── zh-Hans/
            └── ...
```

## Localization JSON Format

Each locale file (e.g., `assets/localizations/en-US.json`) should contain the following fields:

```json
{
  "app_name": "MyApp",
  "store_app_name": "MyApp - Subtitle",
  "store_description": "Full description of your app (max 4000 chars)",
  "store_release_note": "What's new in this version",
  "store_android_short_description": "Short desc (max 80 chars)",
  "store_ios_subtitle": "iOS subtitle (max 30 chars)",
  "store_ios_keywords": "keyword1,keyword2,keyword3",
  "store_ios_promotional_text": "Promotional text (max 170 chars)",
  "store_ios_support_url": "https://support.example.com",
  "store_ios_privacy_url": "https://privacy.example.com"
}
```

### Field Specifications

| Field                             | Platform              | Max Length | Description                         |
| --------------------------------- | --------------------- | ---------- | ----------------------------------- |
| `app_name`                        | iOS, Android          | 30         | Native app name displayed on device |
| `store_app_name`                  | App Store, Play Store | 30         | App name in stores                  |
| `store_description`               | iOS, Android          | 4000       | Full app description                |
| `store_release_note`              | iOS, Android          | -          | What's new                          |
| `store_android_short_description` | Android               | 80         | Short description for Play Store    |
| `store_ios_subtitle`              | iOS                   | 30         | App subtitle for App Store          |
| `store_ios_keywords`              | iOS                   | 100        | Comma-separated keywords            |
| `store_ios_promotional_text`      | iOS                   | 170        | Promotional text                    |
| `store_ios_support_url`           | iOS                   | 255        | Support URL                         |
| `store_ios_privacy_url`           | iOS                   | 255        | Privacy policy URL                  |

**Note**: iOS keywords cannot contain blacklisted words: "google", "apple", "android", "ios"

## Usage

### As a Library

```dart
import 'package:colaxy_localization/colaxy_localization.dart';

void main() {
  // Get all locale units from assets/localizations
  final localeApp = LocaleApp();
  final localeUnits = localeApp.getLocaleUnits();

  // Generate all localization files
  for (final unit in localeUnits) {
    unit.fitAllToFastlane();
  }

  print('Localization files generated successfully!');
}
```

### Using the Command-line Tool

Run the generator from your project root:

```bash
dart run colaxy_localization:gen
```

This will:

1. Read all JSON files from `assets/localizations/`
2. Generate Android `strings.xml` files for each locale
3. Generate iOS `InfoPlist.strings` files for each locale
4. Update `AndroidManifest.xml` to reference localized app names
5. Update iOS `Info.plist` with supported locales
6. Generate all Fastlane metadata files

## Supported Locales

### iOS Locale Mapping

| Standard Locale | iOS Locale |
| --------------- | ---------- |
| `zh-CN`         | `zh-Hans`  |
| `zh-TW`         | `zh-Hant`  |
| `ja-JP`         | `ja`       |
| `en-US`         | `en-US`    |
| `tr-TR`         | `tr`       |
| `pt-PT`         | `pt-PT`    |
| `es-ES`         | `es-ES`    |
| `ko-KR`         | `ko`       |
| `vi-VN`         | `vi`       |
| `ru-RU`         | `ru`       |

### Android Locale Mapping

| Standard Locale | Android Locale |
| --------------- | -------------- |
| `zh-CN`         | `zh-rCN`       |
| `zh-TW`         | `zh-rTW`       |
| `ja-JP`         | `ja`           |
| `tr-TR`         | `tr`           |
| `pt-PT`         | `pt-rPT`       |
| `es-ES`         | `es-rES`       |
| `ko-KR`         | `ko`           |
| `vi-VN`         | `vi`           |
| `ru-RU`         | `ru`           |

## Advanced Features

### Minimum Version Support

Add a `minimum_version` field to your `pubspec.yaml`:

```yaml
name: my_app
version: 1.2.0
minimum_version: 1.0.0
```

This will automatically append minimum version information to store descriptions:

- **Android**: `[Minimum supported app version: 1.0.0]`
- **iOS**: `[:mav: 1.0.0]`

### Main Locale Detection

- If only one locale file exists, it's automatically set as the main locale
- If multiple locales exist, `en-US` is used as the main locale
- The main locale updates the default app name in native configuration files

## Generated Files

### Android

- `android/app/src/main/res/values/strings.xml` (default)
- `android/app/src/main/res/values-{locale}/strings.xml` (localized)
- `fastlane/metadata/android/{locale}/title.txt`
- `fastlane/metadata/android/{locale}/full_description.txt`
- `fastlane/metadata/android/{locale}/short_description.txt`
- `fastlane/metadata/android/{locale}/changelogs/default.txt`

### iOS

- `ios/Runner/Info.plist` (updated with supported locales)
- `ios/Runner/{locale}.lproj/InfoPlist.strings`
- `fastlane/metadata/{locale}/name.txt`
- `fastlane/metadata/{locale}/description.txt`
- `fastlane/metadata/{locale}/subtitle.txt`
- `fastlane/metadata/{locale}/keywords.txt`
- `fastlane/metadata/{locale}/promotional_text.txt`
- `fastlane/metadata/{locale}/support_url.txt`
- `fastlane/metadata/{locale}/privacy_url.txt`
- `fastlane/metadata/{locale}/release_notes.txt`

## Example

See the included example in the `bin/gen.dart` file for a complete working implementation.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 🐛 [Report Issues](https://github.com/normidar/colaxy_localization/issues)
- 💬 [Discussions](https://github.com/normidar/colaxy_localization/discussions)
- 💖 [Sponsor the project](https://github.com/sponsors/normidar)
- 🐦 [Follow on Twitter](https://twitter.com/normidar2)

## Related Projects

Part of the Coin Galaxy (Colaxy) ecosystem - check out other Colaxy packages!

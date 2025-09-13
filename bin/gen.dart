import 'dart:convert';
import 'dart:io';

void main() {
  final appsDir = Directory('assets/localizations');
  for (final fse in appsDir.listSync()) {
    // read file as json
    if (fse is File) {
      final json = jsonDecode(fse.readAsStringSync());
      print(json);
    }
  }
  print('done');
}

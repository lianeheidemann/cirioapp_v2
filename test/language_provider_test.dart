import 'package:cirio_app/core/localization/app_language.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('alterna para inglês e restaura o idioma salvo', () async {
    final language = await LanguageProvider.load();

    expect(language.locale.languageCode, 'pt');

    await language.toggleLanguage();

    expect(language.locale.languageCode, 'en');

    final restored = await LanguageProvider.load();
    expect(restored.locale.languageCode, 'en');
  });
}

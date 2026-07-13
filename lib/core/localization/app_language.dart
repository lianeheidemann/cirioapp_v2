import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const _storageKey = 'app_language';
  final SharedPreferences _preferences;
  Locale _locale;

  LanguageProvider._(this._preferences, this._locale);

  static Future<LanguageProvider> load() async {
    final preferences = await SharedPreferences.getInstance();
    final code = preferences.getString(_storageKey) ?? 'pt';
    return LanguageProvider._(preferences, Locale(code == 'en' ? 'en' : 'pt'));
  }

  Locale get locale => _locale;
  bool get isEnglish => _locale.languageCode == 'en';

  Future<void> toggleLanguage() async {
    _locale = Locale(isEnglish ? 'pt' : 'en');
    await _preferences.setString(_storageKey, _locale.languageCode);
    notifyListeners();
  }
}

String tr(BuildContext context, String portuguese, String english) {
  try {
    final language = Provider.of<LanguageProvider>(context, listen: false);
    return language.isEnglish ? english : portuguese;
  } catch (_) {
    return portuguese;
  }
}

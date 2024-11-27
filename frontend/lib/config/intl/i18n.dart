import 'dart:convert';
import 'package:flutter/services.dart';

class AppLocalizations {
  final String locale;

  AppLocalizations(this.locale);

  static Map<String, String>? _localizedStrings;

  Future<void> load() async {
    final jsonString = await rootBundle.loadString('assets/i18n/$locale.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    return _localizedStrings![key] ?? key;
  }
}

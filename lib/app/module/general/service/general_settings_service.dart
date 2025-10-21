import 'package:flutter/src/material/app.dart';
import 'package:intl/intl.dart';

import '../../../data/repository/general_setting_repository.dart';

class GeneralSettingsService {

  final repo = GeneralSettingRepository();

  // Static data
  final List<Map<String, String>> currencies = const [
    {'code': 'USD', 'symbol': '\$'},
    {'code': 'INR', 'symbol': '₹'},
    {'code': 'EUR', 'symbol': '€'},
    {'code': 'GBP', 'symbol': '£'},
    {'code': 'JPY', 'symbol': '¥'},
    {'code': 'AUD', 'symbol': 'A\$'},
  ];

  final List<String> dateFormats = const [
    'dd/MM/yyyy',
    'MM/dd/yyyy',
    'yyyy-MM-dd',
    'd MMM yyyy',
  ];

  final List<Map<String, String>> languages = const [
    {'english': 'English', 'native': 'English'},
    {'english': 'French', 'native': 'Français'},
    { 'english': 'German', 'native': 'Deutsch'},
    {'english': 'Spanish', 'native': 'Español'},
    {'english': 'Italian', 'native': 'Italiano'},
    {'english': 'Japanese', 'native': '日本語'},
    {'english': 'Chinese', 'native': '中文'},
    {'english': 'Hindi', 'native': 'हिन्दी'},
    {'english': 'Arabic', 'native': 'العربية'},

  ];

  final List<String> firstDays = const [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  // Utilities
  String formatDate(String fmt) {
    final d = DateTime(2025, 10, 20);
    try {
      return DateFormat(fmt).format(d);
    } catch (_) {
      return DateFormat('dd/MM/yyyy').format(d);
    }
  }

  String formatAmount(String symbol, int decimalPlaces) {
    const double value = 12345.678;
    final rounded = value.toStringAsFixed(decimalPlaces);
    return '$symbol $rounded';
  }

  Future<Map<String, String>> loadSettings() async {
    await repo.initDefaultSettings();
    return await repo.getAllSettings();
  }

  void saveCurrency(String currency, String currencySymbol) {
    repo.setSetting('currency', currency);
    repo.setSetting('currencySymbol', currencySymbol);
  }

  void saveDateFormat(String dateFormat) {
    repo.setSetting('dateFormat', dateFormat);
  }

  void saveDecimalPlaces(int decimalPlaces) {
    repo.setSetting('decimalPlaces', decimalPlaces.toString());
  }

  void saveFirstDay(String firstDay) {
    repo.setSetting('firstDay', firstDay);
  }

  void saveLanguage(String language, String languageDisplay) {
    print(language );
    print(languageDisplay);
    repo.setSetting('language', language);
    repo.setSetting('languageDisplay', languageDisplay);
  }

  void saveThemeMode(ThemeMode themeMode) {
    repo.setSetting('themeMode', themeMode.name);
  }
}

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../service/general_settings_service.dart';

class GeneralSettingsController extends GetxController {

  final _service = GeneralSettingsService();

  // Reactive state variables
  var currency = 'IND'.obs;
  var currencySymbol = '\$'.obs;
  var dateFormat = 'dd/MM/yyyy'.obs;
  var decimalPlaces = 2.obs;
  var firstDay = 'Monday'.obs;
  var language = 'English'.obs;
  var languageDisplay = "English".obs;
  var themeMode = ThemeMode.system.obs;

  // Getters
  List<Map<String, String>> get currencies => _service.currencies;
  List<String> get dateFormats => _service.dateFormats;
  List<Map<String, String>> get languages => _service.languages;
  List<String> get firstDays => _service.firstDays;

  String get formattedDate => _service.formatDate(dateFormat.value);
  String get formattedAmount =>
      _service.formatAmount(currencySymbol.value, decimalPlaces.value);

  // Update methods (optional if using workers)
  void updateCurrency(String code, String symbol) {
    currency.value = code;
    currencySymbol.value = symbol;
  }

  void updateDateFormat(String fmt) => dateFormat.value = fmt;
  void updateLanguage(String lang) => language.value = lang;
  void updateFirstDay(String day) => firstDay.value = day;
  void updateDecimalPlaces(int v) => decimalPlaces.value = v;
  void updateThemeMode(ThemeMode mode) => themeMode.value = mode;

  @override
  Future<void> onInit() async {
    super.onInit();

    final settings = await _service.loadSettings();

    print(settings);

    currency.value = settings['currency']!;
    currencySymbol.value = settings['currencySymbol']!;
    dateFormat.value = settings['dateFormat']!;
    decimalPlaces.value = int.parse(settings['decimalPlaces']!);
    firstDay.value = settings['firstDay']!;
    language.value = settings['language']!;
    languageDisplay.value = settings['languageDisplay']!;
    themeMode.value = ThemeMode.values.firstWhere(
      (mode) => mode.name == settings['themeMode'],
      orElse: () => ThemeMode.system);

    // Track changes for each observable and call DB update
    ever(currency, (_) => _saveCurrency());
    ever(currencySymbol, (_) => _saveCurrency());
    ever(dateFormat, (_) => _saveDateFormat());
    ever(decimalPlaces, (_) => _saveDecimalPlaces());
    ever(firstDay, (_) => _saveFirstDay());
    ever(language, (_) => _saveLanguage());
    ever(themeMode, (_) => _saveThemeMode());
  }

  // Private methods to update DB
  void _saveCurrency() {
    _service.saveCurrency(currency.value, currencySymbol.value);
  }

  void _saveDateFormat() {
    _service.saveDateFormat(dateFormat.value);
  }

  void _saveDecimalPlaces() {
    _service.saveDecimalPlaces(decimalPlaces.value);
  }

  void _saveFirstDay() {
    _service.saveFirstDay(firstDay.value);
  }

  void _saveLanguage() {
    _service.saveLanguage(language.value, languageDisplay.value);
  }

  void _saveThemeMode() {
    _service.saveThemeMode(themeMode.value);
  }
}

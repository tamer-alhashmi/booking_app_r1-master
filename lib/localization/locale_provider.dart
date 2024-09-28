// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:get_storage/get_storage.dart';
//
//
// class LocaleProvider with ChangeNotifier {
//   Locale _locale = const Locale('en');
//
//   Locale get locale => _locale;
//
//   void setLocale(Locale locale) {
//     if (!['en', 'es'].contains(locale.languageCode)) return;
//     _locale = locale;
//     notifyListeners();
//
//     // Persist the locale
//     final box = GetStorage();
//     box.write('locale', locale.languageCode);
//   }
//
//   // Retrieve the persisted locale
//   void loadLocale() {
//     final box = GetStorage();
//     String? localeCode = box.read('locale');
//     if (localeCode != null) {
//       _locale = Locale(localeCode);
//     }
//   }
// }
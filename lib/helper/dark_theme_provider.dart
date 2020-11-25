import 'package:flutter/material.dart';
import '../helper/shared_pref.dart';
import '../helper/shared_pref.dart';

class DarkThemeProvider with ChangeNotifier {
  SharedPref darkThemePreference = SharedPref();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}
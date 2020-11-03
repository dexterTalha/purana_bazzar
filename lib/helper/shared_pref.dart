import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  SharedPreferences pref;

  static const THEME_STATUS = "THEMESTATUS";

  Future<bool> isOld() async {
    pref = await SharedPreferences.getInstance();
    return pref.getBool("isold") ?? false;
  }

  Future<bool> setOld()  async {
    pref = await SharedPreferences.getInstance();
    return pref.setBool("isold", true) ?? false;
  }

  setDarkTheme(bool value) async {
    pref = await SharedPreferences.getInstance();
    pref.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    pref = await SharedPreferences.getInstance();
    return pref.getBool(THEME_STATUS) ?? false;
  }

}
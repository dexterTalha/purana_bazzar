import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  SharedPreferences pref;

  Future<bool> isOld() async {
    pref = await SharedPreferences.getInstance();
    return pref.getBool("isold") ?? false;
  }

  Future<bool> setOld()  async {
    pref = await SharedPreferences.getInstance();
    return pref.setBool("isold", true) ?? false;
  }

}
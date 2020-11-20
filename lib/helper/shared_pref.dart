import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  SharedPreferences pref;

  static const THEME_STATUS = "THEMESTATUS";
  //location
  static const String STREET = "street";
  static const String PIN = "pincode";
  static const String AREA = "area";
  static const String CITY = "city";
  static const String STATE = "state";
  static const String LATLNG = "latlng";
  static const String LOC = "islocation";

  //login
  static const String KEY_EMAIL = "email";
  static const String KEY_NAME = "name";
  static const String KEY_MOBILE = "mobile";
  static const String KEY_THEME = "theme";
  static const String KEY_ISLOGIN = "islogin";
  static const String KEY_UID = "uid";

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
  createSession(uid, name, email, mobile) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(SharedPref.KEY_UID, uid);
    pref.setString(SharedPref.KEY_NAME, name);
    pref.setString(SharedPref.KEY_EMAIL, email);
    pref.setString(SharedPref.KEY_MOBILE, mobile);
    pref.setBool(SharedPref.KEY_ISLOGIN, true);

  }

  logoutUser() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(SharedPref.KEY_ISLOGIN, false);

  }

  Future<bool> isLoggedIn() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get(SharedPref.KEY_ISLOGIN) ?? false;
  }
  Future<bool> isLocation() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get(SharedPref.LOC) ?? false;
  }

  Future<LatLng> getLocationData() async{
    LatLng ll;
    SharedPreferences pref = await SharedPreferences.getInstance();
    final data = pref.getString(SharedPref.LATLNG).split(",");
    ll = LatLng(double.parse(data[0]), double.parse(data[1]));
    return ll;
  }

  createLocationData(double lat, double lng, {bool isAllowed = false}) async{
    bool b = await isLocation();
    if(!b || isAllowed) {
      String street, area, pincode, city, state;
      final coordinates = Coordinates(lat, lng);
      var address = await Geocoder.local.findAddressesFromCoordinates(
          coordinates);
      street = address.first.featureName;
      area = address.first.subLocality;
      pincode = address.first.postalCode;
      city = address.first.subAdminArea;
      state = address.first.adminArea;
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString(SharedPref.STREET, street);
      await pref.setString(SharedPref.STATE, state);
      await pref.setString(SharedPref.CITY, city);
      await pref.setString(SharedPref.AREA, area);
      await pref.setString(SharedPref.PIN, pincode);
      await pref.setBool(SharedPref.LOC, true);
      await pref.setString(SharedPref.LATLNG, "$lat,$lng");
    }
  }

}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color mPrimaryColor = const Color(0xff6A92C8);
final Color mPrimaryDarkColor = const Color(0xff647CA3);
final Color googleTextColor = const Color(0xff717171);
final String baseUrl = "http://pb.loftyinterior.com/new_api/";

final TextStyle splashTextStyle22 = GoogleFonts.mavenPro(
  color: mPrimaryDarkColor,
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

final TextStyle googleBtnTextStyle = GoogleFonts.mavenPro(
  color: googleTextColor,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

Map<int, Color> color = {
  50: Color(0x44647CA3),
  100: Color(0x55647CA3),
  200: Color(0x66647CA3),
  300: Color(0x77647CA3),
  400: Color(0x88647CA3),
  500: Color(0x99647CA3),
  600: Color(0xAA647CA3),
  700: Color(0xCC647CA3),
  800: Color(0xDD647CA3),
  900: Color(0xff647CA3),
};

ThemeData themeData(bool isDarkTheme, BuildContext context) {
  return ThemeData(
    primarySwatch: MaterialColor(0xff6A92C8, color),
    primaryColor: isDarkTheme ? Colors.black : mPrimaryColor,
    backgroundColor: isDarkTheme ? Colors.black : Colors.white,
    indicatorColor: isDarkTheme ? Colors.black : Colors.white,
    buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
    hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
    highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
    hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
    focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
    disabledColor: Colors.grey,
    textTheme: TextTheme(),
    textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
    cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
    canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
    brightness: isDarkTheme ? Brightness.dark : Brightness.light,
    buttonTheme: Theme.of(context).buttonTheme.copyWith(
        colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
    ),
  );
}

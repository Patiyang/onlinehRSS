import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rssadmin/helpers&Widgets/helpers/styling.dart';
class ThemeModel {
  static String? _fontFamily = 'Manrope';
  String ?get fontFamily => _fontFamily;


   set myValue(String value) {
    _fontFamily = value;
  }

  final lightMode = ThemeData(
    primaryColor:primaryColor,
    //accentColor: primaryColor,
    iconTheme: IconThemeData(color: Colors.grey[900]),
    fontFamily: _fontFamily,
    scaffoldBackgroundColor: Colors.grey[100],
    brightness: Brightness.light,
    primaryColorDark: Colors.grey[800],
    primaryColorLight: Colors.white,
    secondaryHeaderColor: Colors.grey[600],
    shadowColor: Colors.grey[200],
    backgroundColor: Colors.white,
    appBarTheme: AppBarTheme(centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      color: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.grey[900],
      ),
      actionsIconTheme: IconThemeData(color: Colors.grey[900]),
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.6,
        wordSpacing: 1,
        color: Colors.grey[900],
      ),
    ),
    textTheme: TextTheme(
      subtitle1: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.grey[900]),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[500],
    ),
  );

  final darkMode = ThemeData(
      primaryColor: primaryColor,
      //accentColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: Color(0xff303030),
      brightness: Brightness.dark,
      primaryColorDark: Colors.grey[300],
      primaryColorLight: Colors.grey[800],
      secondaryHeaderColor: Colors.grey[400],
      shadowColor: Color(0xff282828),
      backgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        color: Colors.grey[900],
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actionsIconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 18,
          letterSpacing: -0.6,
          wordSpacing: 1,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        subtitle1: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],
      ));
}
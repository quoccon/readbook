import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier{
  bool _isDark = false;
  bool get isDark => _isDark;
  //Dark Theme
  final themeDark = ThemeData(
    primaryColor: Colors.black12,
    brightness: Brightness.dark,
    primaryColorDark: Colors.black12
  );
  //Light theme
  final themeLight = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    primaryColorLight: Colors.white
  );
  //dark toggle
  changeTheme(){
    _isDark = !_isDark;
    notifyListeners();
  }
  //init method of provider
  init(){
    notifyListeners();
  }
}
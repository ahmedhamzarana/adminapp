import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _darkModeEnabled = false;
  bool _notificationsEnabled = true;

  // GETTERS
  bool get darkModeEnabled => _darkModeEnabled;
  bool get notificationsEnabled => _notificationsEnabled;

  ThemeMode get themeMode =>
      _darkModeEnabled ? ThemeMode.dark : ThemeMode.light;

  // METHODS
  void toggleDarkMode(bool value) {
    _darkModeEnabled = value;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }
}

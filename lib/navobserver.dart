import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyNavigatorObserver extends NavigatorObserver {
  String _lastPage;

  void _loadLastPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lastPage = prefs.getString('lastPage');
  }

  void _saveLastPage(String page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPage', page);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (_lastPage != null) {
      // Si hay una página guardada, busca la página correspondiente en el stack de rutas
      NavigatorState navigator = route.navigator;
      navigator.popUntil((r) => r.settings.name == _lastPage);
      // Agrega la página guardada como la nueva página actual
      navigator.pushNamedAndRemoveUntil(_lastPage, (r) => false);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    // Guarda la página actual cuando se realiza un pop en el stack de rutas
    _saveLastPage(route.settings.name ?? '');
  }
}

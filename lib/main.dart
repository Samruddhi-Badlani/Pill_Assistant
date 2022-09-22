// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pill_assistant/pages/home-page.dart';
import 'package:pill_assistant/pages/login.dart';
import 'package:pill_assistant/pages/med-form.dart';
import 'package:pill_assistant/pages/myMeds.dart';
import 'package:pill_assistant/pages/myReminders.dart';
import 'package:pill_assistant/pages/register.dart';
import 'package:pill_assistant/pages/reminder-form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pill_assistant/pages/profile.dart';
import 'package:pill_assistant/pages/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool checkLogin = prefs.containsKey('authToken');
  runApp(MaterialApp(
    initialRoute: checkLogin ? 'home' : 'login',
    routes: {
      'login': (context) => Login(),
      'register': (context) => Register(),
      'home': (context) => MyHomePage(),
      'myMeds': (context) => MyMeds(),
      'myReminders': (context) => MyReminders(),
      'addMedicine': (context) => FormApp(),
      'addReminder': (context) => ReminderFormApp(),
      'profile' : (context) => SettingsUI(),
      'settings' : (context) => Settings()
    },
  ));
}

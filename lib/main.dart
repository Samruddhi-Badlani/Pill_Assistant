// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pill_assistant/pages/edit-med-form.dart';
import 'package:pill_assistant/pages/generateQR.dart';
import 'package:pill_assistant/pages/home-page.dart';
import 'package:pill_assistant/pages/login.dart';
import 'package:pill_assistant/pages/med-form.dart';
import 'package:pill_assistant/pages/myMeds.dart';
import 'package:pill_assistant/pages/myReminders.dart';
import 'package:pill_assistant/pages/register.dart';
import 'package:pill_assistant/pages/reminder-form.dart';
import 'package:pill_assistant/pages/scanQR.dart';
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
      'addMedicine': (context) => FormPage(title: 'Add Medicine Page'),
      'addReminder': (context) => ReminderFormPage(title: 'Add Reminder Page'),
      'profile': (context) => EditProfilePage(),
      'settings': (context) => SettingsScreen(),
      'generateQR': (context) => Generate(),
      'scanQR': (context) => Scanner()
    },
  ));
}

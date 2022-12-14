// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pill_assistant/pages/caretakerHome.dart';
import 'package:pill_assistant/pages/caretakerPatient.dart';
import 'package:pill_assistant/pages/edit-med-form.dart';
import 'package:pill_assistant/pages/summary.dart';
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
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(null, [
    // notification icon
    NotificationChannel(
      channelGroupKey: 'basic_test',
      channelKey: 'basic',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for basic tests',
      channelShowBadge: true,
      importance: NotificationImportance.High,
      enableVibration: true,
    ),
  ]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool checkLogin = prefs.containsKey('authToken');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
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
      'scanQR': (context) => Scanner(),
      'caretakerHome': (context) => CaretakerHome(),
      'summary': (context) => Summary(),
    },
  ));
}

// ignore_for_file: prefer_const_constructors

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:pill_assistant/pages/caretakerHome.dart';
import 'package:pill_assistant/pages/caretakerPatient.dart';
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
import 'package:workmanager/workmanager.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

var subscribedActionStream;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool checkLogin = prefs.containsKey('authToken');

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

  Workmanager().initialize(

      // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: true);
// Periodic task registration
  Workmanager().registerPeriodicTask(
    "2",

    //This is the value that will be
    // returned in the callbackDispatcher
    "simplePeriodicTask",

    // When no frequency is provided
    // the default 15 minutes is set.
    // Minimum frequency is 15 min.
    // Android will automatically change
    // your frequency to 15 min
    // if you have configured a lower frequency.
    frequency: Duration(minutes: 15),
  );

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
      'scanQR': (context) => Scanner(),
      'caretakerHome': (context) => CaretakerHome(),
    },
  ));
}

void callbackDispatcher() async {
  await Future.delayed(Duration(minutes: 1));
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  print("call back dispatcher called  ");

  Workmanager().executeTask((task, inputData) async {
    subscribedActionStream = false;

    var myFetchedMedicine = [];

    if (prefs.containsKey('userid') == true) {
      final userId = prefs.get('userid').toString();

      final queryParameters = {'type': 'user'};

      var uri = Uri.https('pill-management-backend.herokuapp.com',
          "/mobile-app-ws/users/${userId}/medicine", queryParameters);

      final http.Response response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': prefs.get('authToken').toString(),
          'userid': userId
        },
      );

      //  print(response.body);
      // print(response.statusCode);
      // print(response.headers);

      var myObj = json.decode(response.body);

      for (var item in myObj) {
        myFetchedMedicine.add(item);
      }

      print(myFetchedMedicine);

      DateTime now = DateTime.now();
      DateTime next;

      if (now.minute <= 44) {
        next =
            DateTime(now.year, now.month, now.day, now.hour, now.minute + 15);
      } else {
        next = DateTime(
            now.year, now.month, now.day, now.hour + 1, (now.minute + 15) % 60);
      }

      print(now.toString());
      print(next.toString());

      print("Difference is " + next.difference(now).inHours.toString());

      while (next.difference(now).inMinutes != 0) {
        for (var medicine in myFetchedMedicine) {
          for (var time in medicine["dosages"]["dosageContextList"]) {
            var hour, minute, title, skipUi;
            hour = int.parse(time["dosageTime"].split(":")[0]);
            // print(hour);
            minute = int.parse(time["dosageTime"].split(":")[1]);
            // print(minute);

            // print("Current hour and min is ");
            // print(now.hour);
            // print(now.minute);

            // print("Medicine dosage");
            //print(hour);
            // print(minute);

            if (now.hour == hour && now.minute == minute) {
              print("Hello");
              AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    //simgple notification
                    id: medicine["id"],
                    channelKey: 'basic', //set configuration wuth key "basic"
                    title: 'Pill Assistant',
                    body: 'Have you taken medicine ' + medicine["name"],
                    payload: {"name": "FlutterCampus"},
                    autoDismissible: false,
                  ),
                  actionButtons: [
                    NotificationActionButton(
                      key: "yes",
                      label: "Yes",
                    ),
                    NotificationActionButton(
                      key: "no",
                      label: "No",
                    )
                  ]);

              await Future.delayed(Duration(minutes: 1));
            }
          }
        }

        now = DateTime.now();
        // print(next.toString());
        // print(now.toString());

        /*

      if (next.difference(now).inMinutes % 2 == 0) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
              //simgple notification
              id: 123,
              channelKey: 'basic', //set configuration wuth key "basic"
              title: 'Pill Assistant',
              body: 'Have you taken your medicine?',
              payload: {"name": "FlutterCampus"},
              autoDismissible: false,
            ),
            actionButtons: [
              NotificationActionButton(
                key: "yes",
                label: "Yes",
              ),
              NotificationActionButton(
                key: "no",
                label: "No",
              )
            ]);

        await Future.delayed(Duration(minutes: 1));
      }

      */

      }
    }

    return Future.value(true);
  });
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pill_assistant/pages/home-page.dart';
import 'package:pill_assistant/pages/login.dart';
import 'package:pill_assistant/pages/med-form.dart';
import 'package:pill_assistant/pages/myMeds.dart';
import 'package:pill_assistant/pages/register.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: 'login',
    routes: {
      'login': (context) => Login(),
      'register': (context) => Register(),
      'home': (context) => MyHomePage(),
      'myMeds': (context) => MyMeds(),
      'addMedicine': (context) => FormApp()
    },
  ));
}

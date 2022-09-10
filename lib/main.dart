import 'package:flutter/material.dart';
import 'package:pill_assistant/pages/login.dart';
import 'package:pill_assistant/pages/register.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: 'login',
    routes: {
      'login': (context) => Login(),
      'register': (context) => Register()
    },
  ));
}

import 'package:flutter/material.dart';
import 'package:pill_assistant/pages/buildMedicineTable.dart';
import 'package:pill_assistant/pages/buildReminderTable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyReminders extends StatefulWidget {
  const MyReminders({super.key});

  @override
  State<MyReminders> createState() => _MyRemindersState();
}

class _MyRemindersState extends State<MyReminders> {
  final columns = ['Name', 'Dosage', 'Total'];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('authToken')) {
      Navigator.pushNamed(context, 'login');
    } else {
      print(prefs.get('authToken'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Pill Assistant'),
          ),
          body: const ReminderTable()),
    );
  }
}

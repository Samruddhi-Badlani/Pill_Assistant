import 'package:flutter/material.dart';
import 'package:pill_assistant/pages/buildMedicineTable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMeds extends StatefulWidget {
  const MyMeds({super.key});

  @override
  State<MyMeds> createState() => _MyMedsState();
}

class _MyMedsState extends State<MyMeds> {
  final columns = ['Name', 'Dosage', 'Total'];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('authToken')) {
      Navigator.pushNamed(context, '/login');
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
          body: const MedicineTable()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pill_assistant/pages/buildMedForCaretaker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientsMedicine extends StatefulWidget {
  final myPatient;
  const PatientsMedicine({super.key, this.myPatient});

  @override
  State<PatientsMedicine> createState() =>
      _PatientsMedicineState(myPatient: myPatient);
}

class _PatientsMedicineState extends State<PatientsMedicine> {
  final myPatient;
  _PatientsMedicineState({required this.myPatient});

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
    return Scaffold(
        appBar: AppBar(
          title: Text('Pill Assistant'),
        ),
        body: MedTableCaretaker(
          myPatient: myPatient,
        ));
  }
}

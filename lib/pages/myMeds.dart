import 'package:flutter/material.dart';
import 'package:pill_assistant/pages/buildMedicineTable.dart';

class MyMeds extends StatefulWidget {
  const MyMeds({super.key});

  @override
  State<MyMeds> createState() => _MyMedsState();
}

class _MyMedsState extends State<MyMeds> {
  final columns = ['Name', 'Dosage', 'Total'];
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

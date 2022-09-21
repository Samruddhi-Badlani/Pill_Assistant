// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pill_assistant/model/medicine.dart';
import 'package:pill_assistant/data/medicineData.dart';

class MedicineTable extends StatefulWidget {
  const MedicineTable({super.key});

  @override
  State<MedicineTable> createState() => _MedicineTableState();
}

class _MedicineTableState extends State<MedicineTable> {
  final columns = ['Name', 'Dosage'];
  List<DataRow> list = [];
  List<Medicine> medicines = List.of(allMedicines);

  @override
  Widget build(BuildContext context) {
    medicines.forEach((Medicine m) => {
          log(m.name),
          list.add(DataRow(cells: [
            DataCell(Text(m.name)),
            DataCell(TextButton(
              onPressed: () {
                m.dosages.forEach((element) {
                  log("Hello pressed");
                  log(element.time.toString());
                  log(element.number.toString());
                });
              },
              child: Text('View Dosage'),
            ))
          ])),
          m.dosages.forEach((element) {
            log(element.time.toString());
            log(element.number.toString());
          })
        });

    return Container(
      child: DataTable(
        columns: [
          DataColumn(
              label: Text('Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Action',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
        ],
        rows: list,
      ),
    );
  }
}

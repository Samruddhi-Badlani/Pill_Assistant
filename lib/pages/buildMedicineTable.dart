// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pill_assistant/model/medicine.dart';
import 'package:pill_assistant/data/medicineData.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    medicines.forEach((Medicine m) => {
          log(m.name),
          list.add(DataRow(cells: [
            DataCell(Text(m.name)),
            DataCell(Row(
              children: [
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog(context, m),
                    );
                    m.dosages.forEach((element) {
                      log("Hello pressed");
                      log(element.time.toString());
                      log(element.number.toString());
                    });
                  },
                  child: Text('View Information'),
                ),
                Icon(Icons.edit),
                Icon(Icons.delete)
              ],
            ))
          ])),
          m.dosages.forEach((element) {
            log(element.time.toString());
            log(element.number.toString());
          })
        });

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "My Medicines",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            DataTable(
              columns: [
                DataColumn(
                    label: Text('Name',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Action',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)))
              ],
              rows: list,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'addMedicine');
                },
                child: Text('Add medicine'))
          ],
        ),
      ),
    );
  }
}

Widget _buildPopupDialog(BuildContext context, Medicine medicine) {
  List<Widget> list = [];

  list.add(Text('Available Count : ' + medicine.availableCounts.toString()));
  list.add(Text('Manufacture : ' +
      medicine.manufactureDate.day.toString() +
      '/' +
      medicine.manufactureDate.month.toString() +
      '/' +
      medicine.manufactureDate.year.toString()));
  list.add(Text('Expiry : ' +
      medicine.expiryDate.day.toString() +
      '/' +
      medicine.expiryDate.month.toString() +
      '/' +
      medicine.expiryDate.year.toString()));
  list.add(Text('Available : ' + medicine.availableCounts.toString()));

  return new AlertDialog(
    title: Text(medicine.name),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    ),
    actions: <Widget>[
      new TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Close'),
      ),
    ],
  );
}

// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pill_assistant/model/medicine.dart';
import 'package:pill_assistant/data/medicineData.dart';
import 'package:pill_assistant/pages/addMedicineByCaretaker.dart';
import 'package:pill_assistant/pages/edit-med-form.dart';
import 'package:pill_assistant/pages/editMedicineByCaretaker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedTableCaretaker extends StatefulWidget {
  final myPatient;
  const MedTableCaretaker({super.key, this.myPatient});

  @override
  State<MedTableCaretaker> createState() =>
      _MedTableCaretakerState(myPatient: myPatient);
}

class _MedTableCaretakerState extends State<MedTableCaretaker> {
  var myFetchedMedicine = [];
  List<DataRow> list = [];
  final myPatient;

  _MedTableCaretakerState({required this.myPatient});

  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final userId = myPatient["userId"];

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

    print(response.body);
    print(response.statusCode);
    print(response.headers);

    var myObj = json.decode(response.body);

    print(myObj);
    if (this.mounted) {
      for (var item in myObj) {
        setState(() {
          myFetchedMedicine.add(item);
        });
      }
    }

    print(myFetchedMedicine);

    for (var item in myFetchedMedicine) {
      print(item["name"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    myFetchedMedicine.forEach((var m) => {
          log(m["name"]),
          list.add(DataRow(cells: [
            DataCell(Text(m["name"])),
            DataCell(Row(
              children: [
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog(context, m),
                    );
                    m["dosages"]["dosageContextList"].forEach((element) {
                      log("Hello pressed");
                      //log(element.time.toString());
                      //log(element.number.toString());
                    });
                  },
                  child: Text('View '),
                ),
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditMedByCaretaker(
                                medicine: m, patientId: myPatient["userId"])),
                      );
                    }),
                IconButton(
                    onPressed: () async {
                      var medicineId = m["id"];

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final userId = myPatient["userId"];

                      final queryParameters = {'type': 'user'};

                      var uri = Uri.https(
                          'pill-management-backend.herokuapp.com',
                          "/mobile-app-ws/users/${userId}/medicine/${medicineId}",
                          queryParameters);

                      final http.Response response = await http.delete(
                        uri,
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                          'authorization': prefs.get('authToken').toString(),
                          'userid': userId
                        },
                      );

                      print(response.body);
                      print(response.statusCode);
                      print(response.headers);
                    },
                    icon: Icon(Icons.delete))
              ],
            ))
          ])),
          //m.dosages.forEach((element) {
          //log(element.time.toString());
          //log(element.number.toString());
          // })
        });

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "My Medicines",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
            ],
            rows: list,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MedicineFormForCaretaker(
                            patientId: myPatient["userId"],
                          )),
                );
              },
              child: Text('Add medicine'))
        ],
      ),
    );
  }
}

Widget _buildPopupDialog(BuildContext context, var medicine) {
  List<Widget> list = [];

  list.add(Text('Available Count : ' + medicine["availableCount"].toString()));
  list.add(Text('Manufacture : ' + medicine["manufacturingDate"]));
  list.add(Text('Expiry : ' + medicine["expiryDate"]));
  for (var x in medicine["dosages"]["dosageContextList"]) {
    print(x);
    list.add(Text('Time : ' + x["dosageTime"]));
    list.add(Text('Count : ' + x["dosesCount"].toString()));
  }

  return AlertDialog(
    title: Text(medicine["name"]),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Close'),
      ),
    ],
  );
}

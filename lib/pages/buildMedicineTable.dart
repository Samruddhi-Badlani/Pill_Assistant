// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pill_assistant/model/medicine.dart';
import 'package:pill_assistant/data/medicineData.dart';
import 'package:pill_assistant/pages/edit-med-form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedicineTable extends StatefulWidget {
  const MedicineTable({super.key});

  @override
  State<MedicineTable> createState() => _MedicineTableState();
}

class _MedicineTableState extends State<MedicineTable> {
  final columns = ['Name', 'Dosage'];
  List<DataRow> list = [];
  List<Medicine> medicines = List.of(allMedicines);

  var myFetchedMedicine = [];

  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    myFetchedMedicine = [];
    list = [];
    final userId = prefs.get('userid').toString();

    final queryParameters = {'type': 'user'};

    var uri = Uri.http('192.168.97.35:8888',
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

    debugPrint("api response is ");
    print(myObj);
    debugPrint("my fetched medicine is ");
    print(myFetchedMedicine);
    if (this.mounted) {
      for (var item in myObj) {

          debugPrint("my obj loop");
          myFetchedMedicine.add(item);
      }
    }

    print(myFetchedMedicine);

    for (var item in myFetchedMedicine) {
      print(item["name"]);
    }

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    list = [];
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
                          builder: (context) => EditMedicinePage(
                            medicine: m,
                            title: 'Edit Medicine Page',
                          ),
                        ),
                      );
                    }),
                IconButton(
                    onPressed: () async {
                      var medicineId = m["id"];

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      final userId = prefs.get('userid').toString();

                      final queryParameters = {'type': 'user'};

                      var uri = Uri.http(
                          '192.168.97.35:8888',
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

    debugPrint("fetched medicines updated and result is ");
    debugPrint(myFetchedMedicine.toString());

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Medicines",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () async {
                    // handle refresh button click
                    await _loadUserInfo();

                  },
                ),
              ],
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
                Navigator.pushNamed(context, 'addMedicine');
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

  return new AlertDialog(
    title: Text(medicine["name"]),
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

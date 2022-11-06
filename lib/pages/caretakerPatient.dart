// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:pill_assistant/pages/patientsMedicines.dart';
import '../model/patient.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const Color tdBlue = Color(0xFF0277BD);

class CaretakerPatientInterface extends StatefulWidget {
  final Patient patient;

  const CaretakerPatientInterface({super.key, required this.patient});

  @override
  State<CaretakerPatientInterface> createState() =>
      _CaretakerPatientInterfaceState(patient);
}

class _CaretakerPatientInterfaceState extends State<CaretakerPatientInterface> {
  var myPatient = null;
  final Patient patient;
  String myHead = '';

  _CaretakerPatientInterfaceState(this.patient);
  @override
  void initState() {
    super.initState();
    _loadPatientInfo();
  }

  _loadPatientInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var uri = Uri.https('pill-management-backend.herokuapp.com',
        "/mobile-app-ws/users/${patient.id}");

    final http.Response responsePatient = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': prefs.get('authToken').toString(),
        'userid': prefs.get('userid').toString()
      },
    );

    if (responsePatient.statusCode == 200) {
      print("Patient details fetched");
      print(responsePatient.body);

      setState(() {
        myPatient = json.decode(responsePatient.body);
      });
    } else {
      print("Patient details could not be fetched");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (patient.patientEmail != null) {
      myHead = patient.patientEmail ?? 'Oh No';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(myHead),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (myPatient != null) ...{
                GridView(
                  // ignore: sort_child_properties_last
                  shrinkWrap: true,

                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PatientsMedicine(myPatient: myPatient)),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: tdBlue,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medical_services,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              "Patient's medicines",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'myReminders');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: tdBlue,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.access_alarm,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              "Patient's reminders",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                    /*
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'settings');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: tdBlue,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.settings,
                                size: 50,
                                color: Colors.white,
                              ),
                              Text(
                                "My settings",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )
                            ],
                          ),
                        )),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'profile');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: tdBlue,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_circle,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              "My profile",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'scanQR');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: tdBlue,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              "Scan/Read qr",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'generateQR');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: tdBlue,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              "Generate QR code",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    )
                    */
                  ],
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                ),
              },
              Container(
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                    ),
                    onPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();

                      if (preferences.containsKey('authToken')) {
                        preferences.remove('authToken');
                        Navigator.pushNamed(context, 'login');
                      }
                    },
                    child: Text('Log Out')),
              )
            ],
          ),
        ),
      ),
    );
  }
}

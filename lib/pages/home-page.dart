// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var subscribedActionStream = false;
const Color tdBlue = Color(0xFF0277BD);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    if (!subscribedActionStream) {
      AwesomeNotifications().actionStream.listen((action) async {
        var medicineInfo;

        if (action.buttonKeyPressed == "yes") {
          print("Thanks for taking medicine");

          SharedPreferences prefs = await SharedPreferences.getInstance();

          final userId = prefs.get('userid').toString();

          final medId = prefs.get('medId').toString();

          final queryParameters = {'type': 'user'};

          var uri = Uri.https(
              'pill-management-backend.herokuapp.com',
              "/mobile-app-ws/users/${userId}/medicine/${medId}",
              queryParameters);

          final http.Response response = await http.get(
            uri,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'authorization': prefs.get('authToken').toString(),
              'userid': userId
            },
          );

          if (response.statusCode == 200) {
            print("Medicine details not found .....");
            print(response.body);
            print(response.statusCode);
            print(response.headers);

            medicineInfo = json.decode(response.body);

/*
            setState(() {
              medicineInfo = json.decode(response.body);

              print("Current medicine count is " +
                  medicineInfo["availableCount"].toString());
            });

            */

            print("Now deleting available counts .... ");

            var bodyContent = {
              "availableCount": medicineInfo['availableCount'] - 1,
              "dateOfEnd": medicineInfo["dateOfEnd"],
              "dateOfStart": medicineInfo["dateOfStart"],
              "dosages": medicineInfo["dosages"],
              "expiryDate": medicineInfo["expiryDate"],
              "manufacturingDate": medicineInfo["manufacturingDate"],
              "name": medicineInfo["name"],
              "id": medicineInfo["id"],
              "userId": userId
            };

            var myContent = json.encode(bodyContent);

            print("Content send for editing available count is");
            print(myContent);
            var uri2 = Uri.https(
                'pill-management-backend.herokuapp.com',
                "/mobile-app-ws/users/${userId}/medicine/${medId}",
                queryParameters);

            final http.Response response2 = await http.put(uri2,
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'authorization': prefs.get('authToken').toString(),
                  'userid': userId,
                },
                body: myContent);

            if (response2.statusCode == 200) {
              print(response2.body);
              print("User medicine successfully");
              print(response2.statusCode);
              print(response2.headers);
            } else {
              print(response2.body);
              print(response2.statusCode);
              print("User medicine could not be updated");
            }

            print("Current info is   .......");
          } else {
            print(response.statusCode);
            print("Medicine details could not be fetched");
          }
        } else if (action.buttonKeyPressed == "no") {
          print("You missed your dose!!!");
        } else {
          print(action.payload); //notification was pressed
        }
      });
      subscribedActionStream = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView(
                physics: ScrollPhysics(),
                // ignore: sort_child_properties_last
                shrinkWrap: true,

                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'myMeds');
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
                            "My meds",
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
                            "My reminders",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
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
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      final userId = prefs.get('userid').toString();

                      var uri = Uri.https(
                          'pill-management-backend.herokuapp.com',
                          "/mobile-app-ws/users/${userId}/msg");

                      final http.Response response = await http.post(
                        uri,
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                          'authorization': prefs.get('authToken').toString(),
                          'userid': userId
                        },
                      );

                      if (response.statusCode == 200) {
                        print(response.body);
                        print("Message sent Successfully");
                        print(response.statusCode);
                        print(response.headers);
                      } else {
                        print(response.statusCode);
                        print("ERROR in sending message");
                      }
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
                            Icons.message,
                            size: 50,
                            color: Colors.white,
                          ),
                          Text(
                            "Send Message to Contact",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  )
                ],
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
              ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

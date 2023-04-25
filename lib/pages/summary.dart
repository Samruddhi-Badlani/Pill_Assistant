import 'package:flutter/material.dart';
import 'package:pill_assistant/pages/caretakerPatient.dart';

import '../model/patient.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../widgets/patient_item.dart';

const Color tdRed = Color(0xFFDA4040);
const Color tdBlue = Color(0xFF5F52EE);

const Color tdBlack = Color(0xFF3A3A3A);
const Color tdGrey = Color(0xFF717171);

const Color tdBGColor = Color(0xFFEEEFF5);

class Summary extends StatefulWidget {
  Summary({Key? key}) : super(key: key);

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  List<Patient> todosList = [];

  List<Patient> myPatients = [];

  List<Patient> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadPatientsInfo();
  }

  void _loadPatientsInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var caretakerId = prefs.get('userid').toString();

    print("Get all patients api will be called ");

    // Getting user id from email

    var uri = Uri.http('192.168.97.35:8888',
        "/mobile-app-ws/caretaker/$caretakerId");

    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': prefs.get('authToken').toString(),
        'userid': prefs.get('userid').toString()
      },
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);

      var myResponse = json.decode(response.body);

      for (var patient in myResponse) {
        print("Hello");
        print(patient);

        // Getting patient details

        var uri = Uri.http('192.168.97.35:8888',
            "/mobile-app-ws/users/${patient['userId'].toString()}");

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

          var actualPatient = json.decode(responsePatient.body);

          myPatients.add(Patient(
              id: actualPatient["userId"].toString(),
              patientEmail: actualPatient["email"]));
        } else {
          print("Patient details could not be fetched");
        }
      }

      print("patient list ");
      print(myPatients.length);

      setState(() {
        todosList = myPatients;
      });
      setState(() {
        _foundToDo = todosList;
      });

      print("to do list");
      print(todosList.length);
    } else {
      print("Error in loading all patients");
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 50,
                          bottom: 20,
                        ),
                        child: Text(
                          'All Patients',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for (Patient todoo in _foundToDo.reversed)
                        PatientItem(
                          patient: todoo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                        hintText: 'Please enter patient\'s email id ',
                        border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                  onPressed: () {
                    _addToDoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: tdBlue,
                    minimumSize: Size(60, 60),
                    elevation: 10,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(Patient patient) {
    /*
    setState(() {
      todo.isDone = !todo.isDone;
    });

    */

    print("handle to do change called");

    print(patient.id);
    print(patient.patientEmail);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CaretakerPatientInterface(patient: patient)),
    );
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var caretakerId = prefs.get('userid').toString();

    final queryParameters = {'type': 'user'};

    // Getting user id from email

    var uri = Uri.http('192.168.97.35:8888',
        "/mobile-app-ws/users/email/$email", queryParameters);

    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': prefs.get('authToken').toString(),
        'userid': prefs.get('userid').toString()
      },
    );

    var myResponse;
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.headers);

      if (response.body.isNotEmpty) {
        myResponse = json.decode(response.body);
        print(response.body);
      } else {
        print('getting user from email  response is empty');
      }

      // Creating a link between caretaker and user

      var patientId = myResponse["userId"];
      print("Patient id is  " + patientId.toString());
      print("Patient name is " + myResponse["firstName"].toString());
      var uri = Uri.http('192.168.97.35:8888',
          "/mobile-app-ws/users/$patientId/caretaker/$caretakerId");

      final http.Response linkresponse = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': prefs.get('authToken').toString(),
          'userid': prefs.get('userid').toString()
        },
      );

      if (linkresponse.statusCode == 200) {
        print("Patient added successfully");

        setState(() {
          todosList.add(Patient(
            id: myResponse["userId"],
            patientEmail: email,
          ));
        });
      } else {
        print("Error in linking patient");
        print(linkresponse.statusCode);
        print(linkresponse.body);
      }
    } else {
      print(response.statusCode);
      print(response.body);
      print(response.headers);
    }

    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<Patient> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.patientEmail!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        Container(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ]),
    );
  }
}

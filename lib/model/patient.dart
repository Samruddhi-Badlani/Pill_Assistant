import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Patient {
  String? id;
  String? patientEmail;
  bool isDone;

  Patient({
    required this.id,
    required this.patientEmail,
    this.isDone = false,
  });

  static List<Patient> todoList() {
    return [Patient(id: "12", patientEmail: "xjjsj")];
  }
}

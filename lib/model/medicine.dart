import 'package:flutter/material.dart';

class Dosage {
  TimeOfDay time;
  int number;
  Dosage({required this.time, required this.number});
}

class Medicine {
  String name;
  List<Dosage> dosages;
  DateTime expiryDate;
  DateTime dateOfStart;
  DateTime dateOfEnd;
  int patientId;
  DateTime manufactureDate;
  int availableCounts;

  Medicine(
      {required this.name,
      required this.dosages,
      required this.expiryDate,
      required this.patientId,
      required this.dateOfEnd,
      required,
      required this.dateOfStart,
      required this.availableCounts,
      required this.manufactureDate});
}

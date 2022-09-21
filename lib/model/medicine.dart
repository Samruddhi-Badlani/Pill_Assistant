import 'dart:ffi';

import 'package:flutter/material.dart';

class Dosage {
  TimeOfDay time;
  int number;
  Dosage({required this.time, required this.number});
}

class Medicine {
  String name;
  List<Dosage> dosages;

  Medicine({required this.name, required this.dosages});
}

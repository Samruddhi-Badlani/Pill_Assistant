// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:pill_assistant/model/medicine.dart';

var allMedicines = <Medicine>[
  Medicine(name: 'Calpol', dosages: [Dosage(time: TimeOfDay.now(), number: 1)]),
  Medicine(
      name: 'Disprin', dosages: [Dosage(time: TimeOfDay.now(), number: 2)]),
  Medicine(
      name: 'Iron Pills', dosages: [Dosage(time: TimeOfDay.now(), number: 3)]),
  Medicine(
      name: 'Vitamin C', dosages: [Dosage(time: TimeOfDay.now(), number: 4)]),
  Medicine(name: 'Multivitamin', dosages: [
    Dosage(time: TimeOfDay.now(), number: 1),
    Dosage(time: TimeOfDay(hour: 15, minute: 45), number: 2)
  ]),
];

// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pill_assistant/model/medicine.dart';

final allMedicines = <Medicine>[
  Medicine(name: 'Calpol', dosages: [Dosage(time: TimeOfDay.now(), number: 1)]),
  Medicine(name: 'Calpol', dosages: [Dosage(time: TimeOfDay.now(), number: 1)]),
  Medicine(name: 'Calpol', dosages: [Dosage(time: TimeOfDay.now(), number: 1)]),
  Medicine(name: 'Calpol', dosages: [Dosage(time: TimeOfDay.now(), number: 1)]),
  Medicine(name: 'Calpol', dosages: [Dosage(time: TimeOfDay.now(), number: 1)]),
];

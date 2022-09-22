// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:pill_assistant/model/medicine.dart';

var allMedicines = <Medicine>[
  Medicine(
      name: 'Calpol',
      dosages: [
        Dosage(time: TimeOfDay.now(), number: 1),
      ],
      expiryDate: DateTime(2030),
      dateOfEnd: DateTime(2022, 10, 23),
      dateOfStart: DateTime(2022, 9, 23),
      patientId: 1,
      manufactureDate: DateTime(2021),
      availableCounts: 20),
  Medicine(
      name: 'Iron Pills',
      dosages: [
        Dosage(time: TimeOfDay.now(), number: 1),
      ],
      expiryDate: DateTime(2030),
      dateOfEnd: DateTime(2022, 10, 23),
      dateOfStart: DateTime(2022, 9, 23),
      patientId: 1,
      manufactureDate: DateTime(2021),
      availableCounts: 20),
  Medicine(
      name: 'Disprin',
      dosages: [
        Dosage(time: TimeOfDay.now(), number: 1),
      ],
      expiryDate: DateTime(2030),
      dateOfEnd: DateTime(2022, 10, 23),
      dateOfStart: DateTime(2022, 9, 23),
      patientId: 1,
      manufactureDate: DateTime(2021),
      availableCounts: 20),
  Medicine(
      name: 'Calcium',
      dosages: [
        Dosage(time: TimeOfDay.now(), number: 1),
      ],
      expiryDate: DateTime(2030),
      dateOfEnd: DateTime(2022, 10, 23),
      dateOfStart: DateTime(2022, 9, 23),
      patientId: 1,
      manufactureDate: DateTime(2021),
      availableCounts: 20),
  Medicine(
      name: 'Vitamin C',
      dosages: [
        Dosage(time: TimeOfDay.now(), number: 1),
      ],
      expiryDate: DateTime(2030),
      dateOfEnd: DateTime(2022, 10, 23),
      dateOfStart: DateTime(2022, 9, 23),
      patientId: 1,
      manufactureDate: DateTime(2021),
      availableCounts: 20),
];

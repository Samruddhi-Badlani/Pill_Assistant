import 'package:flutter/material.dart';

import '../model/patient.dart';

const Color tdRed = Color(0xFFDA4040);
const Color tdBlue = Color(0xFF5F52EE);

const Color tdBlack = Color(0xFF3A3A3A);
const Color tdGrey = Color(0xFF717171);

const Color tdBGColor = Color(0xFFEEEFF5);

class PatientItem extends StatelessWidget {
  final Patient patient;
  final onToDoChanged;
  final onDeleteItem;

  const PatientItem({
    Key? key,
    required this.patient,
    required this.onToDoChanged,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              // print('Clicked on Todo Item.');
              onToDoChanged(patient);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            tileColor: Colors.white,
            leading: Icon(
              patient.isDone ? Icons.check_box : Icons.check_box_outline_blank,
              color: tdBlue,
            ),
            title: Text(
              patient?.patientEmail ?? '',
              style: TextStyle(
                fontSize: 16,
                color: tdBlack,
                decoration: patient.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            trailing: Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.symmetric(vertical: 12),
              height: 35,
              width: 100,
              decoration: BoxDecoration(
                color: tdBGColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                child: Text('Discharged'),
                onPressed: () {
// print('Clicked on delete icon');
                  onDeleteItem(patient.id);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

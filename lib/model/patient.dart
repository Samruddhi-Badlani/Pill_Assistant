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
    return [
      Patient(id: '01', patientEmail: 'rishabh@gmail.com', isDone: true),
      Patient(id: '02', patientEmail: 'anushka@gmail.com', isDone: true),
    ];
  }
}

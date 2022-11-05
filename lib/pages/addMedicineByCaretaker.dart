import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class MedicineFormForCaretaker extends StatefulWidget {
  final patientId;

  const MedicineFormForCaretaker({super.key, this.patientId});

  @override
  State<MedicineFormForCaretaker> createState() =>
      _MedicineFormForCaretakerState(patientId: patientId);
}

class _MedicineFormForCaretakerState extends State<MedicineFormForCaretaker> {
  final patientId;

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

  _MedicineFormForCaretakerState({required this.patientId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Medicine"),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.green,
        //   ),
        //   onPressed: () {Navigator.of(context).pop();}
        // )
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SignUpFormCaretaker(patientId: patientId)),
    );
  }
}

class SignUpFormCaretaker extends StatefulWidget {
  final patientId;

  const SignUpFormCaretaker({super.key, required this.patientId});
  @override
  _SignUpFormCaretakerState createState() =>
      _SignUpFormCaretakerState(patientId: patientId);
}

class _SignUpFormCaretakerState extends State<SignUpFormCaretaker> {
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();

  final patientId;

  String userId = '';
  String authToken = '';

  _SignUpFormCaretakerState({this.patientId});
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

      userId = patientId;
      authToken = prefs.get('authToken').toString();
    }
  }

  TextEditingController dateOfStartController = TextEditingController();
  TextEditingController dateOfEndController = TextEditingController();
  TextEditingController dateOfManufactureController = TextEditingController();
  TextEditingController dateOfExpiryController = TextEditingController();
  TextEditingController timeinput = TextEditingController();

  TextEditingController dosageCountController = TextEditingController();
  String _name = '';
  int _count = -1;
  DateTime _dateOfStart = DateTime(2022);
  DateTime _dateOfEnd = DateTime(2022);
  DateTime _dateOfManufacture = DateTime(2022);
  DateTime _dateOfExpiry = DateTime(2022);

  var dosages = [];

  int _dosageCount = 1;
  DateTime _dosageTime = DateTime(2022);

  List<DropdownMenuItem<int>> genderList = [];

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
        key: _formKey,
        child: ListView(
          children: getFormWidget(),
        ));
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = [];

    formWidget.add(TextFormField(
      decoration:
          const InputDecoration(labelText: 'Enter Name', hintText: 'Name'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a name';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _name = value.toString();
        });
      },
    ));

    formWidget.add(TextFormField(
      decoration: const InputDecoration(
          labelText: 'Enter available Counts', hintText: 'Dosage'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a value';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _count = int.parse(value.toString());
        });
      },
    ));
    formWidget.add(TextField(
      controller: dateOfStartController,

      decoration: InputDecoration(
          errorText: dateOfStartController.text.isEmpty
              ? 'Value Can\'t Be Empty'
              : null,
          icon: Icon(Icons.calendar_today), //icon of text field
          labelText: "Date of Start" //label text of field
          ),
      readOnly: true, //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(
                2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101));

        if (pickedDate != null) {
          print(
              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print(
              formattedDate); //formatted date output using intl package =>  2021-03-16
          //you can implement different kind of Date Format here according to your requirement

          setState(() {
            dateOfStartController.text =
                formattedDate; //set output date to TextField value.
          });
        } else {
          print("Date is not selected");
        }
      },
    ));

    formWidget.add(TextField(
      controller: dateOfEndController, //editing controller of this TextField
      decoration: InputDecoration(
          errorText:
              dateOfEndController.text.isEmpty ? 'Value Can\'t Be Empty' : null,
          icon: Icon(Icons.calendar_today), //icon of text field
          labelText: "Date of End" //label text of field
          ),
      readOnly: true, //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(
                2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101));

        if (pickedDate != null) {
          print(
              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print(
              formattedDate); //formatted date output using intl package =>  2021-03-16
          //you can implement different kind of Date Format here according to your requirement

          setState(() {
            dateOfEndController.text =
                formattedDate; //set output date to TextField value.
          });
        } else {
          print("Date is not selected");
        }
      },
    ));

    formWidget.add(TextField(
      controller:
          dateOfManufactureController, //editing controller of this TextField
      decoration: InputDecoration(
          errorText: dateOfManufactureController.text.isEmpty
              ? 'Value Can\'t Be Empty'
              : null,
          icon: Icon(Icons.calendar_today), //icon of text field
          labelText: "Manufacturing Date" //label text of field
          ),
      readOnly: true, //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(
                2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101));

        if (pickedDate != null) {
          print(
              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print(
              formattedDate); //formatted date output using intl package =>  2021-03-16
          //you can implement different kind of Date Format here according to your requirement

          setState(() {
            dateOfManufactureController.text =
                formattedDate; //set output date to TextField value.
          });
        } else {
          print("Date is not selected");
        }
      },
    ));

    formWidget.add(TextField(
      controller: dateOfExpiryController, //editing controller of this TextField
      decoration: InputDecoration(
          errorText: dateOfExpiryController.text.isEmpty
              ? 'Value Can\'t Be Empty'
              : null,
          icon: Icon(Icons.calendar_today), //icon of text field
          labelText: "Expiry Date" //label text of field
          ),
      readOnly: true, //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(
                2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101));

        if (pickedDate != null) {
          print(
              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print(
              formattedDate); //formatted date output using intl package =>  2021-03-16
          //you can implement different kind of Date Format here according to your requirement

          setState(() {
            dateOfExpiryController.text =
                formattedDate; //set output date to TextField value.
          });
        } else {
          print("Date is not selected");
        }
      },
    ));
    formWidget.add(TextField(
      controller: timeinput, //editing controller of this TextField
      decoration: InputDecoration(
          errorText: timeinput.text.isEmpty ? 'Value Can\'t Be Empty' : null,
          icon: Icon(Icons.timer), //icon of text field
          labelText: "Dosage Time" //label text of field
          ),
      readOnly: true, //set it true, so that user will not able to edit text
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          initialTime: TimeOfDay.now(),
          context: context,
        );

        if (pickedTime != null) {
          print(pickedTime.format(context));
          final now = new DateTime.now();
          final parsedTime = new DateTime(
              now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
//output 10:51 PM

          //converting to DateTime so that we can further format on different pattern.
          print(parsedTime);

          //output 1970-01-01 22:53:00.000
          String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
          print(formattedTime); //output 14:59:00
          //DateFormat() is from intl package, you can format the time on any pattern you need.

          setState(() {
            timeinput.text = formattedTime;

            _dosageTime = parsedTime;
          });
        } else {
          print("Time is not selected");
        }
      },
    ));
    formWidget.add(TextFormField(
      controller: dosageCountController,
      decoration:
          const InputDecoration(labelText: 'Dosage Count', hintText: 'Dosage'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a value';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        setState(() {
          _dosageCount = int.parse(value.toString());
          dosageCountController.text = value.toString();
        });
      },
    ));

    formWidget.add(Column(children: [
      for (var item in dosages)
        Text('${item["dosageCount"]} ${item["dosageTime"]}')
    ]));

    formWidget.add(TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      onPressed: () {
        print(dosageCountController.text);
        print(_dosageTime);

        if (dosageCountController.text == '' || timeinput.text == '') {
        } else {
          setState(() {
            dosages.add({
              "dosageCount": dosageCountController.text,
              "dosageTime": timeinput.text
            });
          });
        }
        print(dosages);
      },
      child: Text('Add Dose'),
    ));

    void onPressedSubmit() async {
      if (_formKey.currentState!.validate() &&
          dateOfStartController.text.isNotEmpty &&
          dateOfEndController.text.isNotEmpty &&
          dateOfManufactureController.text.isNotEmpty &&
          dateOfExpiryController.text.isNotEmpty &&
          dosageCountController.text.isNotEmpty) {
        _formKey.currentState?.save();

        print("Name " + _name);

        var myList = [];

        for (var item in dosages) {
          myList.add({
            "dosageTime": item["dosageTime"].toString(),
            "dosesCount": item["dosageCount"]
          });
        }

        print(myList);

        var bodyContent = {
          "availableCount": _count,
          "dateOfEnd": dateOfEndController.text,
          "dateOfStart": dateOfStartController.text,
          "dosages": {"dosageContextList": myList},
          "expiryDate": dateOfExpiryController.text,
          "manufacturingDate": dateOfManufactureController.text,
          "name": _name
        };

        var myContent = json.encode(bodyContent);
        print(myContent);

        print("Age " + _count.toString());

        print(authToken);
        print(userId);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        final queryParameters = {'type': 'user'};

        var uri = Uri.https('pill-management-backend.herokuapp.com',
            "/mobile-app-ws/users/${userId}/medicine", queryParameters);

        final http.Response response = await http.post(uri,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'authorization': prefs.get('authToken').toString(),
              'userid': userId
            },
            body: myContent);

        print(response.body);
        print(response.statusCode);
        print(response.headers);

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Form Submitted')));
      }
    }

    formWidget.add(ElevatedButton(
        child: const Text('Add Medicine'), onPressed: onPressedSubmit));

    return formWidget;
  }
}

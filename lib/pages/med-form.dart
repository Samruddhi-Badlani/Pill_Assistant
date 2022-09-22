import 'package:flutter/material.dart';

class FormApp extends StatelessWidget {
  const FormApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Add Medicine',
      theme: ThemeData(brightness: Brightness.light),
      home: const FormPage(title: 'Add Medicine Page'),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SignUpForm()),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();

  String _name = '';
  String _dosage = '';
  int _count = -1;

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
      decoration:
          const InputDecoration(labelText: 'Enter dosage', hintText: 'Dosage'),
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        setState(() {
          _dosage = value.toString();
        });
      },
    ));

    formWidget.add(TextFormField(
      decoration:
          const InputDecoration(hintText: 'count', labelText: 'Enter count'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter count';
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

    void onPressedSubmit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        print("Name " + _name);
        print("Email " + _dosage);
        print("Age " + _count.toString());

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Form Submitted')));
      }
    }

    formWidget.add(ElevatedButton(
        child: const Text('Add Medicine'), onPressed: onPressedSubmit));

    return formWidget;
  }
}

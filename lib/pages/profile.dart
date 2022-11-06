// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// import 'package:settings_ui/pages/settings.dart';

// class SettingsUI extends StatelessWidget {
//   const SettingsUI({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Setting UI",
//       home: EditProfilePage(),
//     );
//   }
// }

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key? key}) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;
  var contacts = [];

  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();

  var user;

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
    }

    final userId = prefs.get('userid').toString();

    final queryParameters = {'type': 'user'};

    var uri = Uri.https('pill-management-backend.herokuapp.com',
        "/mobile-app-ws/users/${userId}", queryParameters);

    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': prefs.get('authToken').toString(),
        'userid': userId
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      print(response.statusCode);
      print(response.headers);

      setState(() {
        user = json.decode(response.body);
      });
    } else {
      print(response.statusCode);
      print("User details could not be fetched");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.green,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(6),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=",
                              ))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.green,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              if (user != null) ...{
                buildTextField("Full Name", '${user["firstName"]}', false),
                buildTextField("Registered As", "Patient", false),
                buildTextField("E-mail", "${user['email']}", false),
                TextField(
                    controller: contactNameController,
                    decoration: InputDecoration(
                        errorText: contactNameController.text.isEmpty
                            ? 'Value Can\'t Be Empty'
                            : null,
                        //icon of text field
                        labelText: "Contact Name" //label text of field
                        )),
                TextField(
                    controller: contactNumberController,
                    decoration: InputDecoration(
                        errorText: contactNameController.text.isEmpty
                            ? 'Value Can\'t Be Empty'
                            : null,
                        //icon of text field
                        labelText:
                            "Contact Number +91 XXXXXXXXXX" //label text of field
                        )),

                if (contacts.length > 0) ...{
                  for (var contact in contacts)
                    Text(contact["name"].toString() +
                        " " +
                        contact["contactNumber"])
                },
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    print(contactNameController.text);
                    print(contactNumberController.text);

                    if (contactNameController.text == '' ||
                        contactNumberController.text == '') {
                    } else {
                      setState(() {
                        contacts.add({
                          "contactNumber": contactNumberController.text,
                          "name": contactNameController.text
                        });
                      });
                    }
                    print(contacts);
                  },
                  child: Text('Add Contact'),
                )

                // buildTextField("Password", "${user['password']}", true),
                // buildTextField("Mobile number", "7065677767", false),
              },
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      final userId = prefs.get('userid').toString();

                      final queryParameters = {'type': 'user'};

                      var uri = Uri.https(
                          'pill-management-backend.herokuapp.com',
                          "/mobile-app-ws/users/${userId}",
                          queryParameters);

                      final http.Response response = await http.put(uri,
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                            'authorization': prefs.get('authToken').toString(),
                            'userid': userId
                          },
                          body: jsonEncode(<String, dynamic>{
                            'email': user["email"],
                            'firstName': user["firstName"],
                            'lastName': user["lastName"],
                            'emergencyContacts': {'contactlist': contacts}
                          }));

                      if (response.statusCode == 200) {
                        print(response.body);
                        print("User updated successfully");
                        print(response.statusCode);
                        print(response.headers);
                      } else {
                        print(response.statusCode);
                        print("User could not be updated");
                      }
                    },
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}

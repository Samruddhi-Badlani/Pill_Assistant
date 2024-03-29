// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class GenerateByCaretaker extends StatefulWidget {
  final myPatient;
  const GenerateByCaretaker({super.key, this.myPatient});

  @override
  State<GenerateByCaretaker> createState() =>
      _GenerateByCaretakerState(myPatient: myPatient);
}

class _GenerateByCaretakerState extends State<GenerateByCaretaker> {
  final columns = ['Name', 'Dosage'];
  final myPatient;
  List<DataRow> list = [];
  var image;

  var mySelection;

  var myFetchedMedicine = [];
  var userId;

  _GenerateByCaretakerState({this.myPatient});

  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final queryParameters = {'type': 'user'};

    print("My patient is " + myPatient.toString());

    userId = myPatient["userId"];

    var uri = Uri.http(
        '192.168.97.35:8888',
        "/mobile-app-ws/users/${myPatient["userId"]}/medicine",
        queryParameters);

    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': prefs.get('authToken').toString(),
        'userid': userId
      },
    );

    print(response.body);
    print(response.statusCode);
    print(response.headers);

    var myObj = json.decode(response.body);

    print(myObj);
    if (this.mounted) {
      for (var item in myObj) {
        setState(() {
          myFetchedMedicine.add(item);
        });
      }
    }

    print(myFetchedMedicine);

    for (var item in myFetchedMedicine) {
      print(item["name"]);
    }
  }

  void generateQR(userid, medicineId) async {
    if (await Permission.storage.request().isGranted) {
      print("qr code generator   called");

      final queryParameters = {'data': medicineId};

      var uri =
          Uri.http('api.qrserver.com', '/v1/create-qr-code', queryParameters);

      final http.Response response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        print(response.bodyBytes);
        print(response.statusCode);
        print(response.body);

        setState(() {
          image = response.bodyBytes;
        });

        final Directory directory = await getApplicationDocumentsDirectory();
        final File filenew =
            File('${directory.path}/${userid}${medicineId}my_image.jpg');
        await filenew.writeAsBytes(image);

        final result = await ImageGallerySaver.saveImage(image,
            quality: 60, name: '${userid}${medicineId}my_image');
        print(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Hospital Management"),
      ),
      body: Column(
        children: [
          new Center(
            child: Column(
              children: [
                new DropdownButton(
                  hint: Text("Choose from here"),
                  items: myFetchedMedicine.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item['name']),
                      value: item['id'].toString(),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      mySelection = newVal;
                    });
                  },
                  value: mySelection,
                ),
                TextButton(
                    onPressed: () {
                      print(mySelection);
                      generateQR(userId, mySelection);
                    },
                    child: Text("Generate QR code")),
                if (image != null) ...{Image(image: MemoryImage(image))},
                if (image != null) ...{Text("QR Saved in gallery !!")},
              ],
            ),
          ),
        ],
      ),
    );
  }
}

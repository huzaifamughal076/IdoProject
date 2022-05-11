import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateActivityScreen extends StatefulWidget {
  final String uid;

  const CreateActivityScreen(this.uid, {Key? key}) : super(key: key);

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final formKey = GlobalKey<FormState>();
  var activityName, activityPassword, activityConfirmPassword;

  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController c_password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Create New Activity'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: TextFormField(
                    validator: (name) {
                      if (name!.isEmpty || name == null) {
                        return "Name required";
                      } else {
                        activityName = name;
                        return null;
                      }
                    },
                    keyboardType: TextInputType.name,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'Activity Name',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: TextFormField(
                    validator: (password) {
                      if (password!.isEmpty || password == null) {
                        return "Password required";
                      } else if (password.length < 6) {
                        return "Password should be greater then 6 characters";
                      } else {
                        activityPassword = password;
                        return null;
                      }
                    },
                    obscureText: true,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'Activity Password',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: TextFormField(
                    validator: (c_password) {
                      if (c_password!.isEmpty || c_password == null) {
                        return "Confirm Password please";
                      } else if (c_password != activityPassword) {
                        return "Passwords don't match";
                      } else {
                        activityConfirmPassword = c_password;
                        return null;
                      }
                    },
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'Confirm Activity Password',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFFFFFF),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState != null &&
                                  formKey.currentState!.validate()) {
                                CreateActivityFun();
                              } else
                                return;
                            },
                            child: Text("Create Activity")),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void CreateActivityFun() async {
    Firebase.initializeApp();
    // String currentTime=DateTime.now().toString();
    int min = 10000; //min and max values act as your 6 digit range
    int max = 99999;
    var randomizer = new Random();
    var rNum = min + randomizer.nextInt(max - min);

    final databaseReference =
        FirebaseDatabase.instance.reference().child("Activities");
    databaseReference.child(rNum.toString()).set({
      'name': activityName,
      'password': activityPassword,
      'manager': widget.uid,
      'id': rNum
    }).asStream();

    Fluttertoast.showToast(
        msg: "Activity created successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.pop(context);
  }
}

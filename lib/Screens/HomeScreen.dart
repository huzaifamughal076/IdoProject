import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gumshoe/Models/ActivityModel.dart';
import 'package:gumshoe/Screens/LoginScreen.dart';
import 'package:gumshoe/Screens/MyActivitiesScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  final String uid, name;

  const HomeScreen(this.uid, this.name, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String longi, lati;

  final formKey = GlobalKey<FormState>();
  var id, password;
  var activityList = [];
  List<ActivityModel> allActivities = [];
  TextEditingController activityId = TextEditingController();
  TextEditingController activityPassword = TextEditingController();

  @override
  void initState() {
    Firebase.initializeApp();
    final databaseReference =
    FirebaseDatabase.instance.reference().child("Activities");
    databaseReference.get().then((event) {
      for (final entity in event.children) {
        String name = entity.child("name").value.toString();
        String manager = entity.child("manager").value.toString();
        String id = entity.child("id").value.toString();
        String password = entity.child("password").value.toString();
        ActivityModel activitymodel = ActivityModel(
            name: name, manager: manager, password: password, id: id);
        allActivities.add(activitymodel);
        print(allActivities.length);
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Welcome ' + widget.name),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: CarouselSlider(
                  options: CarouselOptions(height: 150.0),
                  items: [1, 2, 3].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(color: Colors.amber),
                            child: Text(
                              'Image $i',
                              style: TextStyle(fontSize: 16.0),
                            ));
                      },
                    );
                  }).toList(),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    margin: EdgeInsets.only(top: 20, right: 12),
                    child: Text('Activities you have Joined',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24))),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    margin: EdgeInsets.only(top: 10, right: 12),
                    child: Text('You havent joined any activity yet')),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    margin: EdgeInsets.only(top: 20, right: 12),
                    child: Text('Activities near you',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24))),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: allActivities.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var currentItem = allActivities[index];
                    if(allActivities.length==0||allActivities.length==null){
                      return Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Text('No Activities found'),
                      );
                    }
                    else
                      return Container(
                        width: double.infinity,
                        height: 100,
                        padding: new EdgeInsets.all(5.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.white,
                          elevation: 5,
                          child: Center(
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.location_city, size: 40),
                                  title: Text(currentItem.name,
                                      style: TextStyle(fontSize: 20.0)),
                                  subtitle: Text("Members : 0",
                                      style: TextStyle(fontSize: 18.0)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Join an Activity'),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0)), //this right here
                  child: Container(
                    height: 230,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              validator: (activityId) {
                                if (activityId!.isEmpty || activityId == null) {
                                  return "Id required";
                                } else {
                                  id = activityId;
                                  return null;
                                }
                              },
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                labelText: 'Activity ID',
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              validator: (activityPassword) {
                                if (activityPassword!.isEmpty ||
                                    activityPassword == null) {
                                  return "Password required";
                                } else {
                                  password = activityPassword;
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
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel')),
                                SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState != null &&
                                          formKey.currentState!.validate()) {
                                        activityList.clear();
                                        DatabaseReference databaseReference =
                                            FirebaseDatabase.instance
                                                .reference();
                                        databaseReference
                                            .child("Activities")
                                            .once()
                                            .then((DatabaseEvent value) {
                                          if (value.snapshot.child(id).exists) {
                                            String pass = value.snapshot
                                                .child(id)
                                                .child("password")
                                                .value
                                                .toString();
                                            if (widget.uid ==
                                                value.snapshot
                                                    .child(id)
                                                    .child("manager")
                                                    .value
                                                    .toString()) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "You are the manager of this activity. Can't join as user");
                                              return;
                                            }
                                            else if (password == pass) {
                                              databaseReference
                                                  .child("Activities")
                                                  .child("Members")
                                                  .once()
                                                  .then((value) {
                                                var i = value
                                                    .snapshot.children.length;
                                                i++;
                                                databaseReference
                                                    .child("Activities")
                                                    .child(id)
                                                    .child("Members")
                                                    .child(i.toString())
                                                    .set(widget.uid);
                                              });
                                              Fluttertoast.showToast(
                                                  msg: "Joined successfully");
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) => ActivityScreen()));

                                              //Move to next screen from here
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "Wrong Password");
                                              return;
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "No such activity found.");
                                            return;
                                          }
                                        });
                                      } else
                                        return;
                                    },
                                    child: Text("Join"))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('My Activities'),
            leading: Icon(Icons.calendar_view_month),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyActivitiesScreen(widget.uid)));
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('About Us'),
            leading: Icon(Icons.account_circle_outlined),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Terms of Use'),
            leading: Icon(Icons.add_moderator),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Contact Us'),
            leading: Icon(Icons.contact_mail),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Log Out'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => LoginScreen(),
              ),
                    (route) => false,
              );
            },
          ),
        ]),
      ),
    ));
  }

  void authenticateActivity() {}
}

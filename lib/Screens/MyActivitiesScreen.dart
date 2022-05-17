import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gumshoe/Models/ActivityModel.dart';
import 'package:gumshoe/Screens/CreateActivityScreen.dart';

class MyActivitiesScreen extends StatefulWidget {
  final String uid;

  const MyActivitiesScreen(this.uid, {Key? key}) : super(key: key);

  @override
  State<MyActivitiesScreen> createState() => _MyActivitiesScreenState();
}

class _MyActivitiesScreenState extends State<MyActivitiesScreen> {
  List<ActivityModel> allActivities = [];
  List<ActivityModel> myActivities = [];
  final databaseReference =
      FirebaseDatabase.instance.reference().child("Activities");
  final formKey = GlobalKey<FormState>();
  TextEditingController activityName = TextEditingController();
  TextEditingController activityPassword = TextEditingController();
  late String name, password;

  @override
  void initState() {
    getAllActivities();
    // final databaseReference =
    //     FirebaseDatabase.instance.reference().child("Activities");
    // databaseReference.get().then((event) {
    //   for (final entity in event.children) {
    //     String name = entity.child("name").value.toString();
    //     String manager = entity.child("manager").value.toString();
    //     String id = entity.child("id").value.toString();
    //     String password = entity.child("password").value.toString();
    //     ActivityModel activitymodel = ActivityModel(
    //         name: name, manager: manager, password: password, id: id);
    //     allActivities.add(activitymodel);
    //     print(allActivities.length);
    //   }
    //   myActivities = getMyActivities(allActivities);
    //
    // });
  }
  getAllActivities()async{
    final databaseReference =await
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
      myActivities = getMyActivities(allActivities);

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Activities'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateActivityScreen(widget.uid)));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: myActivities.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var currentItem = myActivities[index];
            if(myActivities.length==0||myActivities.length==null){
              return Container(
                margin: EdgeInsets.only(top: 12),
                child: Text('You have no active activities'),
              );
            }
            else
            return Container(
              width: double.infinity,
              height: 170,
              padding: new EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                elevation: 10,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.location_city, size: 40),
                      title: Text(currentItem.name,
                          style: TextStyle(fontSize: 24.0)),
                      subtitle: Text("Members : 0",
                          style: TextStyle(fontSize: 15.0)),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => new CupertinoAlertDialog(
                                title: new Text("Are you Sure",style: TextStyle(fontSize: 19,color: Colors.black)),
                                content: new Text("You want to Delete."),
                                actions: [
                                  CupertinoDialogAction(isDefaultAction: true,
                                      onPressed: ()
                                      {Navigator.pop(context);}, child: new Text("Close")),


                                  CupertinoDialogAction(isDefaultAction: true,
                                      onPressed: ()
                                      {
                                        Fluttertoast.showToast(
                                            msg:
                                            "Deleted Successfully.");
                                        Navigator.pop(context);
                                        myActivities.removeAt(index);

                                        databaseReference
                                            .child(myActivities[index].id).remove();


                                      }, child: new Text("Delete"))
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {
                            /* ... */
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    //this right here
                                    child: Container(
                                      height: 240,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Form(
                                          key: formKey,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text('Activity id: ' +
                                                    currentItem.id),
                                                margin:
                                                    EdgeInsets.only(left: 12),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 12),
                                                child: TextFormField(
                                                  validator: (activityName) {
                                                    if (activityName!
                                                            .isEmpty ||
                                                        activityName ==
                                                            null) {
                                                      return "Name required";
                                                    } else {
                                                      name = activityName;
                                                      return null;
                                                    }
                                                  },
                                                  initialValue:
                                                      currentItem.name,
                                                  textAlign: TextAlign.right,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'Activity Name',
                                                    fillColor:
                                                        Colors.grey.shade100,
                                                    filled: true,
                                                    border:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(10.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                validator:
                                                    (activityPassword) {
                                                  if (activityPassword!
                                                          .isEmpty ||
                                                      activityPassword ==
                                                          null) {
                                                    return "Password required";
                                                  } else {
                                                    password =
                                                        activityPassword;
                                                    return null;
                                                  }
                                                },
                                                initialValue:
                                                    currentItem.password,
                                                textAlign: TextAlign.right,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Activity Password',
                                                  fillColor:
                                                      Colors.grey.shade100,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context);
                                                      },
                                                      child: Text('Cancel')),
                                                  SizedBox(width: 10),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        if (formKey.currentState != null && formKey.currentState!.validate()) {
                                                          DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("Activities");

                                                          databaseReference.child(currentItem.id).child("name").set(name);
                                                          databaseReference.child(currentItem.id).child("password").set(password);
                                                          Fluttertoast.showToast(msg: "Updated Successfully");

                                                        } else
                                                          return;
                                                      },
                                                      child: Text("Update"))
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
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<ActivityModel> getMyActivities(List<ActivityModel> allActivities) {
    List<ActivityModel> myActivities = [];
    myActivities.clear();
    for (var activity in allActivities) {
      if (activity.manager == widget.uid) {
        myActivities.add(activity);
      }
    }
    return myActivities;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gumshoe/Screens/HomeScreen.dart';
import 'package:gumshoe/Screens/SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  var Email, Password;
  var longi,lati;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();


  @override
  void initState() {
    getPosition();
  }

  getPosition() async{
    Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lastLocation=await Geolocator.getLastKnownPosition();
    print(lastLocation);
    longi = position.longitude.toString();
    lati = position.latitude.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset("assets/images/logo.png"),
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    validator: (email) {
                      if (email!.isEmpty || email == null) {
                        return "Email required";
                      } else {
                        Email = email;
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: TextFormField(
                    validator: (password) {
                      if (password!.isEmpty || password == null) {
                        return "Password Required";
                      } else {
                        Password = password;
                        return null;
                      }
                    },
                    obscureText: true,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RaisedButton(
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                          color: Color(0xFF002d56),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          onPressed: () {
                            if (formkey.currentState != null &&
                                formkey.currentState!.validate()) {
                              SignInFunc(Email, Password);
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => HomeScreen("ABC")));
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'LOG IN',
                                style: TextStyle(color: Colors.white),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New Here?',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                      },
                      child: Text(
                        'Become a member now!',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SignInFunc(email, password) async {
    Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instance;
    final databaseReference =
    FirebaseDatabase.instance.reference().child("Users");
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      getPosition();
      (databaseReference.once().then((value) {
        if (value.snapshot.hasChild(user!.uid)) {

         String name = value.snapshot.child(user!.uid).child("Name").value.toString();
         Navigator.pushAndRemoveUntil<dynamic>(
           context,
           MaterialPageRoute<dynamic>(
             builder: (BuildContext context) => HomeScreen(user!.uid, name),
           ),
               (route) => false,
         );
        }
      }));
      databaseReference.child(user!.uid).child("Longitude").set(longi);
      databaseReference.child(user!.uid).child("Latitude").set(lati);


    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: "No user found for this email",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: "Wrong password provided for this user.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}

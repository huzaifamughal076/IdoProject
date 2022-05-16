import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gumshoe/External%20Widgets/Loading.dart';
import 'package:gumshoe/Screens/HomeScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var Email, Password, Name, C_Password, longi, lati;
  final formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController c_password = TextEditingController();
  bool viewVisible = false;
  var emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  void initState() {
    getPosition();
  }

  getPosition() async {
    Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    longi = position.longitude.toString();
    lati = position.latitude.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Container(
              child: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 400,
                    height: 200,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 60, 10, 0),
                    child: TextFormField(
                      validator: (name) {
                        if (name!.isEmpty || name == null) {
                          return "Please enter name";
                        } else {
                          Name = name;
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      validator: (email) {
                        if (email!.isEmpty || email == null) {
                          return "Enter Email";
                        } else if (!emailValid.hasMatch(email)) {
                          return "Email format is not valid";
                        } else {
                          Email = email;
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'Email',
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
                          return "Password required!";
                        } else if (password.length < 6) {
                          return "Password should be greater then 6 characters";
                        } else {
                          Password = password;
                          return null;
                        }
                      },
                      obscureText: true,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'Password',
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
                      validator: (c_password) {
                        if (c_password!.isEmpty || c_password == null) {
                          return "Enter password again";
                        } else if (c_password != Password) {
                          return "Passwords doesn't match";
                        } else {
                          C_Password = c_password;
                          return null;
                        }
                      },
                      obscureText: true,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              maximumSize: const Size(170.0, 90.0),
                              minimumSize: const Size(170.0, 60.0),
                              primary: Color(0xFF002d56),
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              if (formkey.currentState != null &&
                                  formkey.currentState!.validate()) {
                                SignUpFunc(Name, Email, Password);
                              } else
                                return;
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('REGISTER'),
                                Icon(
                                  Icons.content_paste_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    height: 2,
                    decoration: BoxDecoration(color: Colors.black26),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Login now!',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
          Positioned.fill(
              child: Visibility(
            visible: viewVisible,
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Align(alignment: Alignment.center, child: LoadingWidget()),
            ),
          )),
        ],
      ),
    ));
  }

  void showWidget() {
    setState(() {
      viewVisible = true;
    });
  }

  void hideWidget() {
    setState(() {
      viewVisible = false;
    });
  }

  Future<void> SignUpFunc(String name, String email, String password) async {
    showWidget();
    String errorMessage="";
    await Firebase.initializeApp();
    String currentTime = DateTime.now().toString();
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      getPosition();
      final databaseReference =
          FirebaseDatabase.instance.reference().child("Users");
      var userid = userCredential.user!.uid;
      await databaseReference.child(userid).child("Name").set(name);
      await databaseReference.child(userid).child("Email").set(email);
      await databaseReference.child(userid).child("Password").set(password);
      await databaseReference
          .child(userid)
          .child("Created at")
          .set(currentTime);
      await databaseReference.child(userid).child("Longitude").set(longi);
      await databaseReference.child(userid).child("Latitude").set(lati);
      hideWidget();
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => HomeScreen(userid, name),
        ),
        (route) => false, //if you want to disable back feature set to false
      );
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          hideWidget();
          Fluttertoast.showToast(
              msg: errorMessage,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case "ERROR_WRONG_PASSWORD":
          hideWidget();
          Fluttertoast.showToast(
              msg: "Password doesn't match requirements",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case "ERROR_USER_DISABLED":
          hideWidget();
          Fluttertoast.showToast(
              msg: "Provided email has been disabled. Contact support for more.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          hideWidget();
          Fluttertoast.showToast(
              msg: "Too many requests. Try again later",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          hideWidget();
          Fluttertoast.showToast(
              msg: "Error operation not allowed",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case "email-already-in-use":
          hideWidget();
          Fluttertoast.showToast(
              msg: "Email already in use",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        default:
          print(error);
          errorMessage = "An undefined Error happened.";
          hideWidget();
          Fluttertoast.showToast(
              msg: errorMessage,
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

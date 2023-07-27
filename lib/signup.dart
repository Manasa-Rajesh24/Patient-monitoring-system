import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:trackapp/home.dart';
import 'package:trackapp/model/usermodel.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final guardiannamecontroller = new TextEditingController();
  final patientnamecontroller = new TextEditingController();
  final emailcontroller = new TextEditingController();
  final passwordcontroller = new TextEditingController();
  final confirmpasswordcontroller = new TextEditingController();

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg.jpeg'), fit: BoxFit.cover)),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, top: 20),
                  child: Text('Create an Account',
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 33,
                          fontWeight: FontWeight.w700)),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 80,
                        right: 80,
                        top: MediaQuery.of(context).size.height * 0.05),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            autofocus: false,
                            controller: guardiannamecontroller,
                            keyboardType: TextInputType.name,
                            onSaved: (value) {
                              guardiannamecontroller.text = value!;
                            },
                            validator: (value) {
                              RegExp regex = new RegExp(r'^.{3,}$');
                              if (value!.isEmpty) {
                                return ("Name cannot be Empty");
                              }
                              if (!regex.hasMatch(value)) {
                                return ("Enter valid name(Min. 3 Character)");
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                fillColor: Colors.white30,
                                filled: true,
                                hintText: 'Guardian`s Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            autofocus: false,
                            controller: patientnamecontroller,
                            keyboardType: TextInputType.name,
                            onSaved: (value) {
                              patientnamecontroller.text = value!;
                            },
                            validator: (value) {
                              RegExp regex = new RegExp(r'^.{3,}$');
                              if (value!.isEmpty) {
                                return ("Name cannot be Empty");
                              }
                              if (!regex.hasMatch(value)) {
                                return ("Enter valid name(Min. 3 Character)");
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                fillColor: Colors.white30,
                                filled: true,
                                hintText: 'Patient`s Name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            autofocus: false,
                            controller: emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              emailcontroller.text = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Please Enter Your Email");
                              }
                              if (!RegExp(
                                      "^[a-zA-Z0-9+.-]+@[a-zA-Z0-9+.-]+.[a-z]")
                                  .hasMatch(value)) {
                                return ("Please Enter a valid email");
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                fillColor: Colors.white30,
                                filled: true,
                                hintText: 'Email',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            autofocus: false,
                            controller: passwordcontroller,
                            onSaved: (value) {
                              passwordcontroller.text = value!;
                            },
                            validator: (value) {
                              RegExp regex = new RegExp(r'^.{6,}$');
                              if (value!.isEmpty) {
                                return ("Please Enter Your Password");
                              }
                              if (!regex.hasMatch(value)) {
                                return ("Invalid Password(Min. 6 Character)");
                              }
                            },
                            textInputAction: TextInputAction.next,
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.white30,
                                filled: true,
                                hintText: 'Password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            autofocus: false,
                            controller: confirmpasswordcontroller,
                            onSaved: (value) {
                              confirmpasswordcontroller.text = value!;
                            },
                            //validator: ,
                            validator: (value) {
                              if (passwordcontroller.text!=confirmpasswordcontroller.text) {
                                return "Password donot match";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.white30,
                                filled: true,
                                hintText: 'Confirm Password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 50,
                            width: 250,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 70, 74, 85),
                                borderRadius: BorderRadius.circular(20)),
                            child: MaterialButton(
                              onPressed: () {
                                signUp(emailcontroller.text,
                                    passwordcontroller.text);
                                //Navigator.pop(context);
                                //Navigator.pushNamed(context, '/home');
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailstoFirebase()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailstoFirebase() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.guardianname = guardiannamecontroller.text;
    userModel.patientname = patientnamecontroller.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");

    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }
}

// enum Choice { Guardian, Patient }

// Future<Choice?> _asyncSimpleDialog(BuildContext context) async {
//   return await showDialog<Choice>(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: const Text('Select Option '),
//           children: <Widget>[
//             SimpleDialogOption(
//               onPressed: () {
//                 Navigator.pop(context, Choice.Guardian);
//               },
//               child: const Text('Guardian'),
//             ),
//             SimpleDialogOption(
//               onPressed: () {
//                 Navigator.pop(context, Choice.Patient);
//               },
//               child: const Text('Patient'),
//             ),
//           ],
//         );
//       });
      
// }

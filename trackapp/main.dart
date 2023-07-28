//import 'dart:js';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackapp/guardian.dart';
import 'package:trackapp/home.dart';
import 'package:trackapp/login.dart';
import 'package:trackapp/reminder/reminder.dart';
import 'package:trackapp/reminder/setreminder.dart';
import 'package:trackapp/reminderpage.dart';
import 'package:trackapp/signup.dart';
import 'package:trackapp/patienthome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const Login(),
      '/signup': (context) => const Signup(),
      '/home': (context) => const Home(),
      '/patienthome': (context) => const PatientHome(),
      '/guardianhome': (context) => const GuardianHome(),   
      '/reminder': (context) => const Reminder(),
      '/reminderpage': (context) => ReminderPage(),
      '/newentry': (context) => const NewEntry(),
    },
  ));
}

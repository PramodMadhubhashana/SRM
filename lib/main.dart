import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:srm/Nonacadamic/nonAcadamicHomePage.dart';
import 'package:srm/admin/add_lec_halle.dart';
import 'package:srm/admin/add_lectures.dart';
import 'package:srm/admin/add_non_acdamic_starff.dart';
import 'package:srm/admin/add_requiqment.dart';
import 'package:srm/admin/admin_page.dart';
import 'package:srm/admin/lecturesList.dart';
import 'package:srm/admin/reportview.dart';

import 'package:srm/admin/studentList.dart';
import 'package:srm/lectures/lecturehomepage.dart';
import 'package:srm/pages/book_equiqment.dart';
import 'package:srm/pages/book_lec_hall.dart';
import 'package:srm/pages/msg.dart';
import 'package:srm/pages/profile.dart';
import 'package:srm/pages/report.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/pages/view_shedule.dart';
import 'package:srm/sign_in&up/sign_in.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/sign_in&up/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBWa0VsMo1xkTqbF8S6_TSR2Z0CPsGTU7c",
      appId: "1:372156086540:web:284cc7b61059d028693129",
      messagingSenderId: "G-NFM3MHBXGP",
      projectId: "srm-d63d9",
      storageBucket: "srm-d63d9.appspot.com",
      measurementId: "G-NFM3MHBXGP",
      authDomain: "srm-d63d9.firebaseapp.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SRM',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Appcolors.primaryTextColor),
        useMaterial3: true,
      ),
      home: const SignIn(),
    );
  }
}

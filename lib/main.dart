import 'package:flutter/material.dart';
import 'package:srm/admin/add_lec_halle.dart';
import 'package:srm/admin/admin_page.dart';
import 'package:srm/admin/request.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/book_equiqment.dart';
import 'package:srm/pages/book_lec_hall.dart';
import 'package:srm/pages/homepage.dart';
import 'package:srm/pages/msg.dart';
import 'package:srm/pages/notifications.dart';
import 'package:srm/pages/profile.dart';
import 'package:srm/pages/report.dart';
import 'package:srm/pages/view_shedule.dart';
import 'package:srm/sign_in&up/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SRM',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Appcolors.primaryTextColor),
        useMaterial3: true,
      ),
      home: const Report(),
    );
  }
}

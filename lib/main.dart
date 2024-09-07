import 'package:flutter/material.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/sign_in&up/sign_in.dart';
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
      home: const SignUp(),
    );
  }
}

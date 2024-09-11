import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:srm/color/appcolors.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth > 600 ? 600 : 350,
                    height: 480,
                    constraints: BoxConstraints(
                      maxWidth: screenWidth > 600 ? 600 : 350,
                      maxHeight: 480,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 40,
                            right: 40,
                            bottom: 20,
                          ),
                          child: Column(
                            children: [
                              Text(
                                "SRM",
                                style: TextStyle(
                                    color: Appcolors.primaryTextColor,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Sign In",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Enter Your Student ID",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Appcolors.primaryTextColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Enter Your Password",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Appcolors.primaryTextColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: null, // fogrt password
                                  child: Text(
                                    "Forgot password?",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Appcolors.primaryTextColor,
                                ).copyWith(
                                  elevation: ButtonStyleButton.allOrNull(5),
                                ),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {},
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Don't have an account, Register >>",
                                  style: TextStyle(
                                    color: Appcolors.primaryTextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

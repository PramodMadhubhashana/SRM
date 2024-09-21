import 'package:flutter/material.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/homepage.dart';
import 'package:srm/service/service.dart';
import 'package:srm/sign_in&up/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> _signIn() async {
    String userId = _idController.text.trim();
    String password = _passwordController.text.trim();

    if (userId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter the both Id & Password",
            style: TextStyle(
              fontSize: 16,
              color: Colors.redAccent,
            ),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    Map<String, dynamic> role =
        await _authService.signInWithIdAndPassword(userId, password);

    Navigator.of(context).pop();

    if (role['role'] != Null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sign In Succesfull.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.greenAccent,
            ),
          ),
        ),
      );

      switch (role['role']) {
        case 'Student':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Homepage(
                stId: role['id'],
              ),
            ),
          );
          break;
        default:
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Sign In Faild.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.redAccent,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenSize.width > 600 ? 600 : 350,
                    height: 480,
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
                              SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: _idController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: "Enter Your ID",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Appcolors.primaryTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextField(
                                  controller: _passwordController,
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
                                onPressed: _signIn,
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUp(),
                                    ),
                                  );
                                },
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

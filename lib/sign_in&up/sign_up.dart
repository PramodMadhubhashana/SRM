import 'package:flutter/material.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/term_conditions/terms_conditions.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final PageController _pageController = PageController();
  int currentpage = 0;
  bool _isChecked = false;
  void nextpage() {
    setState(() {
      currentpage += 1;
    });
    _pageController.nextPage(
        duration: const Duration(microseconds: 500), curve: Curves.easeIn);
  }

  void previousPage() {
    setState(() {
      currentpage -= 1;
    });
    _pageController.previousPage(
        duration: const Duration(microseconds: 500), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const int pages = 3;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: screenWidth > 600 ? 600 : 350,
              height: 480,
              constraints: BoxConstraints(
                maxWidth: screenWidth > 600 ? 600 : 350,
                maxHeight: screenWidth > 600 ? 550 : 550,
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
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                      left: 30,
                      right: 30,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome - SRM ",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Appcolors.primaryTextColor,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          "asset/images/wood.jpg",
                          width: 500,
                          height: 200,
                          fit: BoxFit.fitWidth,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: nextpage, // onpress Event
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Next",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Appcolors.primaryTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                ">>",
                                style: TextStyle(
                                    color: Appcolors.primaryTextColor,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 36),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                      left: 30,
                      right: 30,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Welcome - SRM ",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Appcolors.primaryTextColor,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        LinearProgressIndicator(
                          color: Appcolors.primaryTextColor,
                          backgroundColor: Colors.grey,
                          value: (currentpage + 1) / pages,
                        ),
                        const SizedBox(
                          height: 25,
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
                            labelText: "Enter Your First Name",
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
                            labelText: "Enter Your Last Name",
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
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Enter Your Email",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: previousPage, // onpress Event
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "<<",
                                    style: TextStyle(
                                        color: Appcolors.primaryTextColor,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 30),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Prevois",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Appcolors.primaryTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: nextpage, // onpress Event
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Next",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Appcolors.primaryTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    ">>",
                                    style: TextStyle(
                                        color: Appcolors.primaryTextColor,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 30),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                      left: 30,
                      right: 30,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Welcome - SRM ",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Appcolors.primaryTextColor,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        LinearProgressIndicator(
                          color: Appcolors.primaryTextColor,
                          backgroundColor: Colors.grey,
                          value: (currentpage + 1) / pages,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Enter Your Address",
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
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Enter Your Phone No",
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
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value ?? false;
                                });
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "I agree the ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TermsConditions(),
                                  ),
                                );
                              },
                              child: Text(
                                "Term & Conditions",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Appcolors.primaryTextColor),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 25,
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
                            'Register',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: previousPage, // onpress Event
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "<<",
                                    style: TextStyle(
                                        color: Appcolors.primaryTextColor,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 30),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Prevois",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Appcolors.primaryTextColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

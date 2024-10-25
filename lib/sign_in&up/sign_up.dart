import 'package:flutter/material.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/homepage.dart';
import 'package:srm/service/service.dart';
import 'package:srm/sign_in&up/sign_in.dart';
import 'package:srm/term_conditions/terms_conditions.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:srm/color/appcolors.dart';

import 'package:srm/service/service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final PageController _pageController = PageController();
  // textfeild controllers
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _image;
  Uint8List? _webImage;
  final ImagePicker _imagePicker = ImagePicker();
  final AuthService _authService = AuthService();
  dynamic files;

  Future<void> studentData() async {
    String stId = _studentIdController.text.trim();
    String fNme = _firstNameController.text.trim();
    String lNme = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String address = _addressController.text.trim();
    String pNo = _phoneNoController.text.trim();
    String psd = _passwordController.text.trim();

    if (stId.isEmpty ||
        fNme.isEmpty ||
        lNme.isEmpty ||
        email.isEmpty ||
        address.isEmpty ||
        psd.isEmpty ||
        pNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill the all details",
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 16,
            ),
          ),
        ),
      );
      return;
    }
    if (_isChecked == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please accept the Term and Conditions.",
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 16,
            ),
          ),
        ),
      );
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    String url = await uploadImge(files);
    if (url != 'Fail') {
      String result = await _authService.addData(
          stId, fNme, lNme, email, address, pNo, psd, 'Student', url);

      Navigator.of(context).pop();

      if (result == 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Register Succesfull.",
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 16,
              ),
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(
              stId: stId,
            ),
          ),
        );
        return;
      }
      if (result == 'Fail') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Register Fail.",
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 16,
              ),
            ),
          ),
        );
        return;
      }
      if (result == 'available') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Already Registered",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 16,
              ),
            ),
          ),
        );
        return;
      }
      return;
    }
    Navigator.of(context).pop();
    if (url == 'Fail') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Imge Upload Fail Try Again.",
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 16,
            ),
          ),
        ),
      );
      return;
    }
  }

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

  Future<void> _pickImage() async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        setState(() {
          _webImage = result.files.first.bytes;
          files = file;
        });
      }
    } else {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path); // Store image as File for mobile
          files = pickedFile;
        });
      }
    }
  }

  Future<String> uploadImge(dynamic file) async {
    if (file != null) {
      try {
        String url = await _authService.addStudentImage(file);
        return url;
      } catch (e) {
        return 'Fail';
      }
    }
    return 'Fail';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const int pages = 3;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Container(
              width: screenWidth > 600 ? 600 : 350,
              constraints: BoxConstraints(
                maxWidth: screenWidth > 600 ? 600 : 350,
                maxHeight: screenWidth > 600 ? 600 : 550,
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
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignIn(),
                              ),
                            );
                          },
                          child: Text(
                            "Have an account, Login >>",
                            style: TextStyle(
                              color: Appcolors.primaryTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
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
                      top: 80,
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
                          controller: _studentIdController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Student ID",
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
                          controller: _firstNameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "First Name",
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
                          controller: _lastNameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Last Name",
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
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
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
                          controller: _addressController,
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(
                            labelText: "Address",
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
                          controller: _phoneNoController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Phone No",
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
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            labelText: "Password",
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: _pickImage,
                              child: const Text(
                                "Pick Image ",
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            if (!kIsWeb && _image != null)
                              Image.file(
                                _image!,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              )
                            else if (kIsWeb && _webImage != null)
                              Image.memory(
                                _webImage!,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              )
                            else
                              const Text("No Image Selected"),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
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
                            ),
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
                          onPressed: studentData,
                          child: const Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
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

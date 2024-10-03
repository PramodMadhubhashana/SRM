import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/service/service.dart';

class Addadmin extends StatefulWidget {
  final String id;
  const Addadmin({super.key, required this.id});

  @override
  State<Addadmin> createState() => _AddadminState();
}

class _AddadminState extends State<Addadmin> {
  File? _image;
  Uint8List? _webImage;
  final ImagePicker _imagePicker = ImagePicker();
  final AuthService _authService = AuthService();
  final TextEditingController _lectureIdController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  dynamic files;

  Future<void> _addAdmin() async {
    String stId = _lectureIdController.text.trim();
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
          stId, fNme, lNme, email, address, pNo, psd, "Admin", url);

      Navigator.of(context).pop();

      if (result == 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Add successfull",
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 16,
              ),
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
                color: Colors.redAccent,
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
        String url = await _authService.addAdminImage(file);
        return url;
      } catch (e) {
        return 'Fail';
      }
    }
    return 'Fail';
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (screenSize.width > 600)
              SizedBox(
                height: screenSize.height,
                width: 300,
                child: Sidebar(id: widget.id),
              ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Register Admin",
                            style: TextStyle(
                              fontSize: 20,
                              color: Appcolors.primaryTextColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 50,
                            width: 350,
                            child: TextField(
                              controller: _lectureIdController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Lecture Id",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Appcolors.primaryTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            width: 350,
                            child: TextField(
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
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            width: 350,
                            child: TextField(
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
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            width: 350,
                            child: TextField(
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
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            width: 350,
                            child: TextField(
                              controller: _addressController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Address",
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
                            height: 50,
                            width: 350,
                            child: TextField(
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
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 50,
                            width: 350,
                            child: TextField(
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
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (!kIsWeb && _image != null)
                            Image.file(
                              _image!,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            )
                          else if (kIsWeb && _webImage != null)
                            Image.memory(
                              _webImage!,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            )
                          else
                            const Text("No Image Selected"),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: const Text(
                              "Pick Image ",
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: _addAdmin,
                            child: const Text(
                              "Add",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

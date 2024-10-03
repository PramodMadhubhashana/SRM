import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/service/service.dart';

class AddRequiqment extends StatefulWidget {
  final String id;
  const AddRequiqment({super.key, required this.id});

  @override
  State<AddRequiqment> createState() => _AddRequiqmentState();
}

class _AddRequiqmentState extends State<AddRequiqment> {
  File? _image;
  Uint8List? _webImage;
  final ImagePicker _imagePicker = ImagePicker();
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  dynamic files;

  Future<void> _addEquiqment() async {
    String name = _nameController.text.trim();
    String qty = _quantityController.text.trim();

    if (name.isEmpty || qty.isEmpty) {
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
      String result = await _authService.addEquiqment(name, qty, url);

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
              "Add Fail.",
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
        String url = await _authService.addEquqmentImage(file);
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
                child: Sidebar(
                  id: widget.id,
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add Equiqment",
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
                              controller: _nameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Equiqment Name",
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
                              controller: _quantityController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Quantity",
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
                            onPressed: _addEquiqment,
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

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/service/service.dart';

class AddLecHalle extends StatefulWidget {
  final String id;
  const AddLecHalle({super.key, required this.id});

  @override
  State<AddLecHalle> createState() => _AddLecHalleState();
}

class _AddLecHalleState extends State<AddLecHalle> {
  File? _image;
  Uint8List? _webImage;
  final ImagePicker _imagePicker = ImagePicker();
  final AuthService _authService = AuthService();
  final TextEditingController _halleNameController = TextEditingController();
  final TextEditingController _computersControlller = TextEditingController();
  final TextEditingController _chairsControllers = TextEditingController();
  final TextEditingController _deskControlller = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  dynamic files;

  Future<void> _addLecHalls() async {
    String name = _halleNameController.text.trim();
    String computers = _computersControlller.text.trim();
    String chairs = _chairsControllers.text.trim();
    String desk = _deskControlller.text.trim();
    String capacity = _capacityController.text.trim();

    if (name.isEmpty ||
        computers.isEmpty ||
        chairs.isEmpty ||
        desk.isEmpty ||
        capacity.isEmpty) {
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
      setState(() {
        _halleNameController.clear();
        _computersControlller.clear();
        _chairsControllers.clear();
        _deskControlller.clear();
        _capacityController.clear();
      });
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
      String? result = await _authService.addHalle(
          name, computers, chairs, desk, capacity, url);
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
        String url = await _authService.addLecHalleImage(file);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add Lec Halle",
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
                              controller: _halleNameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Halle Name",
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
                              controller: _chairsControllers,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "No of Chairs",
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
                              controller: _deskControlller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "NO Of Desk",
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
                              controller: _computersControlller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "NO Of Computers",
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
                              controller: _capacityController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Capacity",
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
                            onPressed: _addLecHalls,
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

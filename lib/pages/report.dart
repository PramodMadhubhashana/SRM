import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/sidebar.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String? _selectedItem;
  final List<String> _dropdownItems = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

  File? _image;
  Uint8List? _webImage;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage() async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        setState(() {
          _webImage = result.files.first.bytes;
        });
      }
    } else {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (screenSize.width > 600)
              SizedBox(
                height: screenSize.height,
                width: 300,
                child: const Sidebar(),
              ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Report",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Appcolors.primaryTextColor,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        "Category",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      DropdownButton(
                        elevation: 16,
                        dropdownColor: Colors.blue[50],
                        underline: Container(
                          height: 2,
                          color: Colors.blue, // Color of the underline
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        value: _selectedItem,
                        hint: const Text("select Issue"),
                        icon: const Icon(Icons.arrow_downward),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
                          });
                        },
                        items: _dropdownItems.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Message",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 200,
                        width: 350,
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 1,
                          decoration: InputDecoration(
                            labelText: "Message",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Appcolors.primaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        "Upload Image",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Appcolors.primaryTextColor,
                        ),
                        child: const Text(
                          "Submit Issue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

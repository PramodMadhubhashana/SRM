import 'package:flutter/material.dart';

import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/sidebar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

final TextEditingController _newNameController = TextEditingController();
final TextEditingController _newEmailController = TextEditingController();
final TextEditingController _newLocationController = TextEditingController();
final TextEditingController _newPhoneNoController = TextEditingController();

class _ProfileState extends State<Profile> {
  final PageController _pageController = PageController();

  get curve => null;
  void _nextPage() {
    setState(() {});
    _pageController.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  void _prevoiusPage() {
    setState(() {});
    _pageController.previousPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
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
                width: 300,
                height: screenSize.height,
                child: Sidebar(),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              print("eeee");
                            },
                            child: ClipOval(
                              child: Image.network(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXNHDqxmIYwry1G1NuywsgYUaxJINUmx8trA&s",
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.male);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          const Column(
                            children: [
                              Text(
                                "Hello, name",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Role : Student",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runAlignment: WrapAlignment.spaceBetween,
                        spacing: 1.0,
                        runSpacing: 1.0,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 460,
                                width: screenSize.width > 600
                                    ? screenSize.width / 2
                                    : screenSize.width * 0.8,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
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
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          _profileDetails(
                                            Icons.person,
                                            "Your Full Name",
                                            "Pramod",
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          _profileDetails(
                                            Icons.card_membership_sharp,
                                            "Your Student ID",
                                            "ADDD364",
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          _profileDetails(
                                            Icons.email,
                                            "Your Email",
                                            "email",
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          _profileDetails(
                                            Icons.location_pin,
                                            "Your Address",
                                            "Address",
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          _profileDetails(
                                            Icons.phone_sharp,
                                            "Your Phone NO",
                                            "0712839087",
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (screenSize.width < 600) {
                                                _showBottomPanel(context);
                                              } else {
                                                _nextPage();
                                              }
                                            },
                                            child: Text(
                                              "Edit",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600,
                                                  color: Appcolors
                                                      .primaryTextColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          _profileDetailsEdite(
                                            Icons.person,
                                            "Enter Your New Name",
                                            _newNameController,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          _profileDetailsEdite(
                                            Icons.email,
                                            "Enter Your New Email",
                                            _newEmailController,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          _profileDetailsEdite(
                                            Icons.location_pin,
                                            "Enter Your New Address",
                                            _newLocationController,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          _profileDetailsEdite(
                                            Icons.phone,
                                            "Enter Your New Phone No",
                                            _newPhoneNoController,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 60,
                                              right: 60,
                                              top: 60,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: _prevoiusPage,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 255, 140, 140),
                                                  ),
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: Appcolors
                                                          .primaryTextColor),
                                                  child: const Text(
                                                    "Save",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white),
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
                            ],
                          ),
                        ],
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

void _showBottomPanel(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
      top: Radius.circular(20),
    )),
    isScrollControlled: false,
    builder: (BuildContext context) {
      final screenSize = MediaQuery.of(context).size;
      return SizedBox(
        height: 800,
        width: screenSize.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
          child: Column(
            children: [
              _profileDetailsEdite(
                Icons.person,
                "Enter Your New Name",
                _newNameController,
              ),
              const SizedBox(
                height: 20,
              ),
              _profileDetailsEdite(
                Icons.email,
                "Enter Your New Email",
                _newEmailController,
              ),
              const SizedBox(
                height: 20,
              ),
              _profileDetailsEdite(
                Icons.location_pin,
                "Enter Your New Adddress",
                _newLocationController,
              ),
              const SizedBox(
                height: 20,
              ),
              _profileDetailsEdite(
                Icons.phone,
                "Enter Your New Phone NO",
                _newPhoneNoController,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Appcolors.primaryTextColor),
                  ))
            ],
          ),
        ),
      );
    },
  );
}

Widget _profileDetailsEdite(
    IconData icn, String lable, TextEditingController controller) {
  return Row(
    children: [
      Icon(
        icn,
        size: 30,
      ),
      const SizedBox(
        width: 15,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: lable,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Appcolors.primaryTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ],
  );
}

Widget _profileDetails(IconData icn, String lable, String value) {
  return Row(
    children: [
      Icon(
        icn,
        size: 30,
      ),
      const SizedBox(
        width: 15,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lable,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          )
        ],
      )
    ],
  );
}

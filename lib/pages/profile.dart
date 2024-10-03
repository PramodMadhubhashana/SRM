import 'package:flutter/material.dart';

import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/service/service.dart';

class Profile extends StatefulWidget {
  final String id;
  const Profile({super.key, required this.id});

  @override
  State<Profile> createState() => _ProfileState();
}

final TextEditingController _newFirstNameController = TextEditingController();
final TextEditingController _newLastNameController = TextEditingController();
final TextEditingController _newEmailController = TextEditingController();
final TextEditingController _newLocationController = TextEditingController();
final TextEditingController _newPhoneNoController = TextEditingController();

class _ProfileState extends State<Profile> {
  final PageController _pageController = PageController();
  final AuthService _authService = AuthService();
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isUpdating = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var data = await _authService.getUsersData(widget.id);
    if (data != null) {
      setState(() {
        userData = data.data() as Map<String, dynamic>;
        _newFirstNameController.text = userData?['First Name'] ?? '';
        _newLastNameController.text = userData?['Last Name'] ?? '';
        _newEmailController.text = userData?['Email'] ?? '';
        _newLocationController.text = userData?['Address'] ?? '';
        _newPhoneNoController.text = userData?['Phone No'] ?? '';

        isLoading = false;
      });
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Data Loading is Fail, Try again.",
          style: TextStyle(color: Colors.redAccent, fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    setState(() {
      isUpdating = true;
    });
    String result = await _authService.UpdateeProfile(
      widget.id,
      _newFirstNameController.text.trim(),
      _newLastNameController.text.trim(),
      _newEmailController.text.trim(),
      _newLocationController.text.trim(),
      _newPhoneNoController.text.trim(),
    );

    setState(() {
      isUpdating = false;
    });

    if (result == 'Success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Update Succesfull.",
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 16,
            ),
          ),
        ),
      );
      _loadUserData();
      _prevoiusPage();
      return;
    }
    if (result == 'User not found') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "User not found.",
            style: TextStyle(
              color: Colors.redAccent,
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
            "Update Fail.",
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (screenSize.width > 600)
                    SizedBox(
                      width: 300,
                      height: screenSize.height,
                      child: Sidebar(id: widget.id),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 30,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: ClipOval(
                                    child: userData!['img'] != null
                                        ? Image.network(
                                            userData!['img'],
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.fitWidth,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            (loadingProgress
                                                                    .expectedTotalBytes
                                                                as double)
                                                        : null,
                                                  ),
                                                );
                                              }
                                            },
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return const Icon(
                                                Icons.error,
                                                size: 20,
                                                color: Colors.red,
                                              );
                                            },
                                          )
                                        : const Icon(
                                            Icons.account_circle,
                                            size: 20,
                                          ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "${userData?['First Name'] ?? 'User'}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Role : ${userData?['role'] ?? 'User'}",
                                      style: const TextStyle(fontSize: 16),
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              children: [
                                                _profileDetails(
                                                  Icons.person,
                                                  "Your Full Name",
                                                  "${userData?['First Name'] ?? "First Name"} ${userData?['Last Name'] ?? 'Last Name'}",
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                _profileDetails(
                                                  Icons.card_membership_sharp,
                                                  "Your Student ID",
                                                  "${userData?['Id'] ?? "00000"}",
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                _profileDetails(
                                                  Icons.email,
                                                  "email",
                                                  "${userData?['Email'] ?? "example@gmail.com"}",
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                _profileDetails(
                                                  Icons.location_pin,
                                                  "Address",
                                                  "${userData?['Address'] ?? "...."}",
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                _profileDetails(
                                                  Icons.phone_sharp,
                                                  "${userData?["Phone No"] ?? '....'}",
                                                  "0712839087",
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    if (screenSize.width <
                                                        600) {
                                                      _showBottomPanel(context);
                                                    } else {
                                                      _nextPage();
                                                    }
                                                  },
                                                  child: Text(
                                                    "Edit",
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                  "Enter Your First Name",
                                                  _newFirstNameController,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                _profileDetailsEdite(
                                                  Icons.person,
                                                  "Enter Your Last Name",
                                                  _newLastNameController,
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                        onPressed:
                                                            _prevoiusPage,
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  255,
                                                                  140,
                                                                  140),
                                                        ),
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed:
                                                            _updateProfile,
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Appcolors
                                                                        .primaryTextColor),
                                                        child: isUpdating
                                                            ? const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              )
                                                            : const Text(
                                                                "Save",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .white),
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
                "Enter Your First Name",
                _newFirstNameController,
              ),
              const SizedBox(
                height: 20,
              ),
              _profileDetailsEdite(
                Icons.person,
                "Enter Your Last Name",
                _newLastNameController,
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
                ),
              ),
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

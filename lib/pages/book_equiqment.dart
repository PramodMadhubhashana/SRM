import 'package:flutter/material.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/sidebar.dart';

class BookEquiqment extends StatefulWidget {
  const BookEquiqment({super.key});

  @override
  State<BookEquiqment> createState() => _BookEquiqmentState();
}

enum BookingPeriod { morning, evening, fullDay }

class _BookEquiqmentState extends State<BookEquiqment> {
  BookingPeriod? _selectPeriod;
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
                child: const Sidebar(),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Request Equiqment",
                      style: TextStyle(
                        fontSize: 24,
                        color: Appcolors.primaryTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: const ScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 7,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Equiqment ${index + 1}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      if (constraints.maxWidth < 600) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Column(
                                                  children: _image(),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: _radiobutton(),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: _list(),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: _image(),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: _radiobutton(),
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                Column(
                                                  children: _list(),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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

  List<Widget> _list() {
    return [
      const Text("Available Quantity : "),
      const SizedBox(
        height: 20,
        width: 20,
      ),
      SizedBox(
        height: 50,
        width: 150,
        child: TextField(
          keyboardType: TextInputType.number,
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
        height: 10,
      ),
      ElevatedButton(onPressed: () {}, child: const Text("Request"))
    ];
  }

  List<Widget> _image() {
    return [
      Image.asset(
        "asset/images/wood.jpg",
        width: 300,
        height: 300,
        fit: BoxFit.fitWidth,
      ),
    ];
  }

  List<Widget> _radiobutton() {
    return [
      SizedBox(
        width: 160,
        child: RadioListTile<BookingPeriod>(
          title: const Text('Morning'),
          value: BookingPeriod.morning,
          groupValue: _selectPeriod,
          onChanged: (BookingPeriod? value) {
            setState(() {
              _selectPeriod = value;
            });
          },
        ),
      ),
      SizedBox(
        width: 150,
        child: RadioListTile<BookingPeriod>(
          title: const Text('Evening'),
          value: BookingPeriod.evening,
          groupValue: _selectPeriod,
          onChanged: (BookingPeriod? value) {
            setState(() {
              _selectPeriod = value;
            });
          },
        ),
      ),
      SizedBox(
        width: 150,
        child: RadioListTile<BookingPeriod>(
          title: const Text('Full Day'),
          value: BookingPeriod.fullDay,
          groupValue: _selectPeriod,
          onChanged: (BookingPeriod? value) {
            setState(() {
              _selectPeriod = value;
            });
          },
        ),
      ),
    ];
  }
}

import 'package:flutter/material.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/service/service.dart';

class BookEquiqment extends StatefulWidget {
  final String id;
  const BookEquiqment({super.key, required this.id});

  @override
  State<BookEquiqment> createState() => _BookEquiqmentState();
}

enum BookingPeriod { morning, evening, fullDay }

class _BookEquiqmentState extends State<BookEquiqment> {
  Map<int, BookingPeriod?> _selectedPeriods = {};
  Map<int, String> docid = {};
  final AuthService _authService = AuthService();
  final TextEditingController _qtyController = TextEditingController();

  Future<void> _bookeequiqment(int index, String name) async {
    String qty = _qtyController.text.trim();
    if (_selectedPeriods[index] == null || qty.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Input quantity.",
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

    String? result = await _authService.bookEquiqment(
      int.parse(qty),
      _selectedPeriods[index] == BookingPeriod.morning
          ? 'morningqty'
          : _selectedPeriods[index] == BookingPeriod.evening
              ? 'eveningqty'
              : 'fullTimeqty',
      docid[index].toString(),
      _selectedPeriods[index].toString(),
    );

    String? actresult = await _authService.addActivity(
        "$name : ${_selectedPeriods[index]}", widget.id);
    await _authService.addNotification(
        widget.id, "Request : $name", "Request to $name, Quatity : $qty");
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
                      child: StreamBuilder(
                        stream: _authService.getEquiqmentDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text("Error fetching data"));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text("No Lec Equiqments"));
                          }
                          final equiqments = snapshot.data!;

                          return ListView.builder(
                            physics: const ScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            itemCount: equiqments.length,
                            itemBuilder: (context, index) {
                              final eqmt = equiqments[index];

                              docid[index] = eqmt['id'];

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        eqmt['Name'],
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
                                                      children:
                                                          _image(eqmt['img']),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          children:
                                                              _radiobutton(
                                                                  index),
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: _list(
                                                            eqmt['morningqty'],
                                                            eqmt['eveningqty'],
                                                            eqmt['qty'],
                                                            eqmt['fullTimeqty'],
                                                            index,
                                                            eqmt['Name'],
                                                          ),
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
                                                  children: _image(eqmt['img']),
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children:
                                                          _radiobutton(index),
                                                    ),
                                                    const SizedBox(
                                                      height: 30,
                                                    ),
                                                    Column(
                                                      children: _list(
                                                        eqmt['morningqty'],
                                                        eqmt['eveningqty'],
                                                        eqmt['qty'],
                                                        eqmt['fullTimeqty'],
                                                        index,
                                                        eqmt['Name'],
                                                      ),
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

  List<Widget> _list(
      int mqty, int eqty, int qty, int fqty, int index, String name) {
    return [
      Text("Available Morning : ${(qty - (mqty + eqty)) - mqty}"),
      Text("Available evening : ${(qty - (mqty + eqty)) - eqty}"),
      Text("Available Full day : ${(qty - (mqty + eqty)) - (mqty + eqty)}"),
      const SizedBox(
        height: 20,
        width: 20,
      ),
      SizedBox(
        height: 50,
        width: 150,
        child: TextField(
          controller: _qtyController,
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
      ElevatedButton(
          onPressed: () {
            _bookeequiqment(
              index,
              name,
            );
          },
          child: const Text("Request"))
    ];
  }

  List<Widget> _image(String img) {
    return [
      img.isNotEmpty && img != null
          ? Image.network(
              img,
              width: 300,
              height: 300,
              fit: BoxFit.fitWidth,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes as double)
                          : null,
                    ),
                  );
                }
              },
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const Icon(
                  Icons.error,
                  size: 20,
                  color: Colors.red,
                );
              },
            )
          : const Icon(
              Icons.account_circle, // Fallback icon or image
              size: 20,
            ),
    ];
  }

  List<Widget> _radiobutton(int index) {
    return [
      SizedBox(
        width: 160,
        child: RadioListTile<BookingPeriod>(
          title: const Text('Morning'),
          value: BookingPeriod.morning,
          onChanged: (BookingPeriod? value) {
            setState(() {
              _selectedPeriods[index] = value;
            });
          },
          groupValue: _selectedPeriods[index],
        ),
      ),
      SizedBox(
        width: 150,
        child: RadioListTile<BookingPeriod>(
          title: const Text('Evening'),
          value: BookingPeriod.evening,
          onChanged: (BookingPeriod? value) {
            setState(() {
              _selectedPeriods[index] = value;
            });
          },
          groupValue: _selectedPeriods[index],
        ),
      ),
      SizedBox(
        width: 150,
        child: RadioListTile<BookingPeriod>(
          title: const Text('Full Day'),
          value: BookingPeriod.fullDay,
          onChanged: (BookingPeriod? value) {
            setState(() {
              _selectedPeriods[index] = value;
            });
          },
          groupValue: _selectedPeriods[index],
        ),
      ),
    ];
  }
}

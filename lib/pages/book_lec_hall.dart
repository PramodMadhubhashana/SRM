import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/service/service.dart';
import 'package:table_calendar/table_calendar.dart';

class BookLecHall extends StatefulWidget {
  final String id;
  const BookLecHall({super.key, required this.id});

  @override
  State<BookLecHall> createState() => _BookLecHallState();
}

enum BookingPeriod { morning, evening, fullDay }

class _BookLecHallState extends State<BookLecHall> {
  DateTime _focusedDay = DateTime.now();
  Map<int, DateTime?> _selectedDay = {};
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<int, BookingPeriod?> _selectPeriod = {};
  final AuthService _authService = AuthService();
  Map<String, List<DateTime>> hallDatesMap = {};
  Map<String, Map<DateTime, String>> period = {};
  String? bkperiod;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBookedDates();
  }

  Future<void> fetchBookedDates() async {
    try {
      final QuerySnapshot snapshot = await _authService.bookDate();

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          if (data.containsKey('Booked Details')) {
            List<dynamic> bookedDetails = data['Booked Details'];
            for (var booking in bookedDetails) {
              if (booking.containsKey('hallId') &&
                  booking.containsKey('date') &&
                  booking.containsKey('period')) {
                String hallId = booking['hallId'];
                Timestamp timestamp = booking['date'];
                DateTime dateTime = timestamp.toDate();

                DateTime dateOnly =
                    DateTime(dateTime.year, dateTime.month, dateTime.day);
                String prd = booking['period'];

                if (!hallDatesMap.containsKey(hallId)) {
                  hallDatesMap[hallId] = [];
                }
                hallDatesMap[hallId]!.add(dateOnly);

                if (!period.containsKey(hallId)) {
                  period[hallId] = {};
                }
                period[hallId]![dateOnly] = prd;
              }
            }
          } else {
            return;
          }
        }
      }
    } catch (e) {
      return;
    }
  }

  void bookPeriod(DateTime date, String name) {
    DateTime dateTime = DateTime(date.year, date.month, date.day);

    if (period.containsKey(name) && period[name]!.containsKey(dateTime)) {
      String? bookinperiod = period[name]![dateTime]!;

      if (bookinperiod == "BookingPeriod.fullDay") {
        setState(() {
          bkperiod = 'full day';
          print(bkperiod);
        });
        return;
      }
      if (bookinperiod == 'BookingPeriod.evening') {
        setState(() {
          bkperiod = 'Evening';
        });
        return;
      }
      if (bookinperiod == 'BookingPeriod.morning') {
        setState(() {
          bkperiod = 'Morning';
        });
        return;
      }
    }
    return;
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Book Lecture Halls",
                        style: TextStyle(
                          fontSize: 24,
                          color: Appcolors.primaryTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      StreamBuilder<List<Map<String, dynamic>>>(
                        stream: _authService.getLectureHallDetails(),
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
                            return const Center(child: Text("No Lec Halls"));
                          }

                          final lechalls = snapshot.data!;
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: lechalls.length,
                            itemBuilder: (context, index) {
                              final lecHall = lechalls[index];

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
                                        "${lecHall['Halle Name'] ?? "Halle Name"}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          return constraints.maxWidth < 600
                                              ? Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: _buildChildrens(
                                                      index,
                                                      lecHall['Halle Name']),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: _buildChildrens(
                                                      index,
                                                      lecHall['Halle Name']),
                                                );
                                        },
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "No Of Chair: ${lecHall['chairs'] ?? "chairs"}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "No Of Desk: ${lecHall['Desk'] ?? "desk"}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Capacity: ${lecHall['capacity'] ?? 'capacity'}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "No Of Computers: ${lecHall['computers'] ?? 'com'}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Book Period : ${bkperiod ?? "No Booking"}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          return constraints.maxWidth > 600
                                              ? Row(
                                                  children:
                                                      _radioListTile(index))
                                              : Column(
                                                  children:
                                                      _radioListTile(index));
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final selectedDate =
                                              _selectedDay[index];

                                          if (selectedDate != null &&
                                              _selectPeriod != null) {
                                            try {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                              );
                                              final result = await _authService
                                                  .booklechalls(
                                                lecHall['Halle Name'],
                                                selectedDate,
                                                _selectPeriod[index].toString(),
                                                widget.id,
                                              );

                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Booked Successfull'),
                                                ),
                                              );
                                              await fetchBookedDates();
                                            } catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Booking failed: $e')),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Please select a date and period')),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Appcolors.primaryTextColor,
                                        ),
                                        child: const Text(
                                          "Book",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
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

  List<Widget> _radioListTile(int index) {
    return [
      SizedBox(
        width: 160,
        child: RadioListTile<BookingPeriod>(
          title: const Text('Morning'),
          value: BookingPeriod.morning,
          groupValue: _selectPeriod[index],
          onChanged: (BookingPeriod? value) {
            setState(() {
              _selectPeriod[index] = value!;
            });
          },
        ),
      ),
      SizedBox(
        width: 150,
        child: RadioListTile<BookingPeriod>(
          title: const Text('Evening'),
          value: BookingPeriod.evening,
          groupValue: _selectPeriod[index],
          onChanged: (BookingPeriod? value) {
            setState(() {
              _selectPeriod[index] = value!;
            });
          },
        ),
      ),
      SizedBox(
        width: 150,
        child: RadioListTile<BookingPeriod>(
          title: const Text('Full Day'),
          value: BookingPeriod.fullDay,
          groupValue: _selectPeriod[index],
          onChanged: (BookingPeriod? value) {
            setState(() {
              _selectPeriod[index] = value!;
            });
          },
        ),
      ),
    ];
  }

  List<Widget> _buildChildrens(int index, String hallname) {
    return [
      Image.asset(
        "asset/images/wood.jpg",
        width: 300,
        height: 300,
        fit: BoxFit.fitWidth,
      ),
      SizedBox(
        height: 400,
        width: 300,
        child: TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime(2000),
          lastDay: DateTime(2100),
          calendarFormat: _calendarFormat,
          availableCalendarFormats: const {
            CalendarFormat.month: '1 Month',
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              if (hallDatesMap.containsKey(hallname) &&
                  hallDatesMap[hallname] != null &&
                  hallDatesMap[hallname]!
                      .any((bookedDate) => _isSameDate(bookedDate, day))) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Text(day.day.toString(),
                          style: const TextStyle(color: Colors.white))),
                );
              }
              return null;
            },
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay[index] = selectedDay;
              _focusedDay = focusedDay;
              bookPeriod(selectedDay, hallname);
            });
          },
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay[index], day);
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
      ),
    ];
  }
}

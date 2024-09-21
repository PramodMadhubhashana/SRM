import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/book_equiqment.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/service/service.dart';
import 'package:table_calendar/table_calendar.dart';

class LecHalle extends StatefulWidget {
  final String id;
  const LecHalle({super.key, required this.id});

  @override
  State<LecHalle> createState() => _LecHalleState();
}

class _LecHalleState extends State<LecHalle> {
  DateTime _focusedDay = DateTime.now();
  late final Map<String, DateTime?> _selectedDay = {widget.id: null};
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  BookingPeriod? _selectPeriod;
  final AuthService _authService = AuthService();
  String? _currentBookingPeriod;

  List<DateTime> _bookedDates = [];
  Future<void> fetchBookedDates() async {
    try {
      final List<DateTime> bkdts = await _authService.bookDate();
      setState(() {
        _bookedDates = bkdts;
      });
    } catch (e) {
      print("Error fetching booked dates: $e");
    }
  }

  List<Map<String, dynamic>> _bookedPeriod = [];

  Future<void> fetchBookPeroid() async {
    List<Map<String, dynamic>> bookings = await _authService.bookPeroid();

    setState(() {
      _bookedPeriod = bookings;
    });
  }

  String? getBookingPeriod(DateTime day) {
    for (var booking in _bookedPeriod) {
      if (booking.containsKey('date') && _isSameDate(day, booking['date'])) {
        return booking['period'];
      }
    }
    return null;
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBookPeroid();
    fetchBookedDates();
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
                child: const Sidebar(),
              ),
            Expanded(
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
                    Expanded(
                      child: StreamBuilder<List<Map<String, dynamic>>>(
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
                                                  children: _buildChildrens(),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: _buildChildrens(),
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
                                            "Selected Booking Period: ${_currentBookingPeriod == "BookingPeriod.morning" ? "Morning" : _currentBookingPeriod == "BookingPeriod.evening" ? "Evening" : _currentBookingPeriod == "BookingPeriod.Full Day" ? "Full day" : "No Booking "}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      LayoutBuilder(
                                        builder: (context, constraints) {
                                          return constraints.maxWidth > 600
                                              ? Row(children: _radioListTile())
                                              : Column(
                                                  children: _radioListTile());
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final selectedDate =
                                              _selectedDay[widget.id];

                                          if (selectedDate != null) {
                                            try {
                                              final result = await _authService
                                                  .booklechalls(
                                                      lecHall['Halle Name'],
                                                      selectedDate,
                                                      _selectPeriod.toString(),
                                                      widget.id);

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Lecture hall booked successfully')),
                                              );
                                              await fetchBookedDates();

                                              setState(() {
                                                _selectedDay[widget.id] = null;
                                                _selectPeriod =
                                                    BookingPeriod.morning;
                                              });
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

  List<Widget> _radioListTile() {
    return [
      SizedBox(
        width: 160,
        child: RadioListTile<BookingPeriod>(
          title: const Text('Morning'),
          value: BookingPeriod.morning,
          groupValue: _selectPeriod,
          onChanged: (BookingPeriod? value) {
            setState(() {
              _selectPeriod = value!;
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
              _selectPeriod = value!;
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
              _selectPeriod = value!;
            });
          },
        ),
      ),
    ];
  }

  List<Widget> _buildChildrens() {
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
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay[widget.id] = selectedDay;
              _focusedDay = focusedDay;
              _currentBookingPeriod = getBookingPeriod(selectedDay);
            });
          },
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay[widget.id], day);
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              if (_bookedDates
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:table_calendar/table_calendar.dart';

class BookLecHall extends StatefulWidget {
  const BookLecHall({super.key});

  @override
  State<BookLecHall> createState() => _BookLecHallState();
}

enum BookingPeriod { morning, evening, fullDay }

class _BookLecHallState extends State<BookLecHall> {
  // late CalendarFormat _calendarFormat;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  BookingPeriod? _selectPeriod;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Scaffold(
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
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
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
                                    "Halle No ${index + 1}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      if (constraints.maxWidth < 600) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: _buildchildrens(),
                                        );
                                      } else {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: _buildchildrens(),
                                        );
                                      }
                                    },
                                  ),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "No Of Chair : 542",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "No Of Desk :555 ",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Capacity :555 ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "No Of computers :555 ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Booking Period : 2024/03/08 full day ",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      if (constraints.maxWidth > 600) {
                                        return Row(
                                          children: _radioListTile(),
                                        );
                                      } else {
                                        return Column(
                                          children: _radioListTile(),
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Appcolors.primaryTextColor),
                                    child: const Text(
                                      "Book",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
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
        )),
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

  List<Widget> _buildchildrens() {
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
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
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

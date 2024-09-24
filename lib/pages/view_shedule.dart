import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/service/service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class ViewShedule extends StatefulWidget {
  final String id;
  const ViewShedule({super.key, required this.id});

  @override
  State<ViewShedule> createState() => _ViewSheduleState();
}

class _ViewSheduleState extends State<ViewShedule> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  final AuthService _authService = AuthService();
  final TextEditingController _titleController = TextEditingController();

  Future<void> addShedule() async {
    String _title = _titleController.text.trim();

    if (_title.isEmpty || _selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Add the title and Date.",
            style: TextStyle(color: Colors.redAccent, fontSize: 16),
          ),
        ),
      );
      return;
    }

    final result = await _authService.AddScedule(
      widget.id,
      _title,
      _selectedDay.toString(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result == "Succesful" ? "Add Succesful." : "Add fail"),
      ),
    );
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
                physics: const ScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 400,
                      width: screenSize.width,
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
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      width: 350,
                      child: TextField(
                        controller: _titleController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Add Title",
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
                    ElevatedButton(
                      onPressed: addShedule,
                      child: const Text(
                        "Add",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        height: 600,
                        child: StreamBuilder(
                          stream: _authService.getShedule(widget.id),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            var items = snapshot.data!.docs;

                            return ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                var item =
                                    items[index].data() as Map<String, dynamic>;
                                String scheduleid = item['Id'];
                                String dateString = item['Date'];

                                DateTime dateTime = DateTime.parse(dateString);
                                String formattedDateTime =
                                    DateFormat('yyyy-MM-dd').format(dateTime);

                                return Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['title'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(formattedDateTime),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                              onPressed: () async {
                                                final result =
                                                    await _authService
                                                        .deleteSchedule(
                                                            scheduleid);

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      result == "Succesfull"
                                                          ? "Delete Successful."
                                                          : "Delete fail",
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                                size: 15,
                                                color: Colors.red,
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:srm/admin/add_requiqment.dart';
import 'package:srm/admin/equiqmentlist.dart';
import 'package:srm/admin/studentList.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/book_equiqment.dart';
import 'package:srm/pages/book_lec_hall.dart';
import 'package:srm/pages/msg.dart';
import 'package:srm/pages/notifications.dart';
import 'package:srm/pages/profile.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/pages/view_shedule.dart';
import 'package:srm/service/service.dart';
import 'package:intl/intl.dart';

class Nonacadamichomepage extends StatefulWidget {
  final String id;
  const Nonacadamichomepage({super.key, required this.id});

  @override
  State<Nonacadamichomepage> createState() => _NonacadamichomepageState();
}

class _NonacadamichomepageState extends State<Nonacadamichomepage> {
  final AuthService _authservice = AuthService();
  int stdCount = 0;
  int admincount = 0;
  int hallCount = 0;
  int eqmttCount = 0;
  int schlCount = 0;
  int lectureCount = 0;
  int nonStarffCount = 0;
  String? url;

  Future<void> getCounts() async {
    try {
      final int count = await _authservice.studentCount();
      final int adcount = await _authservice.adminCount();
      final int cnt = await _authservice.lecHalleCount();
      final int counteqm = await _authservice.equiqmentCount();
      final int shdlcnt = await _authservice.scheduleCount();
      final int lec = await _authservice.lecturetCount();
      final int staff = await _authservice.staffCount();
      setState(() {
        admincount = adcount;
        stdCount = count;
        hallCount = cnt;
        eqmttCount = counteqm;
        schlCount = shdlcnt;
        lectureCount = lec;
        nonStarffCount = staff;
      });
    } catch (e) {
      return;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCounts();
  }

  Future<void> getProfileImage() async {
    try {
      String? img = await _authservice.getUserImage(widget.id);
      setState(() {
        url = img;
      });
    } catch (e) {}
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
              child: Sidebar(id: widget.id),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: screenSize.width < 480
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.end,
                        children: [
                          if (screenSize.width < 480)
                            Text(
                              "WELCOME SMR",
                              style: TextStyle(
                                fontSize: 30,
                                color: Appcolors.primaryTextColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Notifications(
                                        id: '',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.notifications,
                                ),
                                iconSize: 30,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Msg(stId: widget.id),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.message,
                                ),
                                iconSize: 30,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Profile(id: widget.id),
                                    ),
                                  );
                                },
                                child: ClipOval(
                                  child: Image.network(
                                    url!,
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.fitWidth,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
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
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          runAlignment: WrapAlignment.spaceBetween,
                          spacing: 15.0,
                          runSpacing: 15.0,
                          children: [
                            _homecart("Available Lecture Halle",
                                Icons.meeting_room_outlined, "$hallCount", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookLecHall(id: widget.id),
                                ),
                              );
                            }),
                            _homecart("Book Equiqment",
                                Icons.inventory_2_outlined, "$eqmttCount", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookEquiqment(id: widget.id),
                                ),
                              );
                            }),
                            _homecart("View Shedule", Icons.schedule_outlined,
                                "$schlCount", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ViewShedule(id: widget.id),
                                ),
                              );
                            }),
                            _homecart("Equiqments",
                                Icons.settings_input_component, "", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddRequiqment(id: widget.id),
                                ),
                              );
                            }),
                            _homecart(
                                "Equiqments List",
                                Icons.settings_input_component_outlined,
                                "$admincount", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Equiqmentlist(id: widget.id),
                                ),
                              );
                            }),
                            if (screenSize.width < 600)
                              _homecart(
                                  "Add Equiqments",
                                  Icons.settings_input_component_outlined,
                                  "", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddRequiqment(id: widget.id),
                                  ),
                                );
                              }),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Activity",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Appcolors.primaryTextColor,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 3,
                              width: screenSize.width,
                              color: Appcolors.primaryTextColor,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 500,
                              width: screenSize.width,
                              child: StreamBuilder(
                                stream: _authservice.getActivity(widget.id),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  var items = snapshot.data!.docs;
                                  return ListView.builder(
                                    physics: const ScrollPhysics(
                                      parent: ScrollPhysics(
                                          parent: BouncingScrollPhysics()),
                                    ),
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      var item = items[index].data()
                                          as Map<String, dynamic>;
                                      int secound = item['DateTime'].seconds;
                                      int nanoseconds =
                                          item['DateTime'].nanoseconds;
                                      DateTime dateTime =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              secound * 1000);
                                      dateTime = dateTime.add(
                                        Duration(
                                            microseconds: nanoseconds ~/ 1000),
                                      );
                                      String formatedDateTime =
                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                              .format(dateTime);
                                      return Card(
                                        margin: const EdgeInsets.all(10),
                                        child: ListTile(
                                          leading:
                                              const Icon(Icons.notifications),
                                          title: Text(item['Activity']),
                                          subtitle: Text(formatedDateTime),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

Widget _homecart(
  String cartLabel,
  IconData icn,
  String avbl,
  VoidCallback onpresh,
) {
  return Container(
    width: 300,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 10,
          spreadRadius: 1,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            cartLabel,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icn,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                avbl,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: onpresh,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 14,
                  ), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    side: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ), // Border color and width
                  ),
                ),
                child: const Text(
                  "View",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black, // Change text color
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}

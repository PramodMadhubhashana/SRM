import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/book_equiqment.dart';
import 'package:srm/pages/book_lec_hall.dart';
import 'package:srm/pages/msg.dart';
import 'package:srm/pages/notifications.dart';
import 'package:srm/pages/profile.dart';
import 'package:srm/pages/report.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/pages/view_shedule.dart';
import 'package:srm/service/service.dart';
import 'package:srm/service/service.dart';
import 'package:intl/intl.dart';

class Lecturehomepage extends StatefulWidget {
  final String id;
  const Lecturehomepage({super.key, required this.id});

  @override
  State<Lecturehomepage> createState() => _LecturehomepageState();
}

class _LecturehomepageState extends State<Lecturehomepage> {
  final AuthService _authservice = AuthService();
  int hallCount = 0;
  int schlCount = 0;
  int eqmttCount = 0;
  String? url;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hallcount();
    equiqmentCount();
    scheduleCount();
  }

  Future<void> getProfileImage() async {
    try {
      String? img = await _authservice.getUserImage(widget.id);
      setState(() {
        url = img;
      });
    } catch (e) {}
  }

  Future<void> hallcount() async {
    try {
      final int cnt = await _authservice.lecHalleCount();
      setState(() {
        hallCount = cnt;
      });
    } catch (e) {
      return;
    }
  }

  Future<void> equiqmentCount() async {
    try {
      final int count = await _authservice.equiqmentCount();
      setState(() {
        eqmttCount = count;
      });
    } catch (e) {
      return;
    }
  }

  Future<void> scheduleCount() async {
    try {
      final int shdlcnt = await _authservice.scheduleCount();
      setState(() {
        schlCount = shdlcnt;
      });
    } catch (e) {
      return;
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
                width: 300,
                height: screenSize.height,
                child: Sidebar(
                  id: widget.id,
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                child: Column(
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
                                        builder: (context) =>
                                            Notifications(id: widget.id),
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
                                        builder: (context) => Msg(
                                          stId: widget.id,
                                        ),
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            runAlignment: WrapAlignment.spaceBetween,
                            spacing: 15.0,
                            runSpacing: 15.0,
                            children: [
                              _homecart(
                                  "Available Lecture Halle",
                                  Icons.meeting_room_outlined,
                                  "$hallCount",
                                  "Book Halle >>", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookLecHall(id: widget.id),
                                  ),
                                );
                              }),
                              _homecart(
                                "Available Resoureses",
                                Icons.inventory_2_outlined,
                                "10",
                                "Request Resources >>",
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookLecHall(
                                        id: widget.id,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              _homecart(
                                "View Shedule",
                                Icons.schedule_outlined,
                                "$schlCount",
                                "View Shedule",
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewShedule(
                                        id: widget.id,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              _homecart(
                                "Report",
                                Icons.schedule_outlined,
                                "",
                                "Add Report",
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Report(
                                        id: widget.id,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              _homecart(
                                "Equiqments",
                                Icons.settings_input_component,
                                "$eqmttCount",
                                "Request Equiqments >>",
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookEquiqment(
                                        id: widget.id,
                                      ),
                                    ),
                                  );
                                },
                              ),
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
                                              microseconds:
                                                  nanoseconds ~/ 1000),
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
            ),
          ],
        ),
      ),
    );
  }
}

Widget _homecart(String cartLabel, IconData icn, String avbl, String btnlanle,
    VoidCallback onpresh) {
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
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  btnlanle,
                  style: const TextStyle(
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

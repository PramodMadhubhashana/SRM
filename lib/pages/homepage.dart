import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/msg.dart';
import 'package:srm/pages/notifications.dart';
import 'package:srm/pages/sidebar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
                child: const Sidebar(),
              ),
            Expanded(
              child: SingleChildScrollView(
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
                                            const Notifications(),
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
                                        builder: (context) => const Msg(),
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
                                    print("eeee");
                                  },
                                  child: ClipOval(
                                    child: Image.network(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXNHDqxmIYwry1G1NuywsgYUaxJINUmx8trA&s",
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.male);
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
                                "10",
                                "Book Halle >>",
                              ),
                              _homecart(
                                "Available Resoureses",
                                Icons.inventory_2_outlined,
                                "10",
                                "Request Resources >>",
                              ),
                              _homecart(
                                "View Shedule",
                                Icons.schedule_outlined,
                                "10",
                                "View Shedule",
                              ),
                              _homecart(
                                "Equiqments",
                                Icons.settings_input_component,
                                "10",
                                "Request Equiqments >>",
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
                                child: ListView.builder(
                                  physics: const ScrollPhysics(
                                    parent: ScrollPhysics(
                                        parent: BouncingScrollPhysics()),
                                  ),
                                  itemCount: 20,
                                  itemBuilder: (context, index) {
                                    return const Card(
                                      margin: EdgeInsets.all(10),
                                      child: ListTile(
                                        leading: Icon(Icons.notifications),
                                        title: Text("pramod"),
                                        subtitle: Text("Madhubhashana"),
                                      ),
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

Widget _homecart(String cartLabel, IconData icn, String avbl, String btnlanle) {
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
                onPressed: () {},
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

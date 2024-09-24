import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/service/service.dart';

class Reportview extends StatefulWidget {
  final String id;
  const Reportview({super.key, required this.id});

  @override
  State<Reportview> createState() => _ReportviewState();
}

class _ReportviewState extends State<Reportview> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (screenSize.width > 600)
              SizedBox(
                width: 300,
                height: 700,
                child: Sidebar(id: widget.id),
              ),
            Expanded(
              child: StreamBuilder(
                stream: _authService.getReports(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error fetching data"));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No Lec Halls"));
                  }
                  var items = snapshot.data!.docs;

                  return ListView.builder(
                    physics:
                        const ScrollPhysics(parent: BouncingScrollPhysics()),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index].data() as Map<String, dynamic>;
                      Timestamp timestamp = item['Date'];
                      DateTime dateTime = timestamp.toDate();
                      print(item['Id']);

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
                                "Category : ${item['Category']} ",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              Text("Reporter Id : ${item['Id']}"),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(item['Message']),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Report date : $dateTime",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
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
    );
  }
}

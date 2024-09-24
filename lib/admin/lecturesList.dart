import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:srm/pages/profile.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/service/service.dart';

class Lectureslist extends StatefulWidget {
  final String id;
  const Lectureslist({super.key, required this.id});

  @override
  State<Lectureslist> createState() => _LectureslistState();
}

class _LectureslistState extends State<Lectureslist> {
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
                stream: _authService.getlectures(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error fetching data"));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No Lecturs"));
                  }
                  var items = snapshot.data!.docs;

                  return ListView.builder(
                    physics:
                        const ScrollPhysics(parent: BouncingScrollPhysics()),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index].data() as Map<String, dynamic>;
                      Timestamp timestamp = item['Register Date'];
                      DateTime dateTime = timestamp.toDate();
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
                                "Name : ${item['First Name']} ${item['Last Name']}",
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("Role : ${item['role']}"),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("Id : ${item['Id']}"),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("Register Date : $dateTime"),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Profile(
                                            id: item['Id'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text("Edit"),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                    ),
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          });
                                      String? result = await _authService
                                          .deleteUsers(item['Id']);
                                      Navigator.of(context).pop();

                                      if (result == 'Successful') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Delete successfull",
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Delete Fail",
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                    },
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }
}

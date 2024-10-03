import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/service/service.dart';
import 'package:intl/intl.dart';

class Equiqmentlist extends StatefulWidget {
  final String id;
  const Equiqmentlist({super.key, required this.id});

  @override
  State<Equiqmentlist> createState() => _EquiqmentlistState();
}

class _EquiqmentlistState extends State<Equiqmentlist> {
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
                stream: _authService.getequiqment(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error fetching data"));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No Equiqments"));
                  }
                  var items = snapshot.data!.docs;

                  return ListView.builder(
                    physics:
                        const ScrollPhysics(parent: BouncingScrollPhysics()),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index].data() as Map<String, dynamic>;

                      int secound = item['date'].seconds;
                      int nanoseconds = item['date'].nanoseconds;
                      DateTime dateTime =
                          DateTime.fromMillisecondsSinceEpoch(secound * 1000);
                      dateTime = dateTime.add(
                        Duration(microseconds: nanoseconds ~/ 1000),
                      );
                      String formatedDateTime =
                          DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
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
                                "Name : ${item['Name']}",
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("Add Date : $formatedDateTime"),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("Quantity: ${item['qty']}"),
                              const SizedBox(
                                height: 10,
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
                                          child: CircularProgressIndicator(),
                                        );
                                      });
                                  String? result = await _authService
                                      .deleteQuiqments(items[index].id);
                                  Navigator.of(context).pop();

                                  if (result == 'Successful') {
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                                    ScaffoldMessenger.of(context).showSnackBar(
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

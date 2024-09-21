import 'package:flutter/material.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/service/service.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  final String id;
  const Notifications({super.key, required this.id});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (screenSize.width > 600)
              const SizedBox(
                width: 300,
                height: 700,
                child: Sidebar(),
              ),
            Expanded(
              child: StreamBuilder(
                  stream: _authService.getNotifications(widget.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var items = snapshot.data!.docs;
                    if (items.isEmpty) {
                      return const Center(
                        child: Text("No notifications"),
                      );
                    }
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        var item = items[index].data() as Map<String, dynamic>;
                        List notification = item['notifications'] ?? [];
                        return Column(
                          children: notification.map<Widget>((notification) {
                            DateTime dateTime =
                                DateTime.parse(notification['date']);
                            String formatedDateTime =
                                DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(dateTime);
                            return Card(
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                leading: const Icon(Icons.notifications),
                                title: Text(
                                    "${notification['title']} , $formatedDateTime"),
                                subtitle: Text(notification['body']),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

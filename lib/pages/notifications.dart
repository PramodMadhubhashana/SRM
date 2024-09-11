import 'package:flutter/material.dart';
import 'package:srm/pages/sidebar.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final List<Map<String, String>> notifications = [
    {"title": "New Message", "body": "You have received a new message."},
    {"title": "Task Reminder", "body": "Don't forget to complete your tasks."},
    {"title": "Event Invitation", "body": "You are invited to the event."},
    {"title": "Update Available", "body": "A new update is available."},
    {"title": "New Message", "body": "You have received a new message."},
    {"title": "Task Reminder", "body": "Don't forget to complete your tasks."},
    {"title": "Event Invitation", "body": "You are invited to the event."},
    {"title": "Update Available", "body": "A new update is available."},
    {"title": "New Message", "body": "You have received a new message."},
    {"title": "Task Reminder", "body": "Don't forget to complete your tasks."},
    {"title": "Event Invitation", "body": "You are invited to the event."},
    {"title": "Update Available", "body": "A new update is available."},
    {"title": "New Message", "body": "You have received a new message."},
    {"title": "Task Reminder", "body": "Don't forget to complete your tasks."},
    {"title": "Event Invitation", "body": "You are invited to the event."},
    {"title": "Update Available", "body": "A new update is available."},
  ];

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
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: const Icon(Icons.notifications),
                      title: Text(notifications[index]['title']!),
                      subtitle: Text(notifications[index]['body']!),
                    ),
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

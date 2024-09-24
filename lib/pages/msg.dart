import 'package:flutter/material.dart';
import 'package:srm/color/appcolors.dart';
import 'package:srm/pages/sidebar.dart';
import 'package:srm/service/service.dart';
import 'package:intl/intl.dart';

class Msg extends StatefulWidget {
  final String stId;
  const Msg({super.key, required this.stId});

  @override
  State<Msg> createState() => _MsgState();
}

class _MsgState extends State<Msg> {
  final TextEditingController _msgController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> sendMsg() async {
    try {
      String msg = _msgController.text.trim();
      await _authService.msg(msg, widget.stId);
      _msgController.clear();
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    List<String> items =
        List<String>.generate(10, (index) => "Event ${index + 1}");
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (screenSize.width > 600)
              SizedBox(
                height: screenSize.height,
                width: 300,
                child: Sidebar(id: widget.stId),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Messsage",
                        style: TextStyle(
                          fontSize: 20,
                          color: Appcolors.primaryTextColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 200,
                        width: 350,
                        child: TextFormField(
                          controller: _msgController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: 1,
                          decoration: InputDecoration(
                            labelText: "Message",
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
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: Appcolors.primaryTextColor,
                        ).copyWith(
                          elevation: ButtonStyleButton.allOrNull(5),
                        ),
                        onPressed: sendMsg,
                        child: const Text(
                          'Send',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 600,
                    width: screenSize.width - 300,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        height: screenSize.height,
                        child: StreamBuilder(
                          stream: _authService.getmsg(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
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
                                int secound = item['DateTime'].seconds;
                                int nanoseconds = item['DateTime'].nanoseconds;
                                DateTime dateTime =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        secound * 1000);
                                dateTime = dateTime.add(
                                  Duration(microseconds: nanoseconds ~/ 1000),
                                );
                                String formatedDateTime =
                                    DateFormat('yyyy-MM-dd HH:mm:ss')
                                        .format(dateTime);

                                return Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${item['role']} : ${item['name']}"),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "${item['message']} ",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(formatedDateTime),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.close,
                                              size: 15,
                                              color: Colors.red,
                                            ),
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
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

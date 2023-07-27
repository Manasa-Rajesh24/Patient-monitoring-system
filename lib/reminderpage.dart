import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ReminderPage extends StatefulWidget {
  ReminderPage({Key? key}) : super(key: key);
  String title = "";
  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  int _counter = 0;
  List reminders = [
    {"name": "Reminder 1", "date": "2022-06-28", "time": "21:00"},
    {"name": "Reminder 2", "date": "2022-06-29", "time": "15:00"},
    {"name": "Reminder 2", "date": "2022-06-29", "time": "15:00"}
  ];
  String messageTitle = "Empty";
  String notificationAlert = "alert";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
  }

  void _incrementcounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  notificationAlert,
                ),
                Text(
                  messageTitle,
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
            Text(
              "Reminders",
              style: TextStyle(fontSize: 30),
            ),
            Card(
                child: Column(
              children: reminders
                  .map((reminders) => Column(
                        children: [
                          ListTile(
                            title: Text(reminders['name']),
                            subtitle: Text(
                                reminders['date'] + " " + reminders['time']),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  onPressed: _incrementcounter,
                                  icon: Icon(Icons.check)),
                              IconButton(
                                  onPressed: _incrementcounter,
                                  icon: Icon(Icons.delete))
                            ],
                          )
                        ],
                      ))
                  .toList(),
            )
                //Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //children: [
                //reminders.map((reminder) {return (Container(child: ,))})
                // IconButton(
                //     onPressed: _incrementcounter, icon: Icon(Icons.check)),
                // Expanded(
                //   child: ListTile(
                //     title: Text('test'),
                //     subtitle: Text('test'),
                //   ),
                // ),
                // IconButton(
                //     onPressed: _incrementcounter, icon: Icon(Icons.delete)),
                //],
                //),
                )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

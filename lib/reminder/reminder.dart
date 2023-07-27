import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trackapp/reminder/entry_bloc.dart';
import 'package:trackapp/reminder/setreminder.dart';

class Reminder extends StatefulWidget {
  const Reminder({Key? key}) : super(key: key);

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  NewEntryBloc? newEntryBloc;

  @override
  void initState() {
    super.initState();
    newEntryBloc = NewEntryBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<NewEntryBloc>.value(
      value: newEntryBloc!,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 1),
                colors: <Color>[
              Color.fromARGB(255, 112, 185, 203),
              Colors.pink.shade100,
              Color(0xfff39060),
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          //appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Text('Set Reminders!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 30))),
                    Text(
                      '0',
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),

              // Add content to the ListView
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 50,
                        shadowColor: Colors.black,
                        color: Colors.blueGrey,
                        child: SizedBox(
                          width: 300,
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                //CircleAvatar
                                const SizedBox(
                                  height: 10,
                                ), //SizedBox
                                Text(
                                  'Reminders',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ), //Textstyle
                                ),
                              ],
                            ), //Column
                          ), //Padding
                        ), //SizedBox
                      ),
                    ),
                  ],
                ),
              ),

              //Padding(
              //padding: const EdgeInsets.only(top: 100),
              //qwerchild:
              FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: Colors.blueGrey.shade300,
                  onPressed: () {
                    Navigator.pushNamed(context, '/newentry');
                  }),
              //)
            ],
          ),
        ),
      ),
    );
  }
}

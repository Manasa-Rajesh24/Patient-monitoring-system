import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:trackapp/reminder/conver_time.dart';
import 'package:trackapp/reminder/entry_bloc.dart';

class NewEntry extends StatefulWidget {
  const NewEntry({super.key});

  @override
  State<NewEntry> createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  late TextEditingController nameController;
  late TextEditingController dosageController;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  NewEntryBloc? newEntryBloc;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    newEntryBloc = NewEntryBloc();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    nameController = TextEditingController();
    dosageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              'Add New Reminder',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PanelTitle(title: "Medicine's Name", isRequired: true),
                TextFormField(
                  maxLength: 20,
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                  style: TextStyle(),
                ),
                PanelTitle(title: "Dosage in mg", isRequired: false),
                TextFormField(
                  maxLength: 20,
                  controller: dosageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                  style: TextStyle(),
                ),
                PanelTitle(title: "Interval Selection", isRequired: true),
                IntervalSelection(),
                PanelTitle(title: "Starting Time", isRequired: true),
                SizedBox(
                  height: 10,
                ),
                SelectTime(),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 40, left: 130.0, right: 8.0),
                  child: SizedBox(
                    height: 50,
                    width: 100,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Color.fromARGB(108, 44, 42, 42),
                            shape: const StadiumBorder()),
                        onPressed: () {},
                        child: Center(
                            child: Text(
                          'Confirms',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold)),
                        ))),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class SelectTime extends StatefulWidget {
  const SelectTime({super.key});

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = const TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;

  Future<TimeOfDay?> _selectTime() async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _time);
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;
      });
    }
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 300,
      child: Padding(
        padding: const EdgeInsets.only(left: 60, top: 8),
        child: TextButton(
          style: TextButton.styleFrom(
              shape: StadiumBorder(),
              backgroundColor: Color.fromARGB(108, 44, 42, 42)),
          onPressed: () {
            _selectTime();
          },
          child: Center(
            child: Text(
              _clicked == false
                  ? 'Select Time'
                  : "${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}",
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}

class IntervalSelection extends StatefulWidget {
  const IntervalSelection({super.key});

  @override
  State<IntervalSelection> createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  final _intervals = [6, 8, 12, 24];
  var _selected = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Remind me every  ",
            style: TextStyle(),
          ),
          DropdownButton(
            dropdownColor: Colors.blueGrey.shade100,
            elevation: 0,
            hint: _selected == 0
                ? Text(
                    'Select an Interval',
                    style: GoogleFonts.poppins(
                        fontSize: 14.0, fontWeight: FontWeight.w600),
                  )
                : null,
            value: _selected == 0 ? null : _selected,
            items: _intervals.map(
              (int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                  ),
                );
              },
            ).toList(),
            onChanged: (int? newvalue) {
              setState(() {
                _selected = newvalue!;
              });
            },
          ),
          Text(_selected == 1 ? "hour" : "hours"),
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  const PanelTitle({super.key, required this.title, required this.isRequired});
  final String title;
  final bool isRequired;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 20),
      child: Text.rich(TextSpan(children: <TextSpan>[
        TextSpan(
            text: title,
            style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18))),
        TextSpan(
            text: isRequired ? '*' : "",
            style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)))
      ])),
    );
  }
}

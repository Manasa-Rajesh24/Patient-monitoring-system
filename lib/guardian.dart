import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class GuardianHome extends StatefulWidget {
  const GuardianHome({Key? key}) : super(key: key);

  @override
  State<GuardianHome> createState() => _GuardianHomeState();
}

class _GuardianHomeState extends State<GuardianHome> {
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
        appBar: AppBar(
          title: Text(
            'Guardian',
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
          padding: const EdgeInsets.only(top: 170, left: 10, right: 10),
          child: Container(
              child: GridView(
            children: [
              SizedBox(
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 208, 205, 130)
                            .withOpacity(0.25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white38,
                            blurRadius: 10.0,
                            spreadRadius: 15,
                          )
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Padding(padding: EdgeInsets.only(top: 10)),
                        Icon(
                          Icons.account_circle,
                          size: 40,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Reminder',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/reminder');
                  },
                ),
              ),
              SizedBox(
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 131, 198, 231)
                            .withOpacity(0.25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white38,
                            blurRadius: 10.0,
                            spreadRadius: 15,
                          )
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Padding(padding: EdgeInsets.only(top: 10)),
                        Icon(
                          Icons.accessible_forward,
                          size: 40,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Monitor',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/patienthome');
                  },
                ),
              ),
            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
          )),
        ),
      ),
    );
  }
}

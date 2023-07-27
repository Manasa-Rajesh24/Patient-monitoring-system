import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height * 0.3,
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: AssetImage('assets/homebg.jpg'),
                      fit: BoxFit.cover))),
          SingleChildScrollView(
            child: GridView(children: [
              Container(color: Colors.red,),
              Container(color: Colors.green,),
              Container(color: Colors.blue,),
              Container(color: Colors.grey,),
            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10,crossAxisSpacing: 10),),
          )
        ],
      ),
    );
  }
}


/*final Choice? _choice =
                                        await _asyncSimpleDialog(context);
                                        if (_choice == Choice.Guardian) {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(context, '/guardianhome');
                                        }
                                        if (_choice == Choice.Patient) {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(context, '/patienthome');
                                        } */

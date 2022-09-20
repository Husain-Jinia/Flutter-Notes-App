import 'package:flutter/material.dart';
import 'package:journaling_app/pages/Settings/change_pin.dart';
import 'package:journaling_app/pages/Settings/name_update.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 210, 127),
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.amber,
      ),
      // ignore: prefer_const_literals_to_create_immutables
      body:Container(
        margin: const EdgeInsets.only(top: 10),
        child:Column(children: [
          GestureDetector(
         child:const Card(
          child: ListTile(
            horizontalTitleGap: 10,
            minVerticalPadding: 20,
              leading:  Icon(Icons.lock),
              title: Text('Change Pin'),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),
          ),onTap: (){Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => 
                ChangePinPage()),
              );
            },
          ),
          GestureDetector(
          child:const Card(
            
          child: ListTile(
            horizontalTitleGap: 10,
            minVerticalPadding: 20,
              leading:  Icon(Icons.man_outlined),
              title: Text('Change Name'),
              trailing: 
              Icon(Icons.arrow_forward_ios_outlined),
            ),
          ),onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangeName()),
              );
          },)
      ],)
    ));
  }
}
import 'package:flutter/material.dart';
import 'package:journaling_app/pages/change_pin.dart';
import 'package:journaling_app/pages/name_update.dart';

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
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.amber,
      ),
      // ignore: prefer_const_literals_to_create_immutables
      body:Container(
        margin: EdgeInsets.only(top: 10),
        child:Column(children: [
          GestureDetector(
         child:Card(
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
          child:Card(
            
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
                MaterialPageRoute(builder: (context) => 
                ChangeName()),
              );
          },)
      ],)
    ));
  }
}
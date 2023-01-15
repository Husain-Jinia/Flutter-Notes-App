import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:journaling_app/pages/Journals/home.dart';
import 'package:journaling_app/pages/Navigation/navigation.dart';
import 'package:journaling_app/pages/Settings/change_pin.dart';
import 'package:journaling_app/pages/Settings/name_update.dart';

import '../../sharedPreferences.dart';
import '../../utils/enums.dart';
import '../../widgets/PinUpdate/pin_style.dart';
import '../../widgets/rounded_button.dart';
import '../Notifications/fToast_style.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  TextEditingController _pinController = TextEditingController();
  SharedPreferencesService sharedPreferences = SharedPreferencesService();
  late FToast fToast; 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
  }

  checkPin()async{
    String? userPin  = await sharedPreferences.getFromSharedPref('user-pin');
    if(_pinController.text == userPin){
      await sharedPreferences.saveToSharedPref("user-pin", _pinController.text);    
      // ignore: use_build_context_synchronously
      List checklists=[];
      List categories = ["General"];
      List notes=[];
      await sharedPreferences.saveToSharedPref('user-journals',jsonEncode(notes));
      await sharedPreferences.saveToSharedPref('all-categories', jsonEncode(categories));
      await sharedPreferences.saveToSharedPref('all-checklist', jsonEncode(checklists));
      Navigator.pop(context);
       fToast.init(context);
        showToast(fToast, "All notes,checklists and categories deleted", NotificationStatus.success);
       _pinController.text="";
      }else{
        fToast.init(context);
        showToast(fToast, "Incorrect pin entered", NotificationStatus.failure);
         _pinController.text="";
      }
  }
  
  deleteData(){
    return showDialog(
        context: context, 
        builder: (BuildContext context){
          return AlertDialog(
            content: SizedBox(
            height: 170,
            width: 400,
            child: Column(children: [
                SizedBox(height:20),
                ChangePinFormFields(
                  controller: _pinController,
                ),
                Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: 
                    ElevatedButton(onPressed: () { 
                      checkPin();
                     },
                    child: Text("confirm"),)
                )
              )
              ])
            )
          );
        }
      );
  }

  navigateHome() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>  Navigation(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
    WillPopScope(onWillPop:()=> navigateHome(),child: Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 210, 127),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Settings"), GestureDetector(onTap: (){
          Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>  Navigation(),
          ),
        );
        },child: Icon(Icons.home),)]),
        backgroundColor: Colors.amber,
      ),
      // ignore: prefer_const_literals_to_create_immutables
      body:Container(
        margin: const EdgeInsets.only(top: 20,left: 7,right: 7),
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
          SizedBox(height: 5,),
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
          },),
          SizedBox(height: 5,),
          GestureDetector(
          child:const Card(
            
          child: ListTile(
            horizontalTitleGap: 10,
            minVerticalPadding: 20,
              leading:  Icon(Icons.delete_forever),
              title: Text('Delete Data'),
              trailing: 
              Icon(Icons.arrow_forward_ios_outlined),
            ),
          ),onTap: (){
            deleteData();
          },)
      ],)
    )));
  }
}
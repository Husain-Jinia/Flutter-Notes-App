import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journaling_app/sharedPreferences.dart';

import '../widgets/pin_style.dart';
import '../widgets/pin_title.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({Key? key}) : super(key: key);

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {

  @override
  Widget build(BuildContext context) {
  SharedPreferencesService sharedPreferences = SharedPreferencesService();

    TextEditingController _newPinController = TextEditingController();
    TextEditingController _oldPinController = TextEditingController();
    TextEditingController _confirmPinController = TextEditingController();

    handleSubmit()async {
      String? pin = await sharedPreferences.getFromSharedPref('user-pin');
      if(_oldPinController.text.isEmpty || _newPinController.text.isEmpty || _confirmPinController.text.isEmpty){
        print("no");
      }else if(_newPinController.text != _confirmPinController.text){
        print("no");
      }else if(_oldPinController!= pin){
        print("wrong");
      }else{
        await sharedPreferences.saveToSharedPref('user-pin', _newPinController.text);
      }
    }


    Size size = MediaQuery.maybeOf(context)!.size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change PIN"),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(child:Container(
        margin: EdgeInsets.only(top:100),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              PinTitle(
                marginTop: 20,
                title: 'Old Pin',
              ),
              ChangePinFormFields(
                controller: _oldPinController,
              ),
              PinTitle(
                marginTop: 20,
                title: 'New Pin',
              ),
              ChangePinFormFields(
                controller: _newPinController,
              ),
              PinTitle(
                marginTop: 30,
                title: 'confirm Pin',
              ),
              ChangePinFormFields(
                controller: _confirmPinController,  
              ),
            Center(
            child:Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              width: size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xFF000000)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 20, horizontal: 40))),
                  onPressed: (){
                    handleSubmit();
                  },
                  child: Text(
                    "Submit"
                  ),
                ),
              ),
            ) 
        )],)
      ),
    ));
    
  }
}
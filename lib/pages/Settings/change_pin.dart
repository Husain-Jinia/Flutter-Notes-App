import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journaling_app/sharedPreferences.dart';

import '../../widgets/PinUpdate/pin_style.dart';
import '../../widgets/PinUpdate/pin_title.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({Key? key}) : super(key: key);

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {

  @override
  Widget build(BuildContext context) {
  SharedPreferencesService sharedPreferences = SharedPreferencesService();

  TextEditingController newPinController=TextEditingController();
  TextEditingController confirmPinController = TextEditingController();
  TextEditingController oldPinController = TextEditingController();

  

    handleSubmit()async {
      String? pin = await sharedPreferences.getFromSharedPref('user-pin');
      if(oldPinController.text.isEmpty || newPinController.text.isEmpty || confirmPinController.text.isEmpty){
        print("no");
      }else if(newPinController.text != confirmPinController.text){
        print("no");
      }else if(oldPinController.text!= pin){
        print("wrong");
      }else{
        await sharedPreferences.saveToSharedPref('user-pin', newPinController.text);
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
              const PinTitle(
                marginTop: 20,
                title: 'Old Pin',
              ),
              ChangePinFormFields(
                controller: oldPinController,
              ),
              const PinTitle(
                marginTop: 20,
                title: 'New Pin',
              ),
              ChangePinFormFields(
                controller: newPinController,
              ),
              const PinTitle(
                marginTop: 30,
                title: 'confirm Pin',
              ),
              ChangePinFormFields(
                controller: confirmPinController,  
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
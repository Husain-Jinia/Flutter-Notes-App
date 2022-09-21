import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:journaling_app/sharedPreferences.dart';

import '../../utils/enums.dart';
import '../../widgets/PinUpdate/pin_style.dart';
import '../../widgets/PinUpdate/pin_title.dart';
import '../Notifications/fToast_style.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({Key? key}) : super(key: key);

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {

  SharedPreferencesService sharedPreferences = SharedPreferencesService();

  TextEditingController _newPinController=TextEditingController();
  TextEditingController _confirmPinController = TextEditingController();
  TextEditingController _oldPinController = TextEditingController();

  bool isLoading = false;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
  }


  handleSubmit()async {
    String? pin = await sharedPreferences.getFromSharedPref('user-pin');
    if(_oldPinController.text.isEmpty || _newPinController.text.isEmpty || _confirmPinController.text.isEmpty){
      fToast.init(context);
      showToast(fToast, "Pin field cannot be empty", NotificationStatus.failure);
      setState(() {
        isLoading=false;
      });
    }else if(_newPinController.text != _confirmPinController.text){
      fToast.init(context);
      showToast(fToast, "New pin does not match confirm pin", NotificationStatus.failure);
      setState(() {
        isLoading=false;
      });
    }else if(_oldPinController.text!= pin ){
      fToast.init(context);
      showToast(fToast, "The current pin entered is incorrect", NotificationStatus.failure);
      setState(() {
        isLoading=false;
      });
    }else{
      await sharedPreferences.saveToSharedPref('user-pin', _newPinController.text);
      fToast.init(context);
      showToast(fToast, "New pin successfully created", NotificationStatus.success);
      setState(() {
        isLoading=false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change PIN"),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child:Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(top:100),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
              const PinTitle(
                marginTop: 20,
                title: 'Current Pin',        
              ),
              ChangePinFormFields(
                controller: _oldPinController,  
              ),
              const PinTitle(
                marginTop: 20,
                title: 'New Pin',
              ),
              ChangePinFormFields(
                controller: _newPinController,
              ),
              const PinTitle(
                marginTop: 30,
                title: 'confirm Pin',
              ),
              ChangePinFormFields(
                controller: _confirmPinController,  
              ),
            Center(
            child:
            isLoading==false?
            Container(
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
                    setState(() {
                      isLoading=true;
                    });
                    handleSubmit();
                    
                  },
                  child: Text(
                    "Submit"
                  ),
                ),
              ),
            ) 
        :Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              width: size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xFF000000)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 20, horizontal: 40))),
                  onPressed: null,
                  child: Text(
                    "Submit"
                  ),
                ),
              ),
            )) ],)
      ),
    ));
    
  }
}
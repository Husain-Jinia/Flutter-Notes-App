import 'package:flutter/material.dart';

import '../sharedPreferences.dart';
import '../widgets/pin_style.dart';
import '../widgets/pin_title.dart';
import '../widgets/rounded_button.dart';


class AuthenticationPage extends StatefulWidget {

  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  SharedPreferencesService sharedPreferences = SharedPreferencesService();
  TextEditingController _newPinController=TextEditingController();
  TextEditingController _confirmPinController = TextEditingController();
  TextEditingController _pinController = TextEditingController();

  bool isPinCreated =false;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPinCreated();
  }

  checkPinCreated() async{
     String? userPin  = await sharedPreferences.getFromSharedPref('user-pin');
     if(userPin == null || userPin == ""){
      setState(() {
        isPinCreated=false;
      });
     }else{
      setState(() {
        isPinCreated=true;
      });
     }
  }


   @override
  Widget build(BuildContext context) {
    return 
    
    Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 210, 127),
      
      appBar: AppBar(
        title: const Text("Authentication", style: TextStyle(color: Color.fromARGB(255, 93, 22, 22), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
      ),
      body:SingleChildScrollView(child:Container(
      child:Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top:50),
            child: 
            isPinCreated==false?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              PinTitle(
                marginTop: 80,
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
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: 
                    RoundedButton(
                      text: "submit",
                      controller:_newPinController,
                      confirmController:_confirmPinController,
                      isPinCreated: isPinCreated,
                    )
                )
              )
            ]
            ):
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              PinTitle(
                marginTop: 30,
                title: 'Enter Pin',
              ),
              ChangePinFormFields(
                controller: _pinController,
                
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: 
                    RoundedButton(
                      text: "submit",
                      controller:_pinController,
                      confirmController:_confirmPinController,
                      isPinCreated: isPinCreated,
                    )
                )
              )
            ]
            )
          )
        ]
      ))));
          
  }
}
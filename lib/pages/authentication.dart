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
  TextEditingController _nameController = TextEditingController();

  bool isPinCreated =false;
  String userName="";

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
    checkPinCreated();
    
  }

  getName() async{
    String? name = await sharedPreferences.getFromSharedPref('user-name');
    if(name!=null){
      setState(() {
        userName = name;
      });
    }
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
        title: const Center(child:Text("JOURNALIT", style: TextStyle(color: Color.fromARGB(137, 0, 0, 0), fontWeight: FontWeight.bold))),
        backgroundColor: Colors.amber,
      ),
      body:SingleChildScrollView(child:Container(
      child:Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            
            child: 
            isPinCreated==false?
            Column(
              
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Center(child:Image.asset('assets/images/logo-journalit.png', width: 200,height: 200,)),
              // SizedBox(height: 15),
              // Center(child:Text("JORNALiT", style: TextStyle(fontSize: 20),)),
              SizedBox(height:10),
              Center(child:Text("* Fill the information below to continue *",style: TextStyle(fontSize: 15,color: Colors.black38))),
              SizedBox(height:25),
              Container(
                margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                child:TextFormField(
                controller: _nameController,
                
                decoration: InputDecoration(
              labelText: "Name",
              hintText: "Enter your name",
              
              focusColor: Colors.black,
              fillColor: Color.fromRGBO(222, 231, 240, .57),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                borderRadius: BorderRadius.circular(10.0),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
              )),
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
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: 
                    RoundedButton(
                      text: "submit",
                      controller:_newPinController,
                      confirmController:_confirmPinController,
                      nameController:_nameController,
                      isPinCreated: isPinCreated,
                    )
                )
              )
            ]
            ):
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Center(child:Image.asset('assets/images/logo-journalit-2.png', width: 200,height: 200,)),
              Center(child:Text("JOURNALIT", style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold,color: Color.fromARGB(145, 0, 0, 0)),)),
              SizedBox(height:50),
              Center(child:Text("Logging in for $userName",style: TextStyle(fontSize: 15,color: Colors.black))),
              SizedBox(height:20),
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
                      nameController: _nameController,
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
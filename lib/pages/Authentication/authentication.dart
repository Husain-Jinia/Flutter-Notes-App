import 'package:flutter/material.dart';

import '../../sharedPreferences.dart';
import '../../widgets/PinUpdate/pin_style.dart';
import '../../widgets/PinUpdate/pin_title.dart';
import '../../widgets/rounded_button.dart';


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
      body:SingleChildScrollView(child:Column(
        children: [
          SizedBox(
            // height: MediaQuery.of(context).size.height,
            child: 
            isPinCreated==false?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Center(child:Image.asset('assets/images/logo_jit.png', width: 200,height: 200,)),
              // SizedBox(height: 15),
              // Center(child:Text("JORNALiT", style: TextStyle(fontSize: 20),)),
              
              Container(
                height: MediaQuery.of(context).size.height*.65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color.fromARGB(255, 226, 177, 54)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height:20),
                    const Center(child:Text("* Fill the information below to continue *",style: TextStyle(fontSize: 15,color: Colors.black38))),
                    const SizedBox(height:25),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
                      margin: EdgeInsets.only(left: 35,right: 35),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 219, 215, 181),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextFormField(
                        controller: _nameController,
                        validator: (value){
                          if (_nameController.text.isEmpty) {
                            return "Email field cannot be empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your name",
                          labelText: "Name",
                          filled: true,
                          fillColor: Color.fromARGB(255, 219, 215, 182),
                          labelStyle: TextStyle(color: Color.fromARGB(255, 107, 107, 107), fontWeight:FontWeight.bold),
                          focusColor: Color.fromARGB(255, 107, 107, 107),
                          // border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          // focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)
                          border: InputBorder.none
                          
                        )
                      ),
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
                    Container(
                      margin: const EdgeInsets.only(top: 20),
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
                  ],
                ),
              ),
            ]
            ):
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              SizedBox(height: 15,),
              Center(child:Image.asset('assets/images/logo_jit.png', width: 350,height: 350,)),
              
              
              Container(
                height: MediaQuery.of(context).size.height*.45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color.fromARGB(255, 226, 177, 54)
                ),
                child: Column(
                  children: [
                    SizedBox(height:35),
                    // Center(child:Text("JOURNALIT", style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold,color: Color.fromARGB(145, 0, 0, 0)),)),
                    // SizedBox(height:35),
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
                  ],
                ),
              )
            ]
            )
          )
        ]
      )));
          
  }
}
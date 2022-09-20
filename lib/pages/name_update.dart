import 'package:flutter/material.dart';

import '../sharedPreferences.dart';

class ChangeName extends StatefulWidget {
  const ChangeName({Key? key}) : super(key: key);

  @override
  State<ChangeName> createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  SharedPreferencesService sharedPreferences = SharedPreferencesService();
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialName();
  }

  getInitialName() async{
    String? userName = await sharedPreferences.getFromSharedPref('user-name');
    if(userName!=null){
      setState(() {
        _nameController.text = userName;
      });
    }
  }

  handleSubmit() async{
    await sharedPreferences.saveToSharedPref('user-name', _nameController.text);
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Name"),
        backgroundColor: Colors.amber,
      ),
      body:Container(
        child:Column(
          children:[
            Container(
              margin: EdgeInsets.fromLTRB(20,100,20,0),         
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
            )
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
                    child: const Text(
                      "Submit"
                    ),
                  ),
                ),
              ) 
            )
          ]
        )
      )
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:journaling_app/sharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/enums.dart';
import '../Notifications/fToast_style.dart';

class EditPage extends StatefulWidget {

  final String title;
  final String body;
  final String tag;
  final dynamic index;

  const EditPage({Key? key, required this.title, required this.body, required this.tag, required this.index}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  SharedPreferencesService sharedPreferences = SharedPreferencesService();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  Map<String,dynamic> journal = {
    "title":"",
    "body":"",
    "tags":"General",
    "date":null,
  };  
  bool isLoading = false;
  String currentCategory = "General";
  List categories = ["General", "Travel", "Study", "Todo", "Diary", ];
  List<dynamic> journals=[];
  int index=0;
  late FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.index;
    getNotes();
    getCategories();
    fToast = FToast();
  }

  getCategories()async {
    String? allCategories = await sharedPreferences.getFromSharedPref('all-categories');
    if (allCategories == null) {
      await sharedPreferences.saveToSharedPref('all-categories', jsonEncode(categories));
    } else {
      List  setCategories = jsonDecode(allCategories);
      setState(() {
        categories = setCategories;
      });
    }
  }

  getNotes() async {
    String? allJournals  = await sharedPreferences.getFromSharedPref('user-journals');
     if(allJournals!=null){
        List decodedJournals = jsonDecode(allJournals);
        List reversedList = List.from(decodedJournals.reversed);
        setState(() {
          titleController.text =reversedList[index]["title"]; 
          bodyController.text=reversedList[index]["body"] ;
          currentCategory =reversedList[index]["tags"] ;
        });
     }
  }

  handleSubmit()async{
    if (titleController.text.isEmpty) {
      fToast.init(context);
      showToast(fToast, "Title cannot be empty", NotificationStatus.failure);
      setState(() {
        isLoading=false;
      });
    }else{
      setState(() {
        isLoading=false;
      });
      String? allJournals  = await sharedPreferences.getFromSharedPref('user-journals');
      if(allJournals!=null){
        List decodedJournals = jsonDecode(allJournals);
        List reversedList = List.from(decodedJournals.reversed);
        reversedList[index]["title"] = titleController.text;
        reversedList[index]["body"] = bodyController.text;
        reversedList[index]["tags"] = currentCategory;
        await sharedPreferences.saveToSharedPref('user-journals',jsonEncode(decodedJournals));
        fToast.init(context);
        showToast(fToast, "Note updated successfully. Refresh to see the updated note", NotificationStatus.success);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 219, 210, 127),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Add page"),
      ),
      
      floatingActionButton: 
      isLoading?
      FloatingActionButton.extended(
        onPressed: (){
        },
        tooltip: 'wait',
        label: const Text("submitting.... please wait"),
      ):FloatingActionButton.extended(
        onPressed: (){
          setState(() {
            true;
          });
          handleSubmit();
        },
        tooltip: 'Add',
        label: const Text("Save edited note"),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child:Column(
          children: [
             Container(
              
              child:TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title"
                ),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
             ),
              InputDecorator(
                  decoration: const InputDecoration(
                    border: InputBorder.none
                  ),
                  child:DropdownButton<String>(
                  style: const TextStyle(fontSize:16,color: Color.fromARGB(255, 0, 0, 0)),
                  autofocus: true,
                  value: currentCategory,
                  items: categories.map<DropdownMenuItem<String>>((t) {
                    return DropdownMenuItem<String>(
                      value: t,
                      child: Text(t),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    currentCategory = newVal!;
                    setState(() {
                      currentCategory = newVal;
                    });
                  },             
                )
              ),    
             Expanded(
                child:TextFormField(
                  controller: bodyController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Start by typing your notes here",
                    border: InputBorder.none
                  ),
                )),           
              ],
            ),
            
      )
    );
  }
}